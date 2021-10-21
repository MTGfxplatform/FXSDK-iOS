//
//  FXDatabaseManager.m
//
//  Created by Jomy on 15/10/13.
//

#import "FXDatabaseManager.h"

#import "FXMacroDefine.h"
#import "FXUserDefaultManager.h"
#import "FXUserDefaultKeyConstants.h"
#import "FXEventDB.h"

#define kDatabasePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"FXEventData.db"]

/*
 v100  initialize  FXEvetnDB table

 */
#define FXDatabaseVersionNew 1


@interface FXDatabaseManager ()

@property (nonatomic, strong) FXSDKFMDatabaseQueue *queue;

@end


@implementation FXDatabaseManager
SINGLETON_IMPLE(FXDatabaseManager)

#pragma mark - Basic

- (id)init
{
    if (self = [super init]) {
        _queue = [FXSDKFMDatabaseQueue databaseQueueWithPath:kDatabasePath];
        DLog(@"FXEventData database file path is: ---------%@",_queue.path);
        
    }
    return self;
}

- (void)dealloc
{
    [_queue close];
}

- (void)runQueryInBlock:(void (^)(FXSDKFMDatabase *db))block
{
    if (_queue) {
        [_queue inDatabase:^(FXSDKFMDatabase *db) {
            if (block) {
                block(db);
            }
        }];
    }
}




#pragma mark - Helper
+ (void)createDatabase{
    [FXUserDefaultManager setObject:[[NSNumber alloc] initWithInt:FXDatabaseVersionNew] forKey:fxsdk_kdatabaseVersion synchronize:NO];
    [FXEventDB createDatabase];
}

+ (void)dropDatabase
{
    [FXEventDB dropDatabase];
}

+ (void)updateDatabase
{
    //可以根据版本号来区分升级的操作
    NSInteger version = [[FXUserDefaultManager objectForKey:fxsdk_kdatabaseVersion] integerValue];
    if(version != FXDatabaseVersionNew){
        [FXDatabaseManager dropDatabase];
    }
    [FXDatabaseManager createDatabase];
}















@end
