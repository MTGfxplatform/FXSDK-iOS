//
//  MTGDatabaseManager.h
//  MTGSDK
//
//  Created by Jomy on 15/10/13.
//

#import <Foundation/Foundation.h>
#import "MTGFMDB.h"
#import "MTGDatebaseHelper.h"

#define g_pDataManager [MTGDatabaseManager sharedInstance]

@interface MTGDatabaseManager : NSObject
<MTGDatebaseHelper>
SINGLETON_INTERFACE(MTGDatabaseManager)

- (void)runQueryInBlock:(void (^)(MTGFMDatabase *db))block;


@end

