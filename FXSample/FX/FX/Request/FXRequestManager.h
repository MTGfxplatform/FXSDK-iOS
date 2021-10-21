//
//  FXRequestManager.h
//  FX
//
//  Created by FXMVP on 2021/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXRequestManager : NSObject


+ (void)requestFXID;

+ (void)sendEvent:(NSString *)eventName attribute:(NSDictionary *_Nullable)attribute;

+ (void)sendCachedEvents;

@end

NS_ASSUME_NONNULL_END
