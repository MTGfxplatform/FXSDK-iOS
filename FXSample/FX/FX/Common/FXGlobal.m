//
//  FXGlobal.m
//  FX
//
//  Created by FXMVP on 2021/9/26.
//

#import "FXGlobal.h"
#import "FXMacroDefine.h"
#import "FXUserDefaultManager.h"
#import "FXUtil.h"
#import <UIKit/UIApplication.h>
#import "FXRequestManager.h"
#import "FXBaseConstants.h"
#import "FXSDK.h"
#import "FXDeviceInfo.h"
#import "FXDatabaseManager.h"



#import "FXEventDB.h"

@interface FXGlobal ()

@property (nonatomic,assign,readwrite)BOOL debugModel;
@property (nonatomic,copy,readwrite)NSString *app_id;
@property (nonatomic,copy,readwrite)NSString *session_id;
@property (nonatomic,assign,readwrite)NSTimeInterval startTime;
@property (nonatomic,assign,readwrite)NSTimeInterval endTime;

@property (nonatomic,copy,readwrite)NSString *fx_id;

@property (nonatomic,assign)NSInteger requestFXIDTryTimes;
@property (nonatomic,assign)BOOL enable_UIApplicationWillEnterForeground;

/*
 @property (nonatomic,copy,readwrite)NSString *channel;
*/

@end

@implementation FXGlobal

SINGLETON_IMPLE(FXGlobal)


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    if (self = [super init]) {


        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_UIApplicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_UIApplicationWillEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_UIApplicationDidFinishLaunching)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        
        self.startTime = 0;
        self.endTime   = 0;
        self.requestFXIDTryTimes = 0;
    }
    return self;
}



#pragma mark public method -
- (void)setMarkOnFirstActiveDay{
    
    if ([FXUserDefaultManager objectForKey:fxsdk_kActiveTime]) {
        ;//old user
    }else{

        NSString *activeDate = [FXUtil timeStampString];
        [FXUserDefaultManager setObject:activeDate forKey:fxsdk_kActiveTime];
    }
}

/*
- (void)setChannel:(NSString *)channelName{
    if (![channelName isKindOfClass:[NSString class]]) {
        return;
    }

    if (channelName.length > 0) {
        self.channel = channelName;
    }else{
        self.channel = @"";//
    }
}
*/

- (void)setDebugModel:(BOOL)isDebug{
    _debugModel = isDebug;
}

- (void)setAppID:(NSString *)app_id{
    if (![app_id isKindOfClass:[NSString class]]) {
        return;
    }

    self.app_id = app_id;
}

- (void)refreshFXID:(NSString *)fx_Id{
    if (!fx_Id) {
        return;
    }

    [FXUserDefaultManager setObject:fx_Id forKey:fxsdk_kFxId];
    self.fx_id = fx_Id;
}


- (NSInteger)eventLogNumberNSInteger{
 
    NSString *cachedTimeStampString = [FXUserDefaultManager objectForKey:fxsdk_kLogCountDate];
    if (!cachedTimeStampString) {
        NSString *_timeStampString = [FXUtil timeStampString];
        [FXUserDefaultManager setObject:_timeStampString forKey:fxsdk_kLogCountDate];
        [FXUserDefaultManager setInteger:0 forKey:fxsdk_kLogCountInTheDay];
        return 0;
    }
    
    NSDate *cachedLogDate = [FXUtil dateWithTimeStampString:cachedTimeStampString];
    BOOL isSame = [FXUtil isSameDay:[NSDate date] date2:cachedLogDate];
    if (isSame) {
        NSNumber *logCount = [FXUserDefaultManager objectForKey:fxsdk_kLogCountInTheDay];
        return [logCount integerValue];
    }else{
        NSString *_timeStampString = [FXUtil timeStampString];
        [FXUserDefaultManager setObject:_timeStampString forKey:fxsdk_kLogCountDate];
        [FXUserDefaultManager setInteger:0 forKey:fxsdk_kLogCountInTheDay];
        return 0;
    }
    
    return 0;
}

- (void)eventNumberIncrease{
    
    NSInteger logCount = [FXUserDefaultManager integerForKey:fxsdk_kLogCountInTheDay];
    logCount++;
    [FXUserDefaultManager setInteger:logCount forKey:fxsdk_kLogCountInTheDay];
}

