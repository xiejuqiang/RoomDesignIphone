//
//  RecordDao.m
//  MainFra
//
//  Created by Tang silence on 13-6-25.
//  Copyright (c) 2013年 Tang silence. All rights reserved.
//

#import "RecordDao.h"
#import "DB.h"
#import "CollectDBItem.h"


@implementation RecordDao

-(void)initArray
{
    //对应自己数据库字段名 参考DBString.h
    collectArray = [[NSArray alloc] initWithObjects:@"catID",@"imgURL",@"imgArr", nil];
    systemConfigArray = [[NSArray alloc] initWithObjects:@"cloKey",@"cloValue",@"sortNum",@"classN",@"note", nil];
    newsCategoryArray = [[NSArray alloc] initWithObjects:@"catID",@"catName",@"modelID", nil];
    newsListArray = [[NSArray alloc] initWithObjects:@"nId",@"catId",@"title",@"userName",@"userId",@"thumb",@"description", nil];
    newsDetailArray = [[NSArray alloc] initWithObjects:@"nId",@"title",@"content",@"catId",@"dateline",@"hits", nil];
    newsScrollListArray = [[NSArray alloc] initWithObjects:@"nId",@"title",@"thumb", nil];
    produceCategoryArray = [[NSArray alloc] initWithObjects:@"catID",@"catName",@"modelID",@"parentId", nil];
    produceListArray = [[NSArray alloc] initWithObjects:@"pId",@"catId",@"title",@"userName",@"userId",@"thumb",@"description",@"price",@"xinghao", nil];
    produceDetailArray = [[NSArray alloc] initWithObjects:@"pId",@"title",@"content",@"catid",@"dateline",@"hits",@"price",@"xinghao", nil];
    feedBackListArray = [[NSArray alloc] initWithObjects:@"nId",@"username",@"tel",@"content",@"dateline", nil];

}
-(void)createDB:(NSString *)databaseName
{
    db = [[DB alloc] getDatabase:databaseName];
    [self initArray];
}

- (BOOL)insertAtTable:(NSString *)tablename Clos:(NSArray*)clos
{
    BOOL success = YES;
    NSArray *keys = nil;
    if([tablename isEqualToString:COLLECT_TABLENAME] == YES)
    {
        keys = collectArray;
    }
    
    
    int flag = 0;
    NSString *sqlStr = nil;
    NSString *sqlStr1 = [NSString stringWithFormat:@"INSERT INTO %@ (",tablename];
    NSString *sqlStr2 = @") VALUES (";
    for (NSString *key in keys) {
        flag++;
        if(flag == [keys count])
        {
            sqlStr1 = [NSString stringWithFormat:@"%@ %@",sqlStr1,key];
            sqlStr2 = [NSString stringWithFormat:@"%@ ?",sqlStr2];
        }
        else
        {
            sqlStr1 = [NSString stringWithFormat:@"%@ %@,",sqlStr1,key];
            sqlStr2 = [NSString stringWithFormat:@"%@ ?,",sqlStr2];
        }
    }
    sqlStr2 = [NSString stringWithFormat:@"%@)",sqlStr2];
    
    sqlStr = [NSString stringWithFormat:@"%@%@",sqlStr1,sqlStr2];
    
    [db executeUpdate:sqlStr withArgumentsInArray:clos];
    if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
    return success;
}
- (BOOL)deleteAtIndex:(NSString *)tableName CloValue:(NSString *)cloValue
{
    BOOL success = YES;
    NSArray *keys = nil;
    NSString *sqlStr;
    if([tableName isEqualToString:COLLECT_TABLENAME] == YES)
    {
        keys = collectArray;
    }

    if(cloValue == nil)
    {
        sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE 1==1",tableName];
    }
    else
    {
        sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,[keys objectAtIndex:0]];
    }
    
    [db executeUpdate:sqlStr,cloValue];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}
- (BOOL)updateAtTable:(NSString *)tablename Clos:(NSArray *)clos
{
    BOOL success = YES;
    NSArray *keys = nil;
    if([tablename isEqualToString:COLLECT_TABLENAME] == YES)
    {
        keys = collectArray;
        
        int flag = 0;
        NSString *sqlStr = nil;
        NSString *sqlStr1 = [NSString stringWithFormat:@"UPDATE %@ SET",tablename];
        NSString *sqlStr2 = [NSString stringWithFormat:@"WHERE %@=? AND %@=?",[keys objectAtIndex:0],[keys objectAtIndex:1]];
        for (NSString *key in keys) {
            flag++;
            if(flag == 1)
            {
                continue;
            }
            else if(flag == [keys count])
            {
                sqlStr1 = [NSString stringWithFormat:@"%@ %@=?",sqlStr1,key];
            }
            else
            {
                sqlStr1 = [NSString stringWithFormat:@"%@ %@=?,",sqlStr1,key];
            }
        }
        sqlStr = [NSString stringWithFormat:@"%@ %@",sqlStr1,sqlStr2];
        
        [db executeUpdate:sqlStr withArgumentsInArray:clos];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            success = NO;
        }
    }
    return success;
}
- (NSMutableArray *)resultSetWhere:(NSString *)tablename Where:(NSString *)where
{
    FMResultSet *rs = nil;
    rs=[db executeQuery:where];
//    return [self rsToItem:rs TableName:tablename];
    return nil;
    
}
- (NSMutableArray *)resultSet:(NSString *)tableName Order:(NSString *)order LimitCount:(int)limitCount
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
    FMResultSet *rs = nil;
    NSArray *returnArray = nil;
    if(limitCount != 0 && order != nil)
    {
        rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC LIMIT %d",tableName,order,limitCount]];
    }
    else if(order == nil && limitCount == 0)
    {
        rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",tableName]];
    }
    else if(order != nil)
    {
        rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@",tableName,order]];
    }
    else if(limitCount != 0)
    {
        rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d",tableName,limitCount]];
    }
    
    if([tableName isEqualToString:COLLECT_TABLENAME]==YES)
    {
        while ([rs next])
        {
            returnArray = [[NSArray alloc]initWithObjects:[rs stringForColumn:[rs columnNameForIndex:0]],[rs stringForColumn:[rs columnNameForIndex:1]],[rs stringForColumn:[rs columnNameForIndex:2]],nil];
            CollectDBItem *collectDBItem = [[CollectDBItem alloc]init];
            [collectDBItem initData:returnArray];
            [result addObject:collectDBItem];
        }
    }

    return result;
}

//- (NSMutableArray *)rsToItem:(FMResultSet *)rs TableName:(NSString *)tableName
//{
//    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
//    NSArray *returnArray = nil;
//    if([tableName isEqualToString:PRODUCE_CATEGORY_TABLENAME]==YES)
//    {
//        while ([rs next])
//        {
//            returnArray = [[NSArray alloc]initWithObjects:[rs stringForColumn:[rs columnNameForIndex:0]],[rs stringForColumn:[rs columnNameForIndex:1]],[rs stringForColumn:[rs columnNameForIndex:2]],[rs stringForColumn:[rs columnNameForIndex:3]],nil];
//            ProduceCategoryDBItem *categoryDBItem = [[ProduceCategoryDBItem alloc]init];
//            [categoryDBItem initData:returnArray];
//            [result addObject:categoryDBItem];
//        }
//    }
//    
//    return result;
//}

@end
