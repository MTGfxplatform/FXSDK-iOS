//
//  FXURLRequest.h
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface FXURLRequest : NSMutableURLRequest

/**
 Initializes an URL request with a given URL.
 @param URL The URL for the request.
 @returns Returns a URL request for a specified URL with @c NSURLRequestReloadIgnoringCacheData
 cache policy and @c kRequestTimeoutInterval timeout value.
 */
- (instancetype)initWithURL:(NSURL *)URL HTTPMethod:(NSString *)method attribution:(NSDictionary *)attribution;


/**
 Initializes an URL request with a given URL.
 @param URL The URL for the request.
 @returns Returns a URL request for a specified URL with @c NSURLRequestReloadIgnoringCacheData
 cache policy and @c kRequestTimeoutInterval timeout value.
 */

+ (FXURLRequest *)requestWithURL:(NSURL *)URL HTTPMethod:(NSString *)method attribution:(NSDictionary *)attribution;

@end
NS_ASSUME_NONNULL_END
