//
//  FXAPIEndpoints.h
//  FX
//
//  Created by FXMVP on 2021/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXAPIEndpoints : NSObject



+ (NSURL *)buildGetFxidURL;

+ (NSURL *)buildPostEventURL;


@end

NS_ASSUME_NONNULL_END
