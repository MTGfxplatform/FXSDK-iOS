//
//  FXURLRequest.m
//


#import "FXURLRequest.h"


/**
 Returns a percent-escaped string following RFC 3986 for a query string key or value.
 RFC 3986 states that the following characters are "reserved" characters.
    - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="

 In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
 query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
 should be percent-escaped in the query string.
    - parameter string: The string to be percent-escaped.
    - returns: The percent-escaped string.
 */
static NSString * FXSDKAFPercentEscapedStringFromString(NSString *string) {
    static NSString * const kFXSDKAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kFXSDKAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";

    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kFXSDKAFCharactersGeneralDelimitersToEncode stringByAppendingString:kFXSDKAFCharactersSubDelimitersToEncode]];


    static NSUInteger const batchSize = 50;

    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;

    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);

        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];

        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        if (encoded) {
            [escaped appendString:encoded];
        }
        index += range.length;
    }

    return escaped;
}

#pragma mark -

@interface FXSDKAFQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValue;
@end

@implementation FXSDKAFQueryStringPair

- (id)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.field = field;
    self.value = value;

    return self;
}

- (NSString *)URLEncodedStringValue {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return FXSDKAFPercentEscapedStringFromString([self.field description]);
    } else {
        return [NSString stringWithFormat:@"%@=%@", FXSDKAFPercentEscapedStringFromString([self.field description]), FXSDKAFPercentEscapedStringFromString([self.value description])];
    }
}

@end

#pragma mark -

FOUNDATION_EXPORT NSArray * FXSDKAFQueryStringPairsFromDictionary(NSDictionary *dictionary);
FOUNDATION_EXPORT NSArray * FXSDKAFQueryStringPairsFromKeyAndValue(NSString *key, id value);

static NSString * FXSDKAFQueryStringFromParameters(NSDictionary *parameters) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (FXSDKAFQueryStringPair *pair in FXSDKAFQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValue]];
    }

    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * FXSDKAFQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return FXSDKAFQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * FXSDKAFQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];

    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:FXSDKAFQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:FXSDKAFQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:FXSDKAFQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[FXSDKAFQueryStringPair alloc] initWithField:key value:value]];
    }

    return mutableQueryStringComponents;
}

const NSTimeInterval kRequestTimeoutInterval = 60.0;

NS_ASSUME_NONNULL_BEGIN
@interface FXURLRequest()

@end

@implementation FXURLRequest

- (instancetype)initWithURL:(NSURL *)URL HTTPMethod:(NSString *)method attribution:(NSDictionary *)attribution{

    NSMutableDictionary<NSString *, NSObject *> * postData = [NSMutableDictionary dictionaryWithDictionary:attribution];
    NSURL * requestUrl = URL;

    if (self = [super initWithURL:requestUrl]) {
        // Generate the request
        [self setHTTPShouldHandleCookies:NO];
        [self setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [self setTimeoutInterval:kRequestTimeoutInterval];

        BOOL isPOSTMethod = [method isEqualToString:@"POST"];

        if (isPOSTMethod) {
            [self setHTTPMethod:@"POST"];
            [self setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

            // Move the query parameters to the POST data dictionary.
            // NSURLQueryItem automatically URL decodes the query parameter name and value when using the `name` and `value` properties.
            NSURLComponents * components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
            [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                postData[obj.name] = obj.value;
            }];

            // The incoming URL may contain query parameters; we will need to strip them out.
            components.queryItems = nil;
            requestUrl = components.URL;



            // Generate the JSON body from the POST parameters
            NSError * error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];

            // Set the request body with the query parameter key/value pairs if there was no
            // error in generating a JSON from the dictionary.
            if (error == nil) {
                [self setValue:[NSString stringWithFormat:@"%lu", (unsigned long)jsonData.length] forHTTPHeaderField:@"Content-Length"];
                [self setHTTPBody:jsonData];
            }
            else {
//                MPLogEvent([MPLogEvent error:error message:nil]);
            }
        }else{
            [self setHTTPMethod:@"GET"];
            NSString *query = FXSDKAFQueryStringFromParameters(attribution);
            self.URL = [NSURL URLWithString:[[self.URL absoluteString] stringByAppendingFormat:self.URL.query ? @"&%@" : @"?%@", query]];
        }
    }

    return self;
}


+ (FXURLRequest *)requestWithURL:(NSURL *)URL HTTPMethod:(NSString *)method  attribution:(NSDictionary *)attribution{
    return [[FXURLRequest alloc] initWithURL:URL HTTPMethod:(NSString *)method attribution:attribution];
}

- (NSString *)description {
    if (self.HTTPBody != nil) {
        NSString * httpBody = [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding];
        return [NSString stringWithFormat:@"%@\n\t%@", self.URL, httpBody];
    }
    else {
        return self.URL.absoluteString;
    }
}

@end
NS_ASSUME_NONNULL_END
