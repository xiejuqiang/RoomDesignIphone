//
//  DB.h
//  MainFra
//
//  Created by Tang silence on 13-6-25.
//  Copyright (c) 2013年 Tang silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DB : NSObject {
	FMDatabase *db;
}

- (BOOL)initDatabase:(NSString *)databaseName;
- (void)closeDatabase;
- (FMDatabase *)getDatabase:(NSString *)databaseName;

@end
