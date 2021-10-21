//
//  FXUserDefaultManager.m
//  FX
//
//  Created by FXMVP on 2021/9/26.
//

#import "FXUserDefaultManager.h"

@implementation FXUserDefaultManager



+ (void)removeObjectForKey:(NSString *_Nonnull)defaultName{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
}

+ (nullable id)objectForKey:(NSString *_Nonnull)defaultName{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}


/*!
 -setObject:forKey: immediately stores a value (or removes the value if nil is passed as the value) for the provided key in the search list entry for the receiver's suite name in the current user and any host, then asynchronously stores the value persistently, where it is made available to other processes.
 */
+ (void)setObject:(nullable id)value forKey:(NSString *_Nonnull)defaultName{

    NSAssert((value != nil), @"please use 'removeObjectForKey:(NSString *_Nonnull)defaultName'");

    [FXUserDefaultManager setObject:value forKey:defaultName synchronize:YES];
}

+ (void)setObject:(nullable id)value forKey:(NSString *_Nonnull)defaultName synchronize:(BOOL)synchronize{
    
    NSAssert((value != nil), @"please use 'removeObjectForKey:(NSString *_Nonnull)defaultName'");

    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



+ (void)setInteger:(NSInteger)value forKey:(NSString *_Nonnull)defaultName{

    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:defaultName];
}
+ (NSInteger)integerForKey:(NSString *_Nonnull)defaultName{
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}


+ (void)setFloat:(float)value forKey:(NSString *_Nonnull)defaultName{
    
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:defaultName];
}
+ (float)floatForKey:(NSString *_Nonnull)defaultName{
    
    return [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}


+ (void)setDouble:(double)value forKey:(NSString *_Nonnull)defaultName{

    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:defaultName];
}
+ (double)doubleForKey:(NSString *_Nonnull)defaultName{
    
    return [[NSUserDefaults standardUserDefaults] doubleForKey:defaultName];
}


+ (void)setBool:(BOOL)value forKey:(NSString *_Nonnull)defaultName{

    [[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
}
+ (BOOL)boolForKey:(NSString *_Nonnull)defaultName{
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}



@end
