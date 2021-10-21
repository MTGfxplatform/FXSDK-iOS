//
//  FXSDK.m
//  FX
//
//  Created by FXMVP on 2021/9/26.
//

#import "FXSDK.h"
#import "FXMacroDefine.h"
#import "FXGlobal.h"
#import "FXRequestManager.h"
#import "FXBaseConstants.h"
#import "FXDeviceInfo.h"
#import "FXUtil.h"
#import "FXEventDB.h"

@interface FXSDK ()

@property (nonatomic,assign)BOOL isSdkInitialized;
@property (nonatomic, strong) dispatch_queue_t ioQueue;

@end

@implementation FXSDK

SINGLETON_IMPLE(FXSDK)

+(void)load{

    [[FXGlobal sharedInstance] setMarkOnFirstActiveDay];
    [FXEventDB recoverEventDBEventStatus];
}

-(instancetype)init{
    if (self = [super init]) {
        _ioQueue = dispatch_queue_create("com.fxmvp.FXEventQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark open api -

- (void)setDebugModel:(BOOL)isDebug{
    
    [[FXGlobal sharedInstance] setDebugModel:isDebug];
}


- (void)setAppID:(nonnull NSString *)appId{

    BOOL debug = [FXGlobal sharedInstance].debugModel;

    if (!appId) {
        DLog(@"appId should not be nil");
        
        if (debug) {
            @throw [NSException exceptionWithName:@"Invalid appId" reason:@"appId should not be nil" userInfo:nil];
        }
        return;
    }

    if (![appId isKindOfClass:[NSString class]]) {

        DLog(@"appId should be a string value");

        if (debug) {
            @throw [NSException exceptionWithName:@"Invalid appId" reason:@"appId should be a string value" userInfo:nil];
        }
        return;
    }

    [[FXGlobal sharedInstance] setAppID:appId];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _isSdkInitialized = YES;

        //fetch fxId from server
        [FXRequestManager requestFXID];
        [[FXDeviceInfo sharedInstance] fetchUserAgentViaWKWebView];

        [FXRequestManager  sendCachedEvents];
    });

}

- (void)track:(NSString *)eventName withProperties:(NSDictionary *)properties{

    BOOL debug = [FXGlobal sharedInstance].debugModel;

    if (!_isSdkInitialized) {
        
        if (debug) {
            @throw [NSException exceptionWithName:@"Error" reason:@"Event should be sent after initializing FXSDK." userInfo:nil];
        }else{
            DLog(@"SDK not initialized, so the event will be discard");
        }
        return;
    }
    
    if (![NSJSONSerialization isValidJSONObject:properties]) {
        
        if (debug) {
            @throw [NSException exceptionWithName:@"Error" reason:@"The attributes is an invalid object" userInfo:nil];
        }else{
            DLog(@"The attributes is an invalid object");
        }
        return;
    }
    
    if ([eventName hasPrefix:@"$"]) {
        if (debug) {
            @throw [NSException exceptionWithName:@"Error" reason:@"The eventName should not has prefix \"$\"" userInfo:nil];
        }else{
            DLog(@"The eventName should not has prefix \"$\"");
        }
        return;
    }

    dispatch_async(self.ioQueue, ^{
        
        [FXRequestManager sendEvent:eventName attribute:properties];
    });
}


- (void)trackIAPWithAttributes:(FXEvent_IAP_Attribute *)attribute{
    
    BOOL debug = [FXGlobal sharedInstance].debugModel;

    if (!_isSdkInitialized) {
        
        if (debug) {
            @throw [NSException exceptionWithName:@"Error" reason:@"Event should be sent after initializing FXSDK." userInfo:nil];
        }else{
            DLog(@"SDK not initialized, so the event will be discard");
        }
        return;
    }
    
    if (![attribute isKindOfClass:FXEvent_IAP_Attribute.class]) {
        if (debug) {
            @throw [NSException exceptionWithName:@"Error" reason:@"attribute value should be object of FXEvent_IAP_Attribute." userInfo:nil];
        }else{
            DLog(@"attribute value should be object of FXEvent_IAP_Attribute.");
        }
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    NSMutableArray *items = [NSMutableArray new];
    for (FXEvent_IAP_Attribute_Item *item in attribute.items) {
        if (item.name) {
            [items addObject:@{FXEventConstant_IAP_Name:item.name, FXEventConstant_IAP_Count:@(item.count)}];
        }
    }
    [FXUtil setObject:items forKey:FXEventConstant_IAP_Items  forDic:dict];
    [FXUtil setObject:attribute.currency?attribute.currency:@"" forKey:FXEventConstant_IAP_Currency forDic:dict];
    [FXUtil setObject:@(attribute.amount) forKey:FXEventConstant_IAP_Amount forDic:dict];

    NSString *paystatus = @"";
    switch (attribute.paystatus) {
        case FXEventConstant_IAP_PayStatus_none:
            paystatus = @"";
            break;
        case FXEventConstant_IAP_PayStatus_success:
            paystatus = @"success";
            break;
        case FXEventConstant_IAP_PayStatus_fail:
            paystatus = @"fail";
            break;
        case FXEventConstant_IAP_PayStatus_restored:
            paystatus = @"restored";
            break;
        default:
            break;
    }

    [FXUtil setObject:paystatus forKey:FXEventConstant_IAP_Paystatus forDic:dict];
    [FXUtil setObject:attribute.transaction_id?attribute.transaction_id:@"" forKey:FXEventConstant_IAP_TransactionId forDic:dict];
    [FXUtil setObject:attribute.fail_reason?attribute.fail_reason:@"" forKey:FXEventConstant_IAP_FailReason forDic:dict];
   
    
    dispatch_async(self.ioQueue, ^{

        [FXRequestManager sendEvent:kFXEventNameIAP attribute:dict];

    });
}



@end
