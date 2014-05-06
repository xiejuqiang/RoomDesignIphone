//
//  CollectDBItem.m
//  RoomDesign
//
//  Created by apple on 14-1-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "CollectDBItem.h"

@implementation CollectDBItem
@synthesize catid;
@synthesize thumb;
@synthesize imgArr;
//注意顺序要跟数据库字段创建顺序一致
- (void)initData:(NSArray *)dataArray
{
    
    self.catid = [dataArray objectAtIndex:0];
    self.thumb = [dataArray objectAtIndex:1];
    self.imgArr = [dataArray objectAtIndex:2];

}

@end
