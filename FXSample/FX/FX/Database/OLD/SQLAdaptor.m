//
//  SQLAdaptor.m
//  WhereModelProj
//
//  Created by 乔阳 on 2018/1/5.
//  Copyright © 2018年 Mintegral. All rights reserved.
//

#import "SQLAdaptor.h"

@implementation SQLAdaptor

+(NSString *)createTable:(NSString *)tableName ColumnKeys:(NSDictionary <NSString *,id>*)columnInfo primaryKey:(NSString *)primaryKey{
    if (!tableName.length) {
        return nil;
    }
    NSMutableString *sqlString = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@",tableName];
    [sqlString appendString:@"("];
    
    NSInteger length = columnInfo.allKeys.count;
    [columnInfo.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *dataType = [columnInfo objectForKey:key];
        switch (dataType.integerValue) {
            case DataTypeText:
            {
                [sqlString appendString:idx == length - 1 ? [NSString stringWithFormat:@"%@ TEXT",key]:[NSString stringWithFormat:@"%@ TEXT,",key]];
            }
                break;
            case DataTypeInteger:
            {
                [sqlString appendString:idx == length - 1 ? [NSString stringWithFormat:@"%@ INTEGER",key]:[NSString stringWithFormat:@"%@ INTEGER,",key]];
            }
                break;
            case DataTypeReal:
            {
                [sqlString appendString:idx == length - 1 ? [NSString stringWithFormat:@"%@ REAL",key]: [NSString stringWithFormat:@"%@ REAL,",key]];
            }
                break;
            case DataTypeLong:
            {
                [sqlString appendString:idx == length - 1 ? [NSString stringWithFormat:@"%@ LONG",key]: [NSString stringWithFormat:@"%@ LONG,",key]];
            }
                break;
            case DataTypeDate:
            {
                [sqlString appendString:idx == length - 1 ? [NSString stringWithFormat:@"%@ DATE",key]: [NSString stringWithFormat:@"%@ DATE,",key]];
            }
                break;
                
            default:
                break;
        }
    }];
    if (primaryKey.length && [[columnInfo allKeys] containsObject:primaryKey]) {
        [sqlString appendFormat:@", PRIMARY KEY (%@)",primaryKey];
    }
    [sqlString appendString:@")"];
    return sqlString.copy;
}

+(NSString *)insertRow:(NSDictionary <NSString *,id>*)row TableName:(NSString *)tableName
{
    if (!row.allKeys.count || !tableName.length) {
        return nil;
    }
    NSMutableString *sqlString = [NSMutableString stringWithFormat:@"INSERT INTO %@",tableName];
    NSMutableString *colString = [NSMutableString stringWithString:@"("];
    NSMutableString *valueString = [NSMutableString stringWithString:@"VALUES("];
    
    NSInteger length = row.allKeys.count;
    [row.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [colString appendString:key];
        if (idx != length-1) {
            [colString appendString:@","];
        }
         id value = [row objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [valueString appendFormat:idx == length-1 ? @"'%@'" : @"'%@',",value];
        }else if([value isKindOfClass:[NSNumber class]]){
            NSNumber *tempValue = value;
            NSString *encodeType = [NSString stringWithCString:tempValue.objCType encoding:NSUTF8StringEncoding];
            if ([encodeType isEqualToString:@"d"]) {
                [valueString appendFormat:@"%lf",[tempValue doubleValue]];
            }else if ([encodeType isEqualToString:@"I"]){
                [valueString appendFormat:@"%d",[tempValue unsignedIntValue]];
            }else if ([encodeType isEqualToString:@"L"]){
                [valueString appendFormat:@"%ld",[tempValue unsignedLongValue]];
            }else if ([encodeType isEqualToString:@"i"]){
                [valueString appendFormat:@"%d",[tempValue intValue]];
            }else if ([encodeType isEqualToString:@"l"]){
                [valueString appendFormat:@"%ld",[tempValue longValue]];
            }else if ([encodeType isEqualToString:@"f"]){
                [valueString appendFormat:@"%lf",[tempValue floatValue]];
            }else if ([encodeType isEqualToString:@"q"]){
                 [valueString appendFormat:@"%lld",[tempValue longLongValue]];
            }else if ([encodeType isEqualToString:@"b"]){
                [valueString appendFormat:@"%d",[tempValue boolValue]];
            }else if ([encodeType isEqualToString:@"S"]){
                [valueString appendFormat:@"%d",[tempValue unsignedShortValue]];
            }else if ([encodeType isEqualToString:@"s"]){
                [valueString appendFormat:@"%d",[tempValue shortValue]];
            }else if (tempValue == (void*)kCFBooleanFalse || tempValue == (void*)kCFBooleanTrue){
                [valueString appendFormat:@"%d",[tempValue intValue]];
            }
            if (idx != length-1) {
                [valueString appendString:@","];
            }
        }else if ([value isKindOfClass:[NSDate class]]){
            long long timeStamp = [(NSDate *)value timeIntervalSince1970];
            [valueString appendFormat:@"%lld",timeStamp];
            if (idx != length-1) {
                [valueString appendString:@","];
            }else{
                [valueString appendString:@" "];
            }
        }else{
            [valueString appendFormat:idx == length-1 ? @"'%@'" : @"'%@',",((NSObject *)value).description];
        }
        if (idx == length-1) {
            [colString appendString:@")"];
            [valueString appendString:@")"];
        }
    }];
    [sqlString appendString:colString];
    [sqlString appendString:valueString];
    return sqlString.copy;
}


