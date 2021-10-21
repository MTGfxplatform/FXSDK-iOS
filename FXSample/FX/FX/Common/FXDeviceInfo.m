//
//  FXDeviceInfo.m
//  FX
//
//  Created by FXMVP on 2021/9/26.
//

#import "FXDeviceInfo.h"
#import "FXMacroDefine.h"
#import "FXSDK.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <WebKit/WebKit.h>
#import "FXUserDefaultManager.h"
#import <sys/sysctl.h>
#import "FXSDKNetworkReachabilityManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "FXUtil.h"
#import "FXMacroDefine.h"

NSString *const FXSDKNetworkStrNotReachable = @"NotReachable";
NSString *const FXSDKNetworkStrWiFi = @"WiFi";

NSString *const FXSDKCTRadioAccessTechnologyNRNSA = @"CTRadioAccessTechnologyNRNSA";
NSString *const FXSDKCTRadioAccessTechnologyNR = @"CTRadioAccessTechnologyNR";



@interface FXDeviceInfo ()

@property (nonatomic,strong)  WKWebView *wkWebView;



@property (nonatomic,copy,readwrite)NSString *device_id;
@property (nonatomic,copy,readwrite)NSString *app_name;
@property (nonatomic,copy,readwrite)NSString *package_name;
@property (nonatomic,copy,readwrite)NSString *platform;
@property (nonatomic,copy,readwrite)NSString *os_version;
@property (nonatomic,copy,readwrite)NSString *ua;
@property (nonatomic,copy,readwrite)NSString *app_version;
@property (nonatomic,copy,readwrite)NSString *app_version_code;
@property (nonatomic,copy,readwrite)NSString *brand;
@property (nonatomic,copy,readwrite)NSString *model;
@property (nonatomic,copy,readwrite)NSString *language;
@property (nonatomic,copy,readwrite)NSString *timezone;
@property (nonatomic,copy,readwrite)NSString *screen_size;


@property (nonatomic, copy,readwrite) NSString *radioAccessTechnology;
@property (nonatomic, strong,readwrite) NSNumber *networkType;
@property (nonatomic,assign,readwrite)long uptime;
@property (nonatomic,assign,readwrite)long outime;


@end

@implementation FXDeviceInfo


SINGLETON_IMPLE(FXDeviceInfo)



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    if (self = [super init]) {

        [self _fetchUserAgentViaLocalCache];
    }
    return self;
}




#pragma mark public method -
- (void)fetchUserAgentViaWKWebView{

    //fetch userAgent in main thread
    dispatch_queue_t queue = dispatch_get_main_queue();
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        
        [self _refreshUserAgent];
    } else {
        if([NSThread isMainThread]){
            [self _refreshUserAgent];
        } else {
            
            dispatch_async(dispatch_get_main_queue(),^{
                [self _refreshUserAgent];
            });
        }
    }

}

+ (void)startMonitoringNetworkType{

    [[FXDeviceInfo sharedInstance] updateCurrentNetworkType];
}


#pragma mark Getter method -
-(NSString *)device_id{
    if (_device_id) {
        return _device_id;
    }
    _device_id = [self buildDevice_ID];
    return _device_id;
}

- (NSString *)buildDevice_ID{
    NSString *gaid = @"";
    NSString *idfa = [self _fetchIDFA];
    NSString *imei = @"";
    NSString *android_id = @"";
    NSString *idfv = [self _fetchIDFV];
    NSString *oaid = @"";
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [FXUtil setObject:gaid forKey:@"gaid" forDic:dict];
    [FXUtil setObject:oaid forKey:@"oaid" forDic:dict];
    [FXUtil setObject:imei forKey:@"imei" forDic:dict];
    [FXUtil setObject:android_id forKey:@"android_id" forDic:dict];
    [FXUtil setObject:idfa forKey:@"idfa" forDic:dict];
    [FXUtil setObject:idfv forKey:@"idfv" forDic:dict];
    
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if (error) {
        NSAssert(error, @"dict not an valid JSON");
        return nil;
    }
    
    NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSString *device_id = [FXUtil base64EncodedString:dataString];
    return device_id;
}


