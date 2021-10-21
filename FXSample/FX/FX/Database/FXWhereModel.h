//
//  FXWhereModel.h
//  FXWhereModelProj
//
//  Created by 乔阳 on 2018/1/5.
//  Created by FXMVP on 2021/9/28.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DataTypeText,
    DataTypeInteger,
    DataTypeReal,
    DataTypeLong,
    DataTypeDate,
} DataType;

typedef enum : NSUInteger {
    OPR_EQUAL,
    OPR_LARGER,
    OPR_SMALLER,
    OPR_LARGER_OR_EQUAL,
    OPR_SMALLER_OR_EQUAL,
    OPR_NOT_EQUAL
} OPR;

@class FXWhereModel;

FXWhereModel* FXSDKwhere(NSString *column,OPR opr,id compareValue,DataType type);

typedef FXWhereModel*(^AndBlock)(FXWhereModel*);
typedef FXWhereModel*(^OrBlock)(FXWhereModel*);
typedef FXWhereModel*(^LimitBlock)(NSInteger);

typedef FXWhereModel*(^combineOrBlock)(FXWhereModel*);
typedef FXWhereModel*(^combineAndBlock)(FXWhereModel*);


@interface FXWhereModel : NSObject <NSCopying>

@property (nonatomic,copy)NSString *sqlString;

@property (nonatomic,copy)AndBlock and;
@property (nonatomic,copy)OrBlock or;
@property (nonatomic,copy)LimitBlock limit;

@property (nonatomic,copy)combineOrBlock combineOR;
@property (nonatomic,copy)combineAndBlock combineAnd;


-(instancetype)initWithString:(NSString *)sqlString;


@end
