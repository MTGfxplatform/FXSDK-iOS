//
//  FXRequestManager.m
//  FX
//
//  Created by FXMVP on 2021/9/30.
//

#import "FXRequestManager.h"
#import "FXHTTPNetworkSession.h"
#import "FXURLRequest.h"
#import "FXRequestParameterBuilder.h"
#import "FXUtil.h"
#import "FXMacroDefine.h"
#import "FXEventDB.h"
#import "FXBaseConstants.h"
#import "FXUserDefaultManager.h"
#import "FXGlobal.h"
#import "FXAPIEndpoints.h"

@interface FXRequestManager ()

@property(nonatomic,strong) dispatch_semaphore_t semaphore;

@property(nonatomic,strong) dispatch_queue_t concurrentQueue;

@property(nonatomic,assign) BOOL loadingForRequestFXID;

@end

@implementation FXRequestManager
SINGLETON_IMPLE(FXRequestManager)

- (id)init
{
    if (self = [super init]) {

        self.semaphore = dispatch_semaphore_create(5);
        self.concurrentQueue = dispatch_queue_create("com.fxmvp.PostEventQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


#pragma mark - public methods

+ (void)requestFXID{
    

    NSURL *url = [FXAPIEndpoints buildGetFxidURL];
    
    NSDictionary *dict = [FXRequestParameterBuilder fetchBaseParameter];

    [[FXGlobal sharedInstance] requestFXIDTryTimesIncrease];

    FXURLRequest * request = [FXURLRequest requestWithURL:url HTTPMethod:@"GET" attribution:dict];

    [FXRequestManager sharedInstance].loadingForRequestFXID = YES;

    [FXHTTPNetworkSession startTaskWithHttpRequest:request responseHandler:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
//        MPLogDebug(@"Successfully sent before load URL: %@", beforeLoadURL);
        
        [FXRequestManager sharedInstance].loadingForRequestFXID = NO;

        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (![responseDictionary isKindOfClass:[NSDictionary class]]) {
            //error:

            return;
        }

        NSNumber *codeNumber = [responseDictionary objectForKey:@"code"];
        if (!codeNumber || ![codeNumber isKindOfClass:[NSNumber class]]) {
            //error:

            return;
        }
        
        NSInteger code = [[responseDictionary objectForKey:@"code"] integerValue];
        if (code != 200) {
            //error:
            
            return;
        }
        
//        NSString *msg = [responseDictionary objectForKey:@"msg"];
        NSDictionary *response_data = [responseDictionary objectForKey:@"data"];
        if (![response_data isKindOfClass:[NSDictionary class]]) {
            //error:
            
            return;
        }
        NSString *fx_id = [response_data objectForKey:@"fx_id"];
        if (fx_id && [fx_id isKindOfClass:NSString.class]) {

                [[FXGlobal sharedInstance] refreshFXID:fx_id];
                [self sendCachedEvents];
        }

    } errorHandler:^(NSError * _Nonnull error) {

        [FXRequestManager sharedInstance].loadingForRequestFXID = NO;
    }];
}

+ (void)sendEvent:(NSString *)eventName attribute:(NSDictionary *)attribute{
    
    [FXUtil performBlockOnMainThread_fx:^{
        [self _sendEvent:eventName attribute:attribute];
    }];
}
+ (void)_sendEvent:(NSString *)eventName attribute:(NSDictionary *)attribute{

    NSString *uniqueId = [FXUtil getUUIDString];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[FXRequestParameterBuilder fetchBaseParameter]];
    
    [dict addEntriesFromDictionary:[FXRequestParameterBuilder fetchEventCommonParameterWithEventID:uniqueId]];
    [FXUtil setObject:eventName forKey:kFXEventParameterKeyEventName forDic:dict];
    [FXUtil setObject:attribute forKey:kFXEventParameterKeyEventData forDic:dict];

    if ([eventName isEqualToString:kFXEventNameAppEnd]) {
        FXGlobal *g = [FXGlobal sharedInstance];
        [FXUtil setObject:@(g.duration) forKey:kFXEventParameterDuration forDic:dict];
    }
    
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *eventDataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    if (error != nil) {
        //log error
        NSAssert(!error, @"jsonData not an valid JSON");
        return;
    }
    //insert data to db
    [self _saveEvent:eventName eventDataString:eventDataString uniqueId:uniqueId];

    [[FXGlobal sharedInstance] eventNumberIncrease];

    if (![FXGlobal sharedInstance].app_id) {
        
        return;
    }
    if (![FXGlobal sharedInstance].fx_id) {
        //如果现在还没fx_id，则暂不发送
        BOOL loading = [FXRequestManager sharedInstance].loadingForRequestFXID;
        if (loading) {
            return;
        }

        NSInteger tryTimes = [[FXGlobal sharedInstance] requestFXIDTryTimesNSInteger];
        if (tryTimes >= 3) {
            //ignore, can send event
        }else{
            [self requestFXID];
            return;
        }
    }
    
    //post data to server
    [self _reportEventDatas:@[dict] uniqueIds:@[uniqueId]];
}


+ (void)sendCachedEvents{

    //read cached failed event from db
    NSArray<FXEventObject *>  *cachedEvents = [FXEventDB queryCachedEvent:30];

    if (cachedEvents.count  == 0) {
        return;
    }
    
    NSMutableArray *eventDatas = [NSMutableArray new];
    NSMutableArray *uniqueIDs = [NSMutableArray new];
    FXGlobal *g = [FXGlobal sharedInstance];
    for (int i = 0; i < cachedEvents.count; i++) {
            
        FXEventObject *eventObject = [cachedEvents objectAtIndex:i];
        
        NSData *data = [eventObject.eventData dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            NSError *error = nil;
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSAssert(!error, @"data not an valid JSON");
            if (!error && [dataDict isKindOfClass:NSDictionary.class]) {
                NSMutableDictionary *eventData = [NSMutableDictionary dictionaryWithDictionary:dataDict];

                NSString *appId_In_cachedEvent = [dataDict objectForKey:kFXEventParameterKeyAppId];
                if (!appId_In_cachedEvent && !g.app_id) {
                    return;
                }
                
                if (!eventData) {
                    return;
                }
                
                if (!eventObject.uniqueID) {
                    return;
                }
                
                if (!appId_In_cachedEvent && g.app_id) {
                    [FXUtil setObject:g.app_id forKey:kFXEventParameterKeyAppId forDic:eventData];
                }
                
                
                NSString *fx_id_In_cachedEvent = [dataDict objectForKey:kFXEventParameterKeyFX_id];
                if (!fx_id_In_cachedEvent) {
                    if (!g.fx_id) {
                        NSInteger tryTimes = [[FXGlobal sharedInstance] requestFXIDTryTimesNSInteger];
                        if (tryTimes < 3) {
                            return;
                        }
                    }
                }


                [FXUtil setObject:g.fx_id forKey:kFXEventParameterKeyFX_id forDic:eventData];
                
                [eventDatas addObject:eventData];
                [uniqueIDs addObject:eventObject.uniqueID];
            }
        }
    }
    
    
    if (uniqueIDs.count == 0) {
        return;
    }

    [self _reportEventDatas:eventDatas uniqueIds:uniqueIDs];

}

#pragma mark - Events handlers
+ (void)_reportEventDatas:(NSArray *)eventDatas  uniqueIds:(NSArray *)uniqueIds{

    NSURL *url = [FXAPIEndpoints buildPostEventURL];

    NSDictionary *parameters = [FXRequestParameterBuilder buildEventParameterWithEventDatas:eventDatas];

    FXURLRequest * request = [FXURLRequest requestWithURL:url HTTPMethod:@"POST" attribution:parameters];
    FXRequestManager *manager = [FXRequestManager sharedInstance];
    dispatch_async(manager.concurrentQueue, ^{

        [FXEventDB markEventReportingWithUniqueIDs:uniqueIds];

        //POST
        [FXHTTPNetworkSession startTaskWithHttpRequest:request  responseHandler:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {

            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            if (![responseDictionary isKindOfClass:[NSDictionary class]]) {
                //error:
                dispatch_semaphore_signal(manager.semaphore);
                return;
            }

            NSNumber *codeNumber = [responseDictionary objectForKey:@"code"];
            if (!codeNumber || ![codeNumber isKindOfClass:[NSNumber class]]) {
                //error:
                
                dispatch_semaphore_signal(manager.semaphore);
                return;
            }
            
            NSInteger code = [[responseDictionary objectForKey:@"code"] integerValue];
            if (code == 200) {
                //delete data from db
                [self _deleteEventWithUniqueId:uniqueIds];
                [FXEventDB recoverFailedEventDBEventStatus];

                [self sendCachedEvents];
            }
            dispatch_semaphore_signal(manager.semaphore);

        } errorHandler:^(NSError * _Nonnull error) {
            //print error
            [FXEventDB markEventFailedWithUniqueIDs:uniqueIds];

            DLog(@"report event failed, error: %@",error);
            dispatch_semaphore_signal(manager.semaphore);

        }];
        
        dispatch_semaphore_wait(manager.semaphore, DISPATCH_TIME_FOREVER);

    });
}

+ (void)_saveEvent:(NSString *)eventName eventDataString:(NSString *)eventDataString uniqueId:(NSString *)uniqueId{

    [FXEventDB insertEventName:eventName data:eventDataString uniqueID:uniqueId];
}

+ (void)_deleteEventWithUniqueId:(NSArray *)uniqueIds{

    [FXEventDB deleteEventWithUniqueIDs:uniqueIds];
}

#pragma mark - Private methods




@end
