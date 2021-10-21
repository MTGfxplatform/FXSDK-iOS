//
//  FXAPIEndpoints.m
//  FX
//
//  Created by FXMVP on 2021/10/9.
//

#import "FXAPIEndpoints.h"

NSString * const kFXAPIEndpointHostname                   = @"https://api.detailroi.mintegral.com";

NSString * const kFXAPIEndpointPathEvent                   = @"/big_collector/api/sdk/event/bulk";
NSString * const kFXAPIEndpointPathSysid                   = @"/big_collector/api/sdk/sysid";





@implementation FXAPIEndpoints


+ (NSURL *)buildGetFxidURL{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kFXAPIEndpointHostname,kFXAPIEndpointPathSysid];
    return [NSURL URLWithString:urlString];
}


+ (NSURL *)buildPostEventURL{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kFXAPIEndpointHostname,kFXAPIEndpointPathEvent];
    return [NSURL URLWithString:urlString];
}


@end
