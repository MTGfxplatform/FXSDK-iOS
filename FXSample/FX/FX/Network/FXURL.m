//
//  FXURL.m
//


#import "FXURL.h"

@implementation FXURL

#pragma mark - Initialization

- (instancetype)initWithString:(NSString *)URLString {
    if (self = [super initWithString:URLString]) {
        _postData = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)URLWithString:(NSString *)URLString {
    return [[FXURL alloc] initWithString:URLString];
}

+ (instancetype)URLWithComponents:(NSURLComponents *)components postData:(NSDictionary<NSString *, NSObject *> *)postData {
    NSString * urlString = components.URL.absoluteString;
    FXURL * fxUrl = [[FXURL alloc] initWithString:urlString];
    [fxUrl.postData addEntriesFromDictionary:postData];

    return fxUrl;
}

#pragma mark - POST Data Convenience Getters

- (NSArray *)arrayForPOSTDataKey:(NSString *)key {
    return (NSArray *)self.postData[key];
}

- (NSDictionary *)dictionaryForPOSTDataKey:(NSString *)key {
    return (NSDictionary *)self.postData[key];
}

- (NSNumber *)numberForPOSTDataKey:(NSString *)key {
    return (NSNumber *)self.postData[key];
}

- (NSString *)stringForPOSTDataKey:(NSString *)key {
    return (NSString *)self.postData[key];
}

@end