-(NSString *)app_name{
 
    if (_app_name) {
        return _app_name;
    }
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    _app_name = appName;
    return _app_name;
}

-(NSString *)package_name{
    if (_package_name) {
        return _package_name;
    }
    _package_name = [[NSBundle mainBundle] bundleIdentifier];
    return _package_name;
}

-(NSString *)platform{
    return @"2";
}

-(NSString *)os_version{
    if (_os_version) {
        return _os_version;
    }
    _os_version = [[UIDevice currentDevice] systemVersion];
    return _os_version;
}

-(NSString *)ua{
    if (_ua) {
        return _ua;
    }
    else {
        return @"unknown";
    }
}

-(NSString *)app_version{
    if (_app_version) {
        return _app_version;
    }
    
    _app_version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    return _app_version;
}

-(NSString *)app_version_code{
    if (_app_version_code) {
        return _app_version_code;
    }
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    _app_version_code = appBuildVersion;
    return _app_version_code;
}

-(NSString *)brand{
    if (_brand) {
        return _brand;
    }
    _brand = [[UIDevice currentDevice] model];
    return _brand;
}

-(NSString *)model{
    if (_model) {
        return _model;
    }
    _model = [self _hardwareString];
    return _model;
}

-(NSString *)language{
    if (_language) {
        return _language;
    }
    NSArray *AppleLanguages = [FXUserDefaultManager objectForKey:@"AppleLanguages"];
    if ([AppleLanguages isKindOfClass:[NSArray class]] && AppleLanguages.count > 0) {
        NSString *language = AppleLanguages[0];
        if (language && [language isKindOfClass:[NSString class]]) {
            _language = language;
            return _language;
        }
    }

    if (!_language) {
        _language = @"unknown";
    }
    return _language;
}

-(NSString *)timezone{
    if (_timezone) {
        return _timezone;
    }
    
    NSDate* datetime = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ZZZZ"];
    NSString *timeZoneString = [dateFormatter stringFromDate:datetime];
    _timezone = timeZoneString;
    return _timezone;
}

-(NSString *)screen_size{
    if (_screen_size) {
        return _screen_size;
    }

    CGFloat deviceWidth = [self _convertPoint2Pixel:kDeviceWidth];
    CGFloat deviceHeight = [self _convertPoint2Pixel:KDeviceHeight];
    
    _screen_size = [NSString stringWithFormat:@"%fx%f",deviceWidth,deviceHeight];
    return _screen_size;
}

-(long)uptime{

    if (_uptime == 0) {
        
        struct timeval boottime;
        int mib[2] = {CTL_KERN, KERN_BOOTTIME};
        size_t size = sizeof(boottime);
        time_t uptime = -1;
        if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
        {
            uptime = boottime.tv_sec;
        }
        NSString *result = [NSString stringWithFormat:@"%ld",uptime];
        _uptime = [result longLongValue];
        
    }
    return _uptime;
}

-(long)outime{

    if (_outime == 0) {

        NSString *information = @"L3Zhci9tb2JpbGUvTGlicmFyeS9Vc2VyQ29uZmlndXJhdGlvblByb2ZpbGVzL1B1YmxpY0luZm8vTUNNZXRhLnBsaXN0";
        NSData *data=[[NSData alloc] initWithBase64EncodedString:information options:0];
        NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSError *error = nil;

        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:dataString error:&error];
//        NSAssert(!error, @"data not an valid JSON");

        if (!error && fileAttributes) {
            id singleAttibute = [fileAttributes objectForKey:NSFileCreationDate];
            if ([singleAttibute isKindOfClass:[NSDate class]]) {
                NSDate *dataDate = singleAttibute;
                NSTimeInterval time = [dataDate timeIntervalSince1970];
                _outime = time * 1000000;
            }
        }
    }
    return _outime;
}

#pragma mark - private method

