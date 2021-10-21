
//  FXCampaignDB.m
//  FXSDK
//
//  Created by Tony on 15/10/28.
//

#import "FXEventDB.h"
#import "FXDatabaseManager.h"
#import "FXWhereModel.h"
#import "FXSQLAdaptor.h"
#import "FXSDKFMDatabase.h"


NSString * const kFXEventDB_TABLE_NAME                     = @"FXEventDB";
NSString * const kFXEventDB_UniqueId                       = @"uniqueId";
NSString * const kFXEventDB_EventName                      = @"eventName";
NSString * const kFXEventDB_EventDataString                = @"eventData";
NSString * const kFXEventDB_EventStatus                    = @"status";


typedef enum : NSUInteger {
    FXEventDBEventStatusDefault = 1,
    FXEventDBEventStatusReporting = 2,
    FXEventDBEventStatusFailed = 3,

} FXEventDBEventStatus;



@implementation FXEventObject
@end


@implementation FXEventDB

#pragma mark - FXDatabaseHelper
+ (void)createDatabase{
    [g_pDataManager runQueryInBlock:^(FXSDKFMDatabase *db) {
        
        NSDictionary * infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(DataTypeText),kFXEventDB_UniqueId,
                                   @(DataTypeText),kFXEventDB_EventName,
                                   @(DataTypeText),kFXEventDB_EventDataString,
                                   @(DataTypeInteger),kFXEventDB_EventStatus,
                                   nil];

        NSString *TABLE_NAME = kFXEventDB_TABLE_NAME;
        NSString *sql = [FXSQLAdaptor createTable:TABLE_NAME ColumnKeys:infoDict primaryKey:nil];

        [db executeUpdate:sql];
    }];
}

+ (void)dropDatabase{
    [g_pDataManager runQueryInBlock:^(FXSDKFMDatabase *db) {
        NSString *sql = [FXSQLAdaptor dropTable:kFXEventDB_TABLE_NAME];
        [db executeUpdate:sql];
    }];
}

+ (void)updateDatabase {
    
}


#pragma mark - Event Ops
+ (void)insertEventName:(NSString *)eventName data:(NSString *)data uniqueID:(NSString *)uniqueID{
    
    [g_pDataManager runQueryInBlock:^(FXSDKFMDatabase *db) {
        NSString *sql =
         [FXSQLAdaptor queryLinesWithColumns:nil inTable:kFXEventDB_TABLE_NAME
                                                    where:FXSDKwhere(kFXEventDB_UniqueId, OPR_EQUAL, uniqueID, DataTypeText)];
        FXSDKFMResultSet *resultSet = [db executeQuery:sql];

        if (![resultSet next]) {
            NSDictionary * infoDict = [NSDictionary dictionaryWithObjectsAndKeys:uniqueID,kFXEventDB_UniqueId,
                                       eventName,kFXEventDB_EventName,
                                       data,kFXEventDB_EventDataString,
                                       @(FXEventDBEventStatusDefault),kFXEventDB_EventStatus,
                                       nil];
            sql = [FXSQLAdaptor insertRow:infoDict TableName:kFXEventDB_TABLE_NAME];
            [db executeUpdate:sql];
        } else {
            NSDictionary * infoDict = [NSDictionary dictionaryWithObjectsAndKeys:uniqueID,kFXEventDB_UniqueId,
                                       eventName,kFXEventDB_EventName,
                                       data,kFXEventDB_EventDataString,
                                       nil];

            FXWhereModel *fxWhereModel = FXSDKwhere(kFXEventDB_UniqueId, OPR_EQUAL, uniqueID, DataTypeText).and(FXSDKwhere(kFXEventDB_EventName, OPR_EQUAL, eventName, DataTypeText));
            
            NSString *sql = [FXSQLAdaptor updateWithRow:infoDict inTable:kFXEventDB_TABLE_NAME where:fxWhereModel];
            [db executeUpdate:sql];
        }
        [resultSet close];
    }];
}

+ (void)recoverEventDBEventStatus{


    [g_pDataManager runQueryInBlock:^(FXSDKFMDatabase *db) {
        NSString *sql = @"UPDATE FXEventDB set status=1 WHERE status=2 or status=3";
        [db executeUpdate:sql];
    }];
}

