//
//  FXGlobal.h
//  FX
//
//  Created by FXMVP on 2021/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXGlobal : NSObject
+ (nonnull instancetype)sharedInstance;


@property (nonatomic,assign,readonly)BOOL debugModel;
/*
 @property (nonatomic,copy,readonly)NSString *channel;
 */
@property (nonatomic,assign,readonly)NSInteger is_first_day;

@property (nonatomic,copy,readonly)NSString *sdk_version;
@property (nonatomic,copy,readonly)NSString *session_id;
@property (nonatomic,copy,readonly)NSString *fx_id;
@property (nonatomic,copy,readonly)NSString *app_id;
@property (nonatomic,assign,readonly)NSInteger duration;


- (void)setAppID:(NSString *)app_id;
- (void)setDebugModel:(BOOL)isDebug;
/*
 - (void)setChannel:(NSString *)channelName;
 */
- (void)setMarkOnFirstActiveDay;
- (void)refreshFXID:(NSString *)fx_Id;


- (NSInteger)eventLogNumberNSInteger;
- (void)eventNumberIncrease;

- (NSInteger)requestFXIDTryTimesNSInteger;
- (void)requestFXIDTryTimesIncrease;



-(NSString *)fetchPageTitle;
-(NSString *)fetchPageName;





@end

NS_ASSUME_NONNULL_END
