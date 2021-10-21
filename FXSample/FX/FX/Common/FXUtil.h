//
//  FXUtil.h
//  FX
//
//  Created by FXMVP on 2021/9/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXUtil : NSObject


+ (void)setObject:(id __nullable)object forKey:(NSString *)key forDic:(NSMutableDictionary *)dic;
+ (NSString *) md5:(NSString *)input;

+ (NSString *)timeStampString;
+ (NSDate *)dateWithTimeStampString:(NSString *)timeStampString;

+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

+ (NSString *)getUUIDString;

+ (NSString *)createSession;



+ (NSString *)base64EncodedString:(NSString *)string;
+ (NSString *)base64DecodedString:(NSString *)string;

+ (UIViewController *)topViewController;

+ (void)performBlockOnMainThread_fx:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