+ (void)recoverFailedEventDBEventStatus{


    [g_pDataManager runQueryInBlock:^(FXSDKFMDatabase *db) {
        NSString *sql = @"UPDATE FXEventDB set status=1 WHERE status=3";
        [db executeUpdate:sql];
    }];
}

+ (NSArray<FXEventObject *> *)queryCachedEvent:(NSInteger)limit{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (limit == 0) {
        limit = 10;
    }

    [g_pDataManager runQueryInBlock:^(FXSDKFMDatabase *db) {

        FXWhereModel *whereModel = FXSDKwhere(kFXEventDB_EventStatus, OPR_EQUAL, @(FXEventDBEventStatusDefault), DataTypeInteger);
        whereModel.limit(limit);
        NSString *sql = [FXSQLAdaptor queryLinesWithColumns:nil inTable:kFXEventDB_TABLE_NAME where:whereModel];

        FXSDKFMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {

            FXEventObject *object = [[FXEventObject alloc] init];
            object.uniqueID = [resultSet stringForColumn:kFXEventDB_UniqueId];
            object.eventName = [resultSet stringForColumn:kFXEventDB_EventName];
            object.eventData = [resultSet stringForColumn:kFXEventDB_EventDataString];
            object.status = [resultSet intForColumn:kFXEventDB_EventStatus];
            [array addObject:object];
        }
        [resultSet close];
    }];
    return [array copy];
}


+ (void)markEventReportingWithUniqueIDs:(NSArray *)uniqueIDs{
    
    if (uniqueIDs.count == 0) {
        return;
    }


    NSMutableArray *mutArray = [[NSMutableArray alloc]init];
    for (NSString *uniqueID in uniqueIDs) {
        NSString *uId = [NSString stringWithFormat:@"'%@'",uniqueID];
        if (uId) {
            if (![mutArray containsObject:uId]) {
                [mutArray addObject:uId];
            }
        }
    }
    
    
    NSString *uniqueIDsString = [mutArray componentsJoinedByString:@","];
    [g_pDataManager runQueryInBlock:^(FXSDKFMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@=%lu WHERE %@ IN (%@)",kFXEventDB_TABLE_NAME,kFXEventDB_EventStatus,(unsigned long)FXEventDBEventStatusReporting,kFXEventDB_UniqueId,uniqueIDsString];
        [db executeUpdate:sql];
    }];
    
}

+ (void)markEventFailedWithUniqueIDs:(NSArray *)uniqueIDs{
    
    if (uniqueIDs.count == 0) {
        return;
    }


    NSMutableArray *mutArray = [[NSMutableArray alloc]init];
    for (NSString *uniqueID in uniqueIDs) {
        NSString *uId = [NSString stringWithFormat:@"'%@'",uniqueID];
        if (uId) {
            if (![mutArray containsObject:uId]) {
                [mutArray addObject:uId];
            }
        }
    }
    
    
    NSString *uniqueIDsString = [mutArray componentsJoinedByString:@","];
    [g_pDataManager runQueryInBlock:^(FXSDKFMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@=%lu WHERE %@ IN (%@)",kFXEventDB_TABLE_NAME,kFXEventDB_EventStatus,(unsigned long)FXEventDBEventStatusFailed,kFXEventDB_UniqueId,uniqueIDsString];
        [db executeUpdate:sql];
    }];
    
}

+ (void)deleteEventWithUniqueIDs:(NSArray *)uniqueIDs{
    
    if (uniqueIDs.count == 0) {
        return;
    }
    NSMutableArray *mutArray = [[NSMutableArray alloc]init];
    for (NSString *uniqueID in uniqueIDs) {
        NSString *uId = [NSString stringWithFormat:@"'%@'",uniqueID];
        if (uId) {
            if (![mutArray containsObject:uId]) {
                [mutArray addObject:uId];
            }
        }
    }

    NSString *uniqueIDsString = [mutArray componentsJoinedByString:@","];
    [g_pDataManager runQueryInBlock:^(FXSDKFMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ IN (%@)",kFXEventDB_TABLE_NAME,kFXEventDB_UniqueId,uniqueIDsString];
        [db executeUpdate:sql];
    }];
    
}


@end
