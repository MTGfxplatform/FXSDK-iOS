//
//  FXURL.h
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@interface FXURL : NSURL

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSObject *> * postData;


- (instancetype _Nullable)initWithString:(NSString * _Nullable)URLString;


+ (instancetype _Nullable)URLWithString:(NSString * _Nullable)URLString;


+ (instancetype _Nullable)URLWithComponents:(NSURLComponents * _Nullable)components postData:(NSDictionary<NSString *, NSObject *> * _Nullable)postData;


- (NSArray * _Nullable)arrayForPOSTDataKey:(NSString *)key;


- (NSDictionary * _Nullable)dictionaryForPOSTDataKey:(NSString *)key;


- (NSNumber * _Nullable)numberForPOSTDataKey:(NSString *)key;


- (NSString * _Nullable)stringForPOSTDataKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
