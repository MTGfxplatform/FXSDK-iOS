//
//  FXBaseParameterBuilder.h
//  FX
//
//  Created by FXMVP on 2021/9/28.
//

#import <Foundation/Foundation.h>




NS_ASSUME_NONNULL_BEGIN


extern NSString *const kFXEventParameterKeyLog_count;
extern NSString *const kFXEventParameterKeyFX_id;
extern NSString *const kFXEventParameterKeyAppId;

@interface FXRequestParameterBuilder : NSObject

+ (NSDictionary *) fetchBaseParameter;

+ (NSDictionary *) fetchEventCommonParameterWithEventID:(NSString *)event_id;

+ (NSDictionary *) buildEventParameterWithEventDatas:(NSArray *)eventDatas;


@end

NS_ASSUME_NONNULL_END
