//
//  FXBaseConstants.h
//  FX
//
//  Created by FXMVP on 2021/9/28.
//

#import <Foundation/Foundation.h>


//Event name
extern NSString * const kFXEventNameIAP;

//Inner event name
extern NSString * const kFXEventNameAppInstall;
extern NSString * const kFXEventNameAppStart;
extern NSString * const kFXEventNameAppEnd;

//Inner event parameter
extern NSString * const kFXEventParameterDuration;


//FXEventParameterConstants
extern NSString * const kFXEventParameterKeyEventName;
extern NSString * const kFXEventParameterKeyEventData;


NS_ASSUME_NONNULL_BEGIN

@interface FXBaseConstants : NSObject

@end

NS_ASSUME_NONNULL_END