- (void)_fetchUserAgentViaLocalCache{
    
    NSString *cachedUserAgent = [FXUserDefaultManager objectForKey:fxsdk_kLastUserAgent];
    if (cachedUserAgent.length > 0) {
         _ua = [FXUserDefaultManager objectForKey:fxsdk_kLastUserAgent];
    }else{

        NSString *systemVersion = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"];
        NSString *deviceType = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone";
        _ua = [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU %@ OS %@ like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
                      deviceType, deviceType, systemVersion];
    }
}


-(CGFloat)_convertPoint2Pixel:(CGFloat)value{
    
    CGFloat scale = 1;

    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {

        scale = [[UIScreen mainScreen] scale];
    }
    return value * scale;
}


- (NSString *)_hardwareString {

    int name[] = {CTL_HW,HW_MACHINE};
    size_t size = 100;
    sysctl(name, 2, NULL, &size, NULL, 0); // getting size of answer
    char *hw_machine = malloc(size);
    
    sysctl(name, 2, hw_machine, &size, NULL, 0);
    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
    free(hw_machine);
    return hardware;
}

- (NSString *)_fetchIDFA{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
}

- (NSString *)_fetchIDFV{
    NSString *idfv = [UIDevice currentDevice].identifierForVendor.UUIDString;
    if (!idfv) {
        idfv = @"unknown";
    }
    return idfv;
}



- (void)_refreshUserAgent{
    if (self.wkWebView) {
        return;
    }
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];

    //the duration is about 0.3-0.4s
    [self.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        if (!error) {
            if (result && [result isKindOfClass:[NSString class]]) {
                self.ua = [NSString stringWithFormat:@"%@",result];
                [FXUserDefaultManager setObject:self.ua forKey:fxsdk_kLastUserAgent synchronize:NO];
            }
        }
        self.wkWebView = nil;
    }];
}



- (void)updateCurrentNetworkType
{
    self.networkType =  @(1);
    self.radioAccessTechnology = @"";

    
    [[FXSDKNetworkReachabilityManager sharedManager] startMonitoring];
    [[FXSDKNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(FXSDKNetworkReachabilityStatus status) {
        if (status == FXSDKNetworkReachabilityStatusNotReachable) {
            self.networkType = @(0);
            self.radioAccessTechnology = FXSDKNetworkStrNotReachable;
        }
        else if (status == FXSDKNetworkReachabilityStatusReachableViaWWAN) {
            CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentRadio = telephonyInfo.currentRadioAccessTechnology;
            
            
            self.radioAccessTechnology = currentRadio;

            
            if ([currentRadio isEqualToString:CTRadioAccessTechnologyLTE]) {
                // 4G
                self.networkType = @(4);
            }
            else if([currentRadio isEqualToString:CTRadioAccessTechnologyWCDMA] || [currentRadio isEqualToString:CTRadioAccessTechnologyHSDPA] || [currentRadio isEqualToString:CTRadioAccessTechnologyHSUPA] || [currentRadio isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] || [currentRadio isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] || [currentRadio isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] || [currentRadio isEqualToString:CTRadioAccessTechnologyeHRPD]){
                // 3G
                self.networkType = @(3);
            }
            else if([currentRadio isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadio isEqualToString:CTRadioAccessTechnologyGPRS] || [currentRadio isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
                // 2G
                self.networkType = @(2);
            }else if ([currentRadio isEqualToString:FXSDKCTRadioAccessTechnologyNR] || [currentRadio isEqualToString:FXSDKCTRadioAccessTechnologyNRNSA]){
                // 5G
                self.networkType = @(5);
            }else {
                //unknown，666之前的版本这里为1,v666开始设置为6(下一代网络)
                self.networkType = @(6);
            }
        }
        else if (status == FXSDKNetworkReachabilityStatusReachableViaWiFi) {
            //WIFI
            self.radioAccessTechnology = FXSDKNetworkStrWiFi;
            self.networkType = @(9);
        }
        else {
            //default
            self.radioAccessTechnology = @"";
            self.networkType = @(1);
        }
    }];
}


@end
