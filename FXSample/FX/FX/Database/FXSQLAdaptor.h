//
//  FXSQLAdaptor.h
//  FXWhereModelProj
//
//  Created by FXMVP on 2021/9/28.
//

#import <Foundation/Foundation.h>
#import "FXWhereModel.h"

@interface FXSQLAdaptor : NSObject

/*
 *description:创建数据库
 *tableName：数据库表名称
 *columnInfo：创建时，需要的列信息，字典格式，key表示列名称，value表示数据类型（枚举值，DataTypeText,DataTypeInteger,DataTypeReal,DataTypeLong,DataTypeDate）
 *primaryKey：主键列名称
 */
+(NSString *)createTable:(NSString *)tableName ColumnKeys:(NSDictionary <NSString *,id>*)columnInfo primaryKey:(NSString *)primaryKey;

/*
 *description:向表tableName插入行信息
 *tableName：数据库表名称
 *row：行信息,字典格式，key表示类名称，value表示要插入的值
 */
+(NSString *)insertRow:(NSDictionary <NSString *,id>*)row TableName:(NSString *)tableName;

/*
 *description:查询数据库
 *tableName：数据库表名称
 *columnNames：要查询的列，传空表示查询所有列
 *FXWhereModel：条件查询
 */
+(NSString *)queryLinesWithColumns:(NSArray <NSString *>*)columnNames inTable:(NSString *)tableName where:(FXWhereModel *)FXWhereModel;

/*
 *description:查询数据库
 *tableName：数据库表名称
 *columnNames：要查询的列，传空表示查询所有列
 *FXWhereModel：条件查询
 *columnName：按列名排序
 */
+(NSString *)queryLinesWithColumns:(NSArray <NSString *>*)columnNames inTable:(NSString *)tableName where:(FXWhereModel *)FXWhereModel orderBy:(NSString *)columnName ascend:(BOOL)isAscend;

+(NSString *)queryLinesWithColumns:(NSArray <NSString *>*)columnNames inTable:(NSString *)tableName where:(FXWhereModel *)FXWhereModel orderBy:(NSString *)columnName ascend:(BOOL)isAscend limit:(NSUInteger)lim;
/*
 *description:查询数据库
 *tableName：数据库表名称
 *columnNames：要查询的列，传空表示查询所有列
 *isDistinct：查询数据是否去重
 *FXWhereModel：条件查询
 *columnName：按列名排序
 */
+(NSString *)queryLinesWithColumns:(NSArray <NSString *>*)columnNames distinct:(BOOL)isDistinct inTable:(NSString *)tableName where:(FXWhereModel *)FXWhereModel orderBy:(NSString *)columnName ascend:(BOOL)isAscend;

/*
 *description:查询数据库
 *tableName：数据库表名称
 *columnNames：要查询的列，传空表示查询所有列
 *isDistinct：查询数据是否去重
 *FXWhereModel：条件查询
 *columnName：按列名排序
 *lim:查询条数
 */
+(NSString *)queryLinesWithColumns:(NSArray <NSString *>*)columnNames distinct:(BOOL)isDistinct inTable:(NSString *)tableName where:(FXWhereModel *)FXWhereModel orderBy:(NSString *)columnName ascend:(BOOL)isAscend limit:(NSUInteger)lim;

/*
 *description:更新数据库
 *tableName：数据库表名称
 *row：行信息,字典格式，key表示类名称，value表示要插入的值
 *FXWhereModel：条件更新
 */
+(NSString *)updateWithRow:(NSDictionary <NSString *,id>*)row inTable:(NSString *)tableName where:(FXWhereModel *)FXWhereModel;

/*
 *description:删除行
 *tableName：数据库表名称
 *FXWhereModel：条件删除
 */
+(NSString *)deleteRowsInTable:(NSString *)tableName Where:(FXWhereModel *)FXWhereModel;

/*
 *description:删除数据库表
 *tableName：数据库表名称
 */
+(NSString *)dropTable:(NSString *)tableName;


@end
