//
//  DBString.h
//  MainFra
//
//  Created by Tang silence on 13-6-25.
//  Copyright (c) 2013年 Tang silence. All rights reserved.
//





//数据库名
#define DATABASE_NAME @"RoomDesign.sqlite"
//系统设置
#define COLLECT_TABLENAME @"collect"
#define COLLECT_CTEATE_SQL @"create table if not exists collect (catID Integer primary key,offsetH Integer,imgURL text not null,imgArr text not null,titleName text not null)"


