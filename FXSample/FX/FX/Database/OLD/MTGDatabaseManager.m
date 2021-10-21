//
//  MTGDatabaseManager.m
//  MTGSDK
//
//  Created by Jomy on 15/10/13.
//

#import "MTGDatabaseManager.h"
#import "MTGFrequenceDB.h"
#import "MTGCampaignDB.h"
#import "MTGCampaignClickDB.h"
#import "MTGFrameDB.h"
#import "MTGVideoDB.h"
#import "MTGDownloadDB.h"
#import "MTGUserDefaultManager.h"
#import "MTGInteractiveAdsDisplayDB.h"
#import "MTGFileCacheManager.h"
#import "MTGUnitDB.h"
#import "MTGTempKeyCacheDB.h"

#define kDatabasePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"mvsdk.db"]

/*
 v540  improve version to 25 (header bidding column for campaign table)
 v550  improve version to 26 (add mraid fileName column for campaign table)
 v580  improve version to 27 (omsdk add omid)
 v585  improve version to 28 (zip file dir changed)
 v590  improve version to 29 (super template url)
 v600  improve version to 30 (splash ad)
 v630  improve version to 31 (add placementId)
 v640  improve version to 32 (add numberRating)
 v650  improve version to 33 (add skad_info)
 v660  improve version to 34
 v650  improve version to 35, delete offer_type/t_imp/adv_id/watch_mile  in campaign table
 v690  improve version to 36, add skimp/pcm
 V693  improve version to 37, add rw_pl
 v700  improve version to 38, splash floatball
 v701  improve version to 39, vcn,rid
 */
#define MTGDatabaseVersionNew 39
#define kLastDateKey @"mvsdk_lastSettingDate"


@interface MTGDatabaseManager ()

@property (nonatomic, strong) MTGFMDatabaseQueue *queue;

@end


@implementation MTGDatabaseManager
SINGLETON_IMPLE(MTGDatabaseManager)

#pragma mark - Basic

- (id)init
{
    if (self = [super init]) {
        _queue = [MTGFMDatabaseQueue databaseQueueWithPath:kDatabasePath];
        DLog(@"_queue.path ---------%@",_queue.path);
        
    }
    return self;
}

- (void)dealloc
{
    [_queue close];
}

- (void)runQueryInBlock:(void (^)(MTGFMDatabase *db))block
{
    if (_queue) {
        [_queue inDatabase:^(MTGFMDatabase *db) {
            if (block) {
                block(db);
            }
        }];
    }
}




















#pragma mark - Helper
+ (void)createDatabase{
    [MTGUserDefaultManager setObject:[[NSNumber alloc] initWithInt:MTGDatabaseVersionNew] forKey:mv_kVersionCode synchronize:NO];
    [MTGCampaignDB createDatabase];
    [MTGFrequenceDB createDatabase];
    [MTGCampaignClickDB createDatabase];
    [MTGFrameDB createDatabase];
    [MTGVideoDB createDatabase];
    [MTGDownloadDB createDatabase];
    [MTGInteractiveAdsDisplayDB createDatabase];
    [MTGFileCacheDB createDatabase];
    [MTGUnitDB createDatabase];
    [MTGTempKeyCacheDB createDatabase];
}

+ (void)dropDatabase
{
    [MTGCampaignDB dropDatabase];
    [MTGFrequenceDB dropDatabase];
    [MTGCampaignClickDB dropDatabase];
    [MTGFrameDB dropDatabase];
    [MTGVideoDB dropDatabase];
    [MTGDownloadDB dropDatabase];
    [MTGInteractiveAdsDisplayDB dropDatabase];
    [MTGFileCacheDB dropDatabase];
    [MTGUnitDB dropDatabase];
    [MTGTempKeyCacheDB dropDatabase];

    //appsetting 失效使用是重现触发
    [MTGUserDefaultManager removeObjectForKey:kLastDateKey];
}

+ (void)updateDatabase
{
    //可以根据版本号来区分升级的操作
    NSInteger version = [[MTGUserDefaultManager objectForKey:mv_kVersionCode] integerValue];
    if(version != MTGDatabaseVersionNew){
        [MTGDatabaseManager dropDatabase];
    }
    [MTGDatabaseManager createDatabase];
}















@end
