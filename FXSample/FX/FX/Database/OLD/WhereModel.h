//
//  WhereModel.h
//  WhereModelProj
//
//  Created by 乔阳 on 2018/1/5.
//  Copyright © 2018年 Mintegral. All rights reserved.
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

@class WhereModel;

WhereModel* where(NSString *column,OPR opr,id compareValue,DataType type);

typedef WhereModel*(^AndBlock)(WhereModel*);
typedef WhereModel*(^OrBlock)(WhereModel*);
typedef WhereModel*(^LimitBlock)(NSInteger);

typedef WhereModel*(^combineOrBlock)(WhereModel*);
typedef WhereModel*(^combineAndBlock)(WhereModel*);


@interface WhereModel : NSObject <NSCopying>

@property (nonatomic,copy)NSString *sqlString;

@property (nonatomic,copy)AndBlock and;
@property (nonatomic,copy)OrBlock or;
@property (nonatomic,copy)LimitBlock limit;

@property (nonatomic,copy)combineOrBlock combineOR;
@property (nonatomic,copy)combineAndBlock combineAnd;


-(instancetype)initWithString:(NSString *)sqlString;


//+(WhereModel *)where(NSString *column,OPR opr,id compareValue,Type type);
//-(WhereModel *)and(WhereModel*wm);
//-(WhereModel *)or(WhereModel*wm);
//-(WhereModel *)not(WhereModel*wm);
//+(WhereModel *)combine(WhereModel*wm1,WhereModel*wm2);
//-(WhereModel *)like(NSString *string);
//-(NSString*)sqlString;

@end
