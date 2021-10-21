//
//  MTGDatebaseHelper.h
//  MTGSDK
//
//  Created by Tony on 15/10/28.
//


@protocol MTGDatebaseHelper <NSObject>

+ (void)createDatabase;

+ (void)dropDatabase;

+ (void)updateDatabase;

@end
