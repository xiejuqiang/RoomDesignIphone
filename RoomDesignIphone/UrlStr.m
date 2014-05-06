//
//  UrlStr.m
//  RoomDesign
//
//  Created by apple on 13-12-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "UrlStr.h"
#import "GetObj.h"
#define Default_url @"http://115.29.179.164/"

@implementation UrlStr

- (NSString *)returnURL:(int)urlId Obj:(GetObj *)obj
{
    NSString *returnStr = nil;
    
    switch (urlId) {
        case 1:
            returnStr = [[NSString alloc]initWithFormat:@"%@app/index.php?m=Mobileapi&a=index",Default_url];
            NSLog(@"获取栏目分类接口:%@",returnStr);
            return returnStr;
            break;
            
        case 2:
            returnStr = [[NSString alloc]initWithFormat:@"%@app/index.php?m=Mobileapi&a=searchproduct&cat_id=%@&p=%@",Default_url,obj.catID,obj.page];
            NSLog(@"获取产品展示接口:%@",returnStr);
            return returnStr;
            break;
    }
    return nil;
}

@end
