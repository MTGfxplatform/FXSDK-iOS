//
//  FXDatabaseManager.h
//  FXSDK
//
//  Created by Jomy on 15/10/13.
//

#import <Foundation/Foundation.h>
#import "FXSDKFMDB.h"
#import "FXDatabaseHelper.h"

#define g_pDataManager [FXDatabaseManager sharedInstance]


@interface FXDatabaseManager : NSObject
<FXDatabaseHelper>

+ (nonnull instancetype)sharedInstance;

- (void)runQueryInBlock:(void (^_Nullable)(FXSDKFMDatabase * _Nonnull db))block;


@end

