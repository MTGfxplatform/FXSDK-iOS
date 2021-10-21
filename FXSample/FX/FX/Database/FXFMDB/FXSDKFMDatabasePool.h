//
//  FXSDKFMDatabasePool.h
//  FXSDKFMDB
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class FXSDKFMDatabase;

/** Pool of `<FXSDKFMDatabase>` objects.

 ### See also
 
 - `<FXSDKFMDatabaseQueue>`
 - `<FXSDKFMDatabase>`

 @warning Before using `FXSDKFMDatabasePool`, please consider using `<FXSDKFMDatabaseQueue>` instead.

 If you really really really know what you're doing and `FXSDKFMDatabasePool` is what
 you really really need (ie, you're using a read only database), OK you can use
 it.  But just be careful not to deadlock!

 For an example on deadlocking, search for:
 `ONLY_USE_THE_POOL_IF_YOU_ARE_DOING_READS_OTHERWISE_YOULL_DEADLOCK_USE_FXSDKFMDatabaseQueue_INSTEAD`
 in the main.m file.
 */

@interface FXSDKFMDatabasePool : NSObject {
    NSString            *_path;
    
    dispatch_queue_t    _lockQueue;
    
    NSMutableArray      *_databaseInPool;
    NSMutableArray      *_databaseOutPool;
    
    __unsafe_unretained id _delegate;
    
    NSUInteger          _maximumNumberOfDatabasesToCreate;
    int                 _openFlags;
}

/** Database path */

@property (atomic, retain) NSString *path;

/** Delegate object */

@property (atomic, assign) id delegate;

/** Maximum number of databases to create */

@property (atomic, assign) NSUInteger maximumNumberOfDatabasesToCreate;

/** Open flags */

@property (atomic, readonly) int openFlags;


///---------------------
/// @name Initialization
///---------------------

/** Create pool using path.

 @param aPath The file path of the database.

 @return The `FXSDKFMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithPath:(NSString*)aPath;

/** Create pool using path and specified flags

 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database

 @return The `FXSDKFMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithPath:(NSString*)aPath flags:(int)openFlags;

/** Create pool using path.

 @param aPath The file path of the database.

 @return The `FXSDKFMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString*)aPath;

/** Create pool using path and specified flags.

 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database

 @return The `FXSDKFMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags;

///------------------------------------------------
/// @name Keeping track of checked in/out databases
///------------------------------------------------

/** Number of checked-in databases in pool
 
 @returns Number of databases
 */

- (NSUInteger)countOfCheckedInDatabases;

/** Number of checked-out databases in pool

 @returns Number of databases
 */

- (NSUInteger)countOfCheckedOutDatabases;

/** Total number of databases in pool

 @returns Number of databases
 */

- (NSUInteger)countOfOpenDatabases;

/** Release all databases in pool */

- (void)releaseAllDatabases;

///------------------------------------------
/// @name Perform database operations in pool
///------------------------------------------

/** Synchronously perform database operations in pool.

 @param block The code to be run on the `FXSDKFMDatabasePool` pool.
 */

- (void)inDatabase:(void (^)(FXSDKFMDatabase *db))block;

/** Synchronously perform database operations in pool using transaction.

 @param block The code to be run on the `FXSDKFMDatabasePool` pool.
 */

- (void)inTransaction:(void (^)(FXSDKFMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations in pool using deferred transaction.

 @param block The code to be run on the `FXSDKFMDatabasePool` pool.
 */

- (void)inDeferredTransaction:(void (^)(FXSDKFMDatabase *db, BOOL *rollback))block;

#if SQLITE_VERSION_NUMBER >= 3007000

/** Synchronously perform database operations in pool using save point.

 @param block The code to be run on the `FXSDKFMDatabasePool` pool.
 
 @return `NSError` object if error; `nil` if successful.

 @warning You can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock. If you need to nest, use `<[FXSDKFMDatabase startSavePointWithName:error:]>` instead.
*/

- (NSError*)inSavePoint:(void (^)(FXSDKFMDatabase *db, BOOL *rollback))block;
#endif

@end


/** FXSDKFMDatabasePool delegate category
 
 This is a category that defines the protocol for the FXSDKFMDatabasePool delegate
 */

@interface NSObject (FXSDKFMDatabasePoolDelegate)

/** Asks the delegate whether database should be added to the pool. 
 
 @param pool     The `FXSDKFMDatabasePool` object.
 @param database The `FXSDKFMDatabase` object.
 
 @return `YES` if it should add database to pool; `NO` if not.
 
 */

- (BOOL)databasePool:(FXSDKFMDatabasePool*)pool shouldAddDatabaseToPool:(FXSDKFMDatabase*)database;

/** Tells the delegate that database was added to the pool.
 
 @param pool     The `FXSDKFMDatabasePool` object.
 @param database The `FXSDKFMDatabase` object.

 */

- (void)databasePool:(FXSDKFMDatabasePool*)pool didAddDatabase:(FXSDKFMDatabase*)database;

@end

