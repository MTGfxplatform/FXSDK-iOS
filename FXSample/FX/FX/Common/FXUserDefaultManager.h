//
//  FXUserDefaultManager.h
//  FX
//
//  Created by FXMVP on 2021/9/26.
//

#import <Foundation/Foundation.h>
#import "FXUserDefaultKeyConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface FXUserDefaultManager : NSObject


+ (void)removeObjectForKey:(NSString *_Nonnull)defaultName;


+ (void)setObject:(nullable id)value forKey:(NSString *_Nonnull)defaultName;
+ (void)setObject:(nullable id)value forKey:(NSString *_Nonnull)defaultName synchronize:(BOOL)synchronize;
+ (nullable id)objectForKey:(NSString *_Nonnull)defaultName;


+ (void)setInteger:(NSInteger)value forKey:(NSString *_Nonnull)defaultName;
+ (NSInteger)integerForKey:(NSString *_Nonnull)defaultName;


+ (void)setFloat:(float)value forKey:(NSString *_Nonnull)defaultName;
+ (float)floatForKey:(NSString *_Nonnull)defaultName;


+ (void)setDouble:(double)value forKey:(NSString *_Nonnull)defaultName;
+ (double)doubleForKey:(NSString *_Nonnull)defaultName;


+ (void)setBool:(BOOL)value forKey:(NSString *_Nonnull)defaultName;
+ (BOOL)boolForKey:(NSString *_Nonnull)defaultName;



@end

NS_ASSUME_NONNULL_END