+(NSString *)queryLinesWithColumns:(NSArray <NSString *>*)columnNames inTable:(NSString *)tableName where:(WhereModel *)whereModel{
    if (!tableName.length) {
        return nil;
    }
    NSMutableString *sqlString = nil;
    if (!columnNames.count) {
        sqlString = [NSMutableString stringWithFormat:@"SELECT * FROM %@ ",tableName];
    }else{
        sqlString = [NSMutableString stringWithString:@"SELECT "];
        NSInteger length = columnNames.count;
        [columnNames enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if (length-1 == idx) {
                [sqlString appendFormat:@"%@ ",key];
            }else{
                [sqlString appendFormat:@"%@,",key];
            }
        }];
        [sqlString appendFormat:@"FROM %@",tableName];
    }
    if (whereModel.sqlString) {
        [sqlString appendFormat:@" WHERE %@",whereModel.sqlString];
    }
   return sqlString.copy;
}

+(NSString *)queryLinesWithColumns:(NSArray <NSString *>*)columnNames inTable:(NSString *)tableName where:(WhereModel *)whereModel orderBy:(NSString *)columnName ascend:(BOOL)isAscend{
    
    if (!tableName.length) {
        return nil;
    }
    NSMutableString *sqlString = nil;
    if (!columnNames.count) {
        sqlString = [NSMutableString stringWithFormat:@"SELECT * FROM %@ ",tableName];
    }else{
        sqlString = [NSMutableString stringWithString:@"SELECT "];
        NSInteger length = columnNames.count;
        [columnNames enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if (length-1 == idx) {
                [sqlString appendFormat:@"%@ ",key];
            }else{
                [sqlString appendFormat:@"%@,",key];
            }
        }];
        [sqlString appendFormat:@"FROM %@",tableName];
    }
    if (whereModel.sqlString) {
        [sqlString appendFormat:@" WHERE %@",whereModel.sqlString];
    }
    if (columnName.length){
        if (isAscend) {
            [sqlString appendFormat:@" ORDER BY %@ ASC",columnName];
        }else{
            [sqlString appendFormat:@" ORDER BY %@ DESC",columnName];
        }
        
    }
    return sqlString.copy;
}

+(NSString *)queryLinesWithColumns:(NSArray <NSString *>*)columnNames inTable:(NSString *)tableName where:(WhereModel *)whereModel orderBy:(NSString *)columnName ascend:(BOOL)isAscend limit:(NSUInteger)lim{
    NSString * str = [self queryLinesWithColumns:(NSArray <NSString *>*)columnNames inTable:(NSString *)tableName where:(WhereModel *)whereModel orderBy:(NSString *)columnName ascend:(BOOL)isAscend];
    return [[str stringByAppendingFormat:@" limit %ld", (unsigned long)lim] copy];
}

+(NSString *)queryLinesWithColumns:(NSArray <NSString *>*)columnNames distinct:(BOOL)isDistinct inTable:(NSString *)tableName where:(WhereModel *)whereModel orderBy:(NSString *)columnName ascend:(BOOL)isAscend{
    NSString *sqlString = [self queryLinesWithColumns:columnNames inTable:tableName where:whereModel orderBy:columnName ascend:isAscend];
    if (isDistinct) {
        NSRange rOriginal = [sqlString rangeOfString:@"SELECT"];
        
        if (NSNotFound != rOriginal.location) {
            NSString * distinctSqr = [sqlString stringByReplacingCharactersInRange:rOriginal withString:@"SELECT DISTINCT"];
            return distinctSqr.copy;
        }else{
            return nil;
        }
    }else{
        return sqlString.copy;
    }
}

