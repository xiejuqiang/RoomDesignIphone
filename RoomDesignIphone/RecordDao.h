//
//  RecordDao.h
//  MainFra
//
//  Created by Tang silence on 13-6-25.
//  Copyright (c) 2013年 Tang silence. All rights reserved.
//


#import "DBString.h"

@class FMDatabase;
@interface RecordDao : NSObject{

    FMDatabase *db;
    NSArray *collectArray;
    NSArray *systemConfigArray;
    NSArray *newsCategoryArray;
    NSArray *newsListArray;
    NSArray *newsDetailArray;
    NSArray *newsScrollListArray;
    
    NSArray *produceCategoryArray;
    NSArray *produceListArray;
    NSArray *produceDetailArray;
    
    NSArray *feedBackListArray;
}
-(void)createDB:(NSString *)databaseName;

- (BOOL)insertAtTable:(NSString *)tablename Clos:(NSArray*)clos;
- (BOOL)deleteAtIndex:(NSString *)tableName CloValue:(NSString *)cloValue;
- (BOOL)updateAtTable:(NSString *)tablename Clos:(NSArray *)clos;
//- (NSMutableArray *)resultSetWhere:(NSString *)tablename Where:(NSString *)where;
- (NSMutableArray *)resultSet:(NSString *)tableName Order:(NSString *)order LimitCount:(int)limitCount;
- (NSMutableArray *)resultSetWhere:(NSString *)tablename Where:(NSString *)where;
@end
