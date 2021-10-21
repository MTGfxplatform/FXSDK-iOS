//
//  FXBaseParameterBuilder.m
//  FX
//
//  Created by FXMVP on 2021/9/28.
//

#import "FXRequestParameterBuilder.h"
#import "FXDeviceInfo.h"
#import "FXGlobal.h"
#import "FXUserDefaultManager.h"
#import "FXUtil.h"







//base
NSString * const kFXEventParameterKeyDevice_id                   = @"device_id";
NSString * const kFXEventParameterKeyFX_id                       = @"fx_id";
NSString * const kFXEventParameterKeySDK_version                 = @"sdk_version";
NSString * const kFXEventParameterKeyAppId                       = @"app_id";
NSString * const kFXEventParameterKeyIs_first_day                = @"is_first_day";
NSString * const kFXEventParameterKeyApp_name                    = @"app_name";
NSString * const kFXEventParameterKeyPackage_name                = @"package_name";
NSString * const kFXEventParameterKeyPlatform                    = @"platform";
NSString * const kFXEventParameterKeyOs_version                  = @"os_version";
NSString * const kFXEventParameterKeyUserAgent                   = @"ua";
NSString * const kFXEventParameterKeyApp_version                 = @"app_version";
NSString * const kFXEventParameterKeyApp_version_code            = @"app_version_code";
NSString * const kFXEventParameterKeyBrand                       = @"brand";
NSString * const kFXEventParameterKeyModel                       = @"model";
NSString * const kFXEventParameterKeyNetworkType                 = @"network_type";
NSString * const kFXEventParameterKeyNetworkStr                  = @"network_str";
NSString * const kFXEventParameterKeyLanguage                    = @"language";
NSString * const kFXEventParameterKeyTimezone                    = @"timezone";
NSString * const kFXEventParameterKeyScreen_size                 = @"screen_size";
NSString * const kFXEventParameterKeyOUT                         = @"out";
NSString * const kFXEventParameterKeyUPT                         = @"upt";




//event
NSString * const kFXEventParameterKeySession_id                  = @"session_id";
NSString * const kFXEventParameterKeyEvent_id                    = @"event_id";
NSString * const kFXEventParameterKeyTime                        = @"time";
NSString * const kFXEventParameterKeyLog_count                   = @"log_count";

NSString * const kFXEventParameterKeyPage_title                  = @"page_title";
NSString * const kFXEventParameterKeyPage_name                   = @"page_name";



NSString * const kFXEventParameterEvent_list                     = @"event_list";







@implementation FXRequestParameterBuilder

+ (NSDictionary *) fetchEventCommonParameterWithEventID:(NSString *)event_id{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];

    FXGlobal *global = [FXGlobal sharedInstance];

    long time = [[NSDate date] timeIntervalSince1970];

    [FXUtil setObject:@(time * 1000) forKey:kFXEventParameterKeyTime forDic:dict];
    [FXUtil setObject:global.session_id forKey:kFXEventParameterKeySession_id forDic:dict];
    [FXUtil setObject:event_id forKey:kFXEventParameterKeyEvent_id forDic:dict];

    NSNumber *eventLogNumber = [NSNumber numberWithInteger:global.eventLogNumberNSInteger];
    [FXUtil setObject:eventLogNumber forKey:kFXEventParameterKeyLog_count forDic:dict];
    
    NSString *pageTitle = [global fetchPageTitle];
    NSString *pageName = [global fetchPageName];
    [FXUtil setObject:pageTitle forKey:kFXEventParameterKeyPage_title forDic:dict];
    [FXUtil setObject:pageName forKey:kFXEventParameterKeyPage_name forDic:dict];
    
    return dict;
}

+ (NSDictionary *) fetchBaseParameter{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary new];

    FXGlobal *global = [FXGlobal sharedInstance];
    
    [FXUtil setObject:global.app_id forKey:kFXEventParameterKeyAppId forDic:dict];
    [FXUtil setObject:global.fx_id forKey:kFXEventParameterKeyFX_id forDic:dict];
    [FXUtil setObject:@(global.is_first_day) forKey:kFXEventParameterKeyIs_first_day forDic:dict];
    [FXUtil setObject:global.sdk_version  forKey:kFXEventParameterKeySDK_version forDic:dict];
    
    
    FXDeviceInfo *d = [FXDeviceInfo sharedInstance];
    
    [FXUtil setObject:d.device_id  forKey:kFXEventParameterKeyDevice_id forDic:dict];
    [FXUtil setObject:d.app_name  forKey:kFXEventParameterKeyApp_name forDic:dict];
    [FXUtil setObject:d.package_name  forKey:kFXEventParameterKeyPackage_name forDic:dict];
    [FXUtil setObject:@([d.platform integerValue])  forKey:kFXEventParameterKeyPlatform forDic:dict];
    [FXUtil setObject:d.os_version  forKey:kFXEventParameterKeyOs_version forDic:dict];
    [FXUtil setObject:d.ua  forKey:kFXEventParameterKeyUserAgent forDic:dict];
    [FXUtil setObject:d.app_version  forKey:kFXEventParameterKeyApp_version forDic:dict];
    [FXUtil setObject:@([d.app_version_code integerValue])   forKey:kFXEventParameterKeyApp_version_code forDic:dict];
    [FXUtil setObject:d.brand  forKey:kFXEventParameterKeyBrand forDic:dict];
    [FXUtil setObject:d.model  forKey:kFXEventParameterKeyModel forDic:dict];
    NSString *networkType = [NSString stringWithFormat:@"%@",d.networkType];
    [FXUtil setObject:networkType  forKey:kFXEventParameterKeyNetworkType forDic:dict];
    [FXUtil setObject:d.radioAccessTechnology forKey:kFXEventParameterKeyNetworkStr forDic:dict];
    [FXUtil setObject:d.language  forKey:kFXEventParameterKeyLanguage forDic:dict];
    [FXUtil setObject:d.timezone  forKey:kFXEventParameterKeyTimezone forDic:dict];
    [FXUtil setObject:d.screen_size  forKey:kFXEventParameterKeyScreen_size forDic:dict];
    [FXUtil setObject:@(d.uptime)  forKey:kFXEventParameterKeyUPT forDic:dict];
    [FXUtil setObject:@(d.outime)  forKey:kFXEventParameterKeyOUT forDic:dict];

    
    
    return dict;
}

+ (NSDictionary *) buildEventParameterWithEventDatas:(NSArray *)eventDatas{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [FXUtil setObject:eventDatas forKey:kFXEventParameterEvent_list forDic:dict];

    return dict;
}


#pragma mark - private method




@end
