//
//  FXWhereModel.m
//  FXWhereModelProj
//
//  Created by 乔阳 on 2018/1/5.
//  Created by FXMVP on 2021/9/28.
//

#import "FXWhereModel.h"
#import "FXMacroDefine.h"

@interface FXWhereModel()

@property (nonatomic,copy)NSString *columnName;
@property (nonatomic) id compareValue;
@property (nonatomic,assign)OPR opr;
@property (nonatomic,assign)DataType type;

@end

@implementation FXWhereModel

-(instancetype)initWithString:(NSString *)sqlString{
    self = [super init];
    if (self) {
        self.sqlString = sqlString;
    }
    return self;
}

FXWhereModel* FXSDKwhere(NSString *column,OPR opr,id compareValue,DataType type){
    
    FXWhereModel *wm = [[FXWhereModel alloc] init];
    wm.columnName = column;
    wm.opr = opr;
    wm.compareValue = compareValue;
    wm.type = type;
    
    NSMutableString *tempString = [NSMutableString string];
    [tempString appendString:wm.columnName];
    
    switch (opr) {
        case OPR_EQUAL:
            {
                [tempString appendString:@"="];
            }
            break;
        case OPR_LARGER:
            {
                [tempString appendString:@">"];
            }
            break;
        case OPR_SMALLER:
            {
                [tempString appendString:@"<"];
            }
            break;
        case OPR_LARGER_OR_EQUAL:
            {
                [tempString appendString:@">="];
            }
            break;
        case OPR_SMALLER_OR_EQUAL:
            {
                [tempString appendString:@"<="];
            }
            break;
        case OPR_NOT_EQUAL:
            {
                [tempString appendString:@"!="];
            }
            break;
            
        default:
            break;
    }
    
    switch (type) {
        case DataTypeText:
        {
            if ([compareValue isKindOfClass:[NSString class]]) {
                if (((NSString *)compareValue).length) {
                    [tempString appendFormat:@"'%@'",(NSString *)compareValue];
                }else{
                    [tempString appendFormat:@"''"];
                }
            }else{
                DLog(@"error---比较数据不是字符串");
                MAssert(1);
                return nil;
            }
        }
            break;
        case DataTypeInteger:
        {
            if ([compareValue isKindOfClass:[NSNumber class]]) {
                [tempString appendString:[NSString stringWithFormat:@"%ld",[(NSNumber *)compareValue longValue]]];
            }else{
                DLog(@"error---比较数据不是数字");
                MAssert(1);
                return nil;
            }
        }
            break;
        case DataTypeReal:
        {
            if ([compareValue isKindOfClass:[NSNumber class]]) {
                [tempString appendString:[NSString stringWithFormat:@"%lf",[(NSNumber *)compareValue doubleValue]]];
            }else{
                DLog(@"error---比较数据不是数字");
                MAssert(1);
                return nil;
            }
        }
            break;
        case DataTypeLong:
        {
            if ([compareValue isKindOfClass:[NSNumber class]]) {
                [tempString appendString:[NSString stringWithFormat:@"%lld",[(NSNumber *)compareValue longLongValue]]];
            }else{
                DLog(@"error---比较数据不是数字");
                MAssert(1);
                return nil;
            }
        }
            break;
        case DataTypeDate:
        {
            if ([compareValue isKindOfClass:[NSDate class]]) {
                [tempString appendString:[NSString stringWithFormat:@"%lf",[(NSDate *)compareValue timeIntervalSince1970]]];
            }else if([compareValue isKindOfClass:[NSNumber class]]){
                [tempString appendString:[NSString stringWithFormat:@"%lld",[(NSNumber *)compareValue longLongValue]]];
            }else{
                DLog(@"error---比较数据不是日期"); 
                MAssert(1);
                return nil;
            }
        }
            break;
            
        default:
            break;
    }
    
    wm.sqlString = tempString.copy;
    return wm;
}

- (id)copyWithZone:(nullable NSZone *)zone{
    FXWhereModel * w = [[FXWhereModel alloc] init];
    w.columnName = _columnName;
    w.opr = _opr;
    w.compareValue = _compareValue;
    w.type = _type;
    w.sqlString = _sqlString;
    return w;
}

-(AndBlock)and{
    
    if (!_and) {
        __weak typeof(self) weakSelf = self;
        _and = [^(FXWhereModel*obj){
            if (obj.sqlString && weakSelf.sqlString) {
                NSMutableString *tempString = [NSMutableString string];
                [tempString appendString:weakSelf.sqlString];
                [tempString appendString:@" AND "];
                [tempString appendString:obj.sqlString];
                weakSelf.sqlString = tempString.copy;
            }
            return weakSelf;
        } copy];
    }
    return _and;
}

-(LimitBlock)limit{
    if (!_limit) {
        __weak typeof(self) weakSelf = self;
        _limit = [^(NSInteger limitCount){
            if (weakSelf.sqlString) {
                NSMutableString *tempString = [NSMutableString string];
                [tempString appendString:weakSelf.sqlString];
                [tempString appendString:@" limit "];
                [tempString appendString:[NSString stringWithFormat:@"%ld",(long)limitCount]];
                weakSelf.sqlString = tempString.copy;
            }
            return weakSelf;
        } copy];
    }
    return _limit;
}

-(OrBlock)or{
    if (!_or) {
        __weak typeof(self) weakSelf = self;
        _or = [^(FXWhereModel*obj){
            if (obj.sqlString && weakSelf.sqlString) {
                NSMutableString *tempString = [NSMutableString string];
                [tempString appendString:weakSelf.sqlString];
                [tempString appendString:@" OR "];
                [tempString appendString:obj.sqlString];
                weakSelf.sqlString = tempString.copy;
            }
            return weakSelf;
        } copy];
    }
    return _or;
}

-(combineAndBlock)combineAnd{
    if (!_combineAnd) {
        __weak typeof(self) weakSelf = self;
        _combineAnd = [^(FXWhereModel*obj){
            if (obj.sqlString && weakSelf.sqlString) {
                NSMutableString *tempString = [NSMutableString string];
                [tempString appendString:@"("];
                [tempString appendString:weakSelf.sqlString];
                [tempString appendString:@" AND "];
                [tempString appendString:obj.sqlString];
                [tempString appendString:@")"];
                weakSelf.sqlString = tempString.copy;
            }
            return weakSelf;
        } copy];
    }
    return _combineAnd;
}

-(combineOrBlock)combineOR{
    if (!_combineOR) {
        __weak typeof(self) weakSelf = self;
        _combineOR = [^(FXWhereModel*obj){
            if (obj.sqlString && weakSelf.sqlString) {
                NSMutableString *tempString = [NSMutableString string];
                [tempString appendString:@"("];
                [tempString appendString:weakSelf.sqlString];
                [tempString appendString:@" OR "];
                [tempString appendString:obj.sqlString];
                [tempString appendString:@")"];
                weakSelf.sqlString = tempString.copy;
            }
            return weakSelf;
        } copy];
    }
    return _combineOR;
}


@end
