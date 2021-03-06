//
//  FXSDKFMDatabaseQueue.m
//  FXSDKFMDB
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import "FXSDKFMDatabaseQueue.h"
#import "FXSDKFMDatabase.h"
#import "FXMacroDefine.h"

/*
 
 Note: we call [self retain]; before using dispatch_sync, just incase 
 FXSDKFMDatabaseQueue is released on another thread and we're in the middle of doing
 something in dispatch_sync
 
 */

/*
 * A key used to associate the FXSDKFMDatabaseQueue object with the dispatch_queue_t it uses.
 * This in turn is used for deadlock detection by seeing if inDatabase: is called on
 * the queue's dispatch queue, which should not happen and causes a deadlock.
 */
static const void * const mv_kDispatchQueueSpecificKey = &mv_kDispatchQueueSpecificKey;
 
@implementation FXSDKFMDatabaseQueue

@synthesize path = _path;
@synthesize openFlags = _openFlags;

+ (instancetype)databaseQueueWithPath:(NSString*)aPath {
    
    FXSDKFMDatabaseQueue *q = [[self alloc] initWithPath:aPath];
    
    FXSDKFMDBAutorelease(q);
    
    return q;
}

+ (instancetype)databaseQueueWithPath:(NSString*)aPath flags:(int)openFlags {
    
    FXSDKFMDatabaseQueue *q = [[self alloc] initWithPath:aPath flags:openFlags];
    
    FXSDKFMDBAutorelease(q);
    
    return q;
}

+ (Class)databaseClass {
    return [FXSDKFMDatabase class];
}

- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags vfs:(NSString *)vfsName {
    
    self = [super init];
    
    if (self != nil) {
        
        _db = [[[self class] databaseClass] databaseWithPath:aPath];
        FXSDKFMDBRetain(_db);
        
#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [_db openWithFlags:openFlags vfs:vfsName];
#else
        BOOL success = [_db open];
#endif
        if (!success) {
            DLog(@"Could not create database queue for path %@", aPath);
            FXSDKFMDBRelease(self);
            return 0x00;
        }
        
        _path = FXSDKFMDBReturnRetained(aPath);
        
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"FXSDKFMDB.%@", self] UTF8String], NULL);
        dispatch_queue_set_specific(_queue, mv_kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
        _openFlags = openFlags;
    }
    
    return self;
}

- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags {
    return [self initWithPath:aPath flags:openFlags vfs:nil];
}

- (instancetype)initWithPath:(NSString*)aPath {
    
    // default flags for sqlite3_open
    return [self initWithPath:aPath flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE vfs:nil];
}

- (instancetype)init {
    return [self initWithPath:nil];
}

    
- (void)dealloc {
    
    FXSDKFMDBRelease(_db);
    FXSDKFMDBRelease(_path);
    
    if (_queue) {
        FXSDKFMDBDispatchQueueRelease(_queue);
        _queue = 0x00;
    }
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)close {
    FXSDKFMDBRetain(self);
    dispatch_sync(_queue, ^() {
        [self->_db close];
        FXSDKFMDBRelease(_db);
        self->_db = 0x00;
    });
    FXSDKFMDBRelease(self);
}

- (FXSDKFMDatabase*)database {
    if (!_db) {
        _db = FXSDKFMDBReturnRetained([FXSDKFMDatabase databaseWithPath:_path]);
        
#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [_db openWithFlags:_openFlags];
#else
        BOOL success = [_db open];
#endif
        if (!success) {
            DLog(@"FXSDKFMDatabaseQueue could not reopen database for path %@", _path);
            FXSDKFMDBRelease(_db);
            _db  = 0x00;
            return 0x00;
        }
    }
    
    return _db;
}

- (void)inDatabase:(void (^)(FXSDKFMDatabase *db))block {
    /* Get the currently executing queue (which should probably be nil, but in theory could be another DB queue
     * and then check it against self to make sure we're not about to deadlock. */
    FXSDKFMDatabaseQueue *currentSyncQueue = (__bridge id)dispatch_get_specific(mv_kDispatchQueueSpecificKey);
    assert(currentSyncQueue != self && "inDatabase: was called reentrantly on the same queue, which would lead to a deadlock");
    
    FXSDKFMDBRetain(self);
    
    dispatch_sync(_queue, ^() {
        
        FXSDKFMDatabase *db = [self database];
        block(db);
        
        if ([db hasOpenResultSets]) {
            DLog(@"Warning: there is at least one open result set around after performing [FXSDKFMDatabaseQueue inDatabase:]");
            
#if defined(DEBUG) && DEBUG
            NSSet *openSetCopy = FXSDKFMDBReturnAutoreleased([[db valueForKey:@"_openResultSets"] copy]);
            for (NSValue *rsInWrappedInATastyValueMeal in openSetCopy) {
                FXSDKFMResultSet *rs = (FXSDKFMResultSet *)[rsInWrappedInATastyValueMeal pointerValue];
                DLog(@"query: '%@'", [rs query]);
            }
#endif
        }
    });
    
    FXSDKFMDBRelease(self);
}


- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(FXSDKFMDatabase *db, BOOL *rollback))block {
    FXSDKFMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        BOOL shouldRollback = NO;
        
        if (useDeferred) {
            [[self database] beginDeferredTransaction];
        }
        else {
            [[self database] beginTransaction];
        }
        
        block([self database], &shouldRollback);
        
        if (shouldRollback) {
            [[self database] rollback];
        }
        else {
            [[self database] commit];
        }
    });
    
    FXSDKFMDBRelease(self);
}

- (void)inDeferredTransaction:(void (^)(FXSDKFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:YES withBlock:block];
}

- (void)inTransaction:(void (^)(FXSDKFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:NO withBlock:block];
}

#if SQLITE_VERSION_NUMBER >= 3007000
- (NSError*)inSavePoint:(void (^)(FXSDKFMDatabase *db, BOOL *rollback))block {
    
    static unsigned long savePointIdx = 0;
    __block NSError *err = 0x00;
    FXSDKFMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];
        
        BOOL shouldRollback = NO;
        
        if ([[self database] startSavePointWithName:name error:&err]) {
            
            block([self database], &shouldRollback);
            
            if (shouldRollback) {
                // We need to rollback and release this savepoint to remove it
                [[self database] rollbackToSavePointWithName:name error:&err];
            }
            [[self database] releaseSavePointWithName:name error:&err];
            
        }
    });
    FXSDKFMDBRelease(self);
    return err;
}
#endif

@end
