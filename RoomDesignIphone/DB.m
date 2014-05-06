//
//  DB.m
//  MainFra
//
//  Created by Tang silence on 13-6-25.
//  Copyright (c) 2013年 Tang silence. All rights reserved.
//

#import "DB.h"
#import "DBString.h"

@implementation DB


- (BOOL)initDatabase:(NSString *)databaseName
{
	BOOL success;
	NSError *error;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:databaseName];
	
	success = [fm fileExistsAtPath:writableDBPath];
	
	if(!success){
		NSString *defaultDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:databaseName];
		success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if(!success){
			NSLog(@"error: %@", [error localizedDescription]);
		}
		success = YES;
	}
	if(success){
		db = [FMDatabase databaseWithPath:writableDBPath];
		if ([db open]) {
			[db setShouldCacheStatements:YES];
		}else{
			NSLog(@"Failed to open database.");
			success = NO;
		}
        [self createTable];
	}
	return success;
}
-(void)createTable
{
    [db executeUpdate:COLLECT_CTEATE_SQL];

}
- (void)closeDatabase
{
	[db close];
}
- (FMDatabase *)getDatabase:(NSString *)databaseName
{
	if ([self initDatabase:databaseName]){
		return db;
	}
	return NULL;
}

//
//- (void)dealloc
//{
//	[self closeDatabase];
//}
@end
