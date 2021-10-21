//
//  FXCampaignDB.h
//  FXSDK
//
//  Created by Tony on 15/10/28.
//

#import <Foundation/Foundation.h>
#import "FXDatabaseHelper.h"


@interface  FXEventObject: NSObject

@property (nonatomic,copy)NSString *eventName;
@property (nonatomic,copy)NSString *eventData;
@property (nonatomic,copy)NSString *uniqueID;
@property (nonatomic,assign) NSUInteger status;

@end


@interface FXEventDB : NSObject <FXDatabaseHelper>

#pragma mark - Store Ops

+ (void)insertEventName:(NSString *)eventName data:(NSString *)data uniqueID:(NSString *)uniqueID;

+ (NSArray<FXEventObject *> *)queryCachedEvent:(NSInteger)limit;

+ (void)markEventReportingWithUniqueIDs:(NSArray *)uniqueIDs;

+ (void)markEventFailedWithUniqueIDs:(NSArray *)uniqueIDs;

+ (void)recoverEventDBEventStatus;

+ (void)recoverFailedEventDBEventStatus;

+ (void)deleteEventWithUniqueIDs:(NSArray *)uniqueIDs;


@end
