//
//  FXUtil.m
//  FX
//
//  Created by FXMVP on 2021/9/28.
//

#import "FXUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation FXUtil

+(NSString *)timeStampString{
    NSString *time = [NSString stringWithFormat:@"%0.f",[[NSDate date] timeIntervalSince1970]];
    return time;
}

+ (NSDate *)dateWithTimeStampString:(NSString *)timeStampString{
    NSTimeInterval time = [timeStampString doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    return detailDate;
}

+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (void)setObject:(id __nullable)object forKey:(NSString *)key forDic:(NSMutableDictionary *)dic
{
    if (dic) {
        if (object && key) {
            [dic setObject:object forKey:key];
        }
    }
}


+ (NSString *) md5:(NSString *)input
{
    if(!input)
        return @"";
    const char *cStr = [input UTF8String];
    unsigned char digest[32];
    CC_LONG length = (CC_LONG)strlen(cStr);
    CC_MD5( cStr, length, digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}


+ (NSString *)createSession{
    
    return  [FXUtil getUUIDString];
}


+ (NSString *)getUUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}


+ (NSString *)base64EncodedString:(NSString *)string
{
    NSAssert([string isKindOfClass:NSString.class], @"string is invalid");

    NSData *data = [string dataUsingEncoding: NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

+ (NSString *)base64DecodedString:(NSString *)string
{
    NSAssert([string isKindOfClass:NSString.class], @"string is invalid");

    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    return [[NSString alloc]initWithData:data encoding: NSUTF8StringEncoding];
}




+ (UIViewController *)topViewController {

    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


+ (void)performBlockOnMainThread_fx:(void (^)(void))block
{
    if(!block)
        return;
    /*
     Use NSThread api to check if we are running on the main thread works in most cases(include UIKit case),
     The underlying problem is that the VektorKit/MapKit API is checking if it is being called on the main queue instead of checking that it is running on the main thread.
     So it is safer to check for the current queue instead of checking for the current thread.
     See: http://www.openradar.me/24025596
     Also see: http://blog.benjamin-encz.de/post/main-queue-vs-main-thread/
     */
     
    dispatch_queue_t queue = dispatch_get_main_queue();
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
    } else {
        
        if([NSThread isMainThread]){
            block();
        } else {
            
            dispatch_async(dispatch_get_main_queue(),^{
                dispatch_async(queue, block);
            });
        }
    }
    
}


@end