+(NSString *)queryLinesWithColumns:(NSArray <NSString *>*)columnNames distinct:(BOOL)isDistinct inTable:(NSString *)tableName where:(WhereModel *)whereModel orderBy:(NSString *)columnName ascend:(BOOL)isAscend limit:(NSUInteger)lim{
    NSString * str = [self queryLinesWithColumns:(NSArray <NSString *>*)columnNames distinct:(BOOL)isDistinct inTable:(NSString *)tableName where:(WhereModel *)whereModel orderBy:(NSString *)columnName ascend:(BOOL)isAscend];
    return [[str stringByAppendingFormat:@" limit %ld", (unsigned long)lim] copy];
}

+(NSString *)updateWithRow:(NSDictionary <NSString *,id>*)row inTable:(NSString *)tableName where:(WhereModel *)whereModel{
    
    if (!tableName.length) {
        return nil;
    }
    NSMutableString *sqlString = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",tableName];
    NSMutableString *valueString = [NSMutableString string];
    NSInteger length = row.allKeys.count;
    [row.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [valueString appendFormat:@"%@=",key];
        id value = [row objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [valueString appendFormat:idx == length-1 ? @"'%@'" : @"'%@',",value];
        }else if([value isKindOfClass:[NSNumber class]]){
            NSNumber *tempValue = value;
            NSString *encodeType = [NSString stringWithCString:tempValue.objCType encoding:NSUTF8StringEncoding];
            if ([encodeType isEqualToString:@"d"]) {
                [valueString appendFormat:@"%lf",[tempValue doubleValue]];
            }else if ([encodeType isEqualToString:@"I"]){
                [valueString appendFormat:@"%d",[tempValue unsignedIntValue]];
            }else if ([encodeType isEqualToString:@"L"]){
                [valueString appendFormat:@"%ld",[tempValue unsignedLongValue]];
            }else if ([encodeType isEqualToString:@"i"]){
                [valueString appendFormat:@"%d",[tempValue intValue]];
            }else if ([encodeType isEqualToString:@"l"]){
                [valueString appendFormat:@"%ld",[tempValue longValue]];
            }else if ([encodeType isEqualToString:@"f"]){
                [valueString appendFormat:@"%lf",[tempValue floatValue]];
            }else if ([encodeType isEqualToString:@"q"]){
                [valueString appendFormat:@"%lld",[tempValue longLongValue]];
            }else if ([encodeType isEqualToString:@"b"]){
                [valueString appendFormat:@"%d",[tempValue boolValue]];
            }else if ([encodeType isEqualToString:@"S"]){
                [valueString appendFormat:@"%d",[tempValue unsignedShortValue]];
            }else if ([encodeType isEqualToString:@"s"]){
                [valueString appendFormat:@"%d",[tempValue shortValue]];
            }else if (tempValue == (void*)kCFBooleanFalse || tempValue == (void*)kCFBooleanTrue){
                [valueString appendFormat:@"%d",[tempValue intValue]];
            }
            if (idx != length-1) {
                [valueString appendString:@","];
            }else{
                [valueString appendString:@" "];
            }
        }else if ([value isKindOfClass:[NSDate class]]){
            long long timeStamp = [(NSDate *)value timeIntervalSince1970];
            [valueString appendFormat:@"%lld",timeStamp];
            if (idx != length-1) {
                [valueString appendString:@","];
            }else{
                [valueString appendString:@" "];
            }
        }else{
            [valueString appendFormat:idx == length-1 ? @"'%@'" : @"'%@',",((NSObject *)value).description];
        }
    }];
    if (whereModel.sqlString) {
        [valueString appendFormat:@" WHERE %@",whereModel.sqlString];
    }
    [sqlString appendString:valueString];
    return sqlString.copy;
}

+(NSString *)deleteRowsInTable:(NSString *)tableName Where:(WhereModel *)whereModel{
    if (!tableName.length) {
        return nil;
    }
    NSMutableString *sqlString = [NSMutableString stringWithFormat:@"DELETE FROM %@ ",tableName];
    if (whereModel.sqlString) {
        [sqlString appendFormat:@"WHERE %@",whereModel.sqlString];
    }
    return sqlString.copy;
}

+(NSString *)dropTable:(NSString *)tableName{
    
    NSString *sql =
    [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
    return sql;
}


@end
