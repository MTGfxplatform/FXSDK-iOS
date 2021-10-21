//
//  FXDeviceInfo.h
//  FX
//
//  Created by FXMVP on 2021/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXDeviceInfo : NSObject

+ (nonnull instancetype)sharedInstance;

@property (nonatomic,copy,readonly)NSString *device_id;
@property (nonatomic,copy,readonly)NSString *app_name;
@property (nonatomic,copy,readonly)NSString *package_name;
@property (nonatomic,copy,readonly)NSString *platform;
@property (nonatomic,copy,readonly)NSString *os_version;
@property (nonatomic,copy,readonly)NSString *ua;
@property (nonatomic,copy,readonly)NSString *app_version;
@property (nonatomic,copy,readonly)NSString *app_version_code;
@property (nonatomic,copy,readonly)NSString *brand;
@property (nonatomic,copy,readonly)NSString *model;
@property (nonatomic, copy,readonly) NSString *radioAccessTechnology;
@property (nonatomic, strong,readonly) NSNumber *networkType;
@property (nonatomic,copy,readonly)NSString *language;
@property (nonatomic,copy,readonly)NSString *timezone;
@property (nonatomic,copy,readonly)NSString *screen_size;
@property (nonatomic,assign,readonly)long uptime;
@property (nonatomic,assign,readonly)long outime;


- (void)fetchUserAgentViaWKWebView;
+ (void)startMonitoringNetworkType;


@end

NS_ASSUME_NONNULL_END