- (NSInteger)requestFXIDTryTimesNSInteger{
    return self.requestFXIDTryTimes;
}

- (void)requestFXIDTryTimesIncrease{

    self.requestFXIDTryTimes ++;
}


-(NSString *)fetchPageTitle{
    UIViewController *vc = [FXUtil topViewController];
    if ([vc isKindOfClass:UIViewController.class]) {
        if (vc.title) {
            return vc.title;
        }
    }
    return @"";
}

-(NSString *)fetchPageName{
    
    UIViewController *vc = [FXUtil topViewController];
    if ([vc isKindOfClass:UIViewController.class]) {

        return NSStringFromClass(vc.class);

    }
    return @"";
}




#pragma mark Getter method -

-(NSString *)sdk_version{
    return FXSDKVersion;
}

-(NSInteger)is_first_day{
    BOOL notFirstDay = [FXUserDefaultManager boolForKey:fxsdk_kNotFirstDay];
    if (notFirstDay) {
        return 0;
    }
    
    if ([FXUserDefaultManager objectForKey:fxsdk_kActiveTime]) {
        NSString *timeStampString = [FXUserDefaultManager objectForKey:fxsdk_kActiveTime];
        NSDate *firstDayDate = [FXUtil dateWithTimeStampString:timeStampString];
        BOOL isFirstDay = [FXUtil isSameDay:[NSDate date] date2:firstDayDate];
        
        if (!isFirstDay) {
            [FXUserDefaultManager setBool:YES forKey:fxsdk_kNotFirstDay];
        }
        return isFirstDay?1:0;
    }

    return 1;
}

-(NSString *)session_id{
    if (_session_id) {
        return _session_id;
    }
    
    _session_id = [FXUtil createSession];
    if (_session_id) {
        return _session_id;
    }
    
    NSAssert(_session_id, @"string is invalid");
    return @"0000";
}

-(NSString *)fx_id{
    
    if (_fx_id) {
        return _fx_id;
    }
    
    NSString *local_fxId = [FXUserDefaultManager objectForKey:fxsdk_kFxId];
    if (local_fxId) {
        _fx_id = local_fxId;
        return _fx_id;
    }
    
    return nil;
}

-(NSInteger)duration{
 
    return (self.endTime - self.startTime);
}

#pragma mark - NSNotificationCenter
- (void)_UIApplicationDidEnterBackground{
    
    self.enable_UIApplicationWillEnterForeground = YES;
    
    self.endTime = [[NSDate date]timeIntervalSince1970];
    [FXRequestManager sendEvent:kFXEventNameAppEnd attribute:nil];
}

- (void)_UIApplicationWillEnterForeground{

    if (!self.enable_UIApplicationWillEnterForeground) {
        return;
    }
    [self _innerUIApplicationWillEnterForeground];
}

- (void)_innerUIApplicationWillEnterForeground{

    self.startTime = [[NSDate date] timeIntervalSince1970];

    if (self.endTime > 0) {

        self.session_id = [FXUtil createSession];
        self.requestFXIDTryTimes = 0;
    }
    
    static BOOL shouldRecover = NO;
    if (self.fx_id) {
        
        if (shouldRecover) {
            [FXEventDB recoverEventDBEventStatus];
        }
        [FXRequestManager sendCachedEvents];
    }
    shouldRecover = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [FXRequestManager sendEvent:kFXEventNameAppStart attribute:nil];

    });
}

- (void)_UIApplicationDidFinishLaunching{

    [FXDeviceInfo startMonitoringNetworkType];

    [FXDatabaseManager updateDatabase];
    if (!_session_id) {
        _session_id = [FXUtil createSession];
    }
    
    if ([FXUserDefaultManager boolForKey:fxsdk_kHasSentAppInstall]) {
        ;//has sent event:AppInstall,do nothing
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            [FXRequestManager sendEvent:kFXEventNameAppInstall attribute:nil];

        });
        [FXUserDefaultManager setBool:YES forKey:fxsdk_kHasSentAppInstall];
    }
    
    [self _innerUIApplicationWillEnterForeground];

}

@end
