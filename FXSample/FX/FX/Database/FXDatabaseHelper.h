//
//  FXDatebaseHelper.h
//  FXSDK
//
//  Created by Tony on 15/10/28.
//


@protocol FXDatabaseHelper <NSObject>

+ (void)createDatabase;

+ (void)dropDatabase;

+ (void)updateDatabase;

@end
