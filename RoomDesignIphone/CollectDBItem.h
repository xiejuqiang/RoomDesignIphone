//
//  CollectDBItem.h
//  RoomDesign
//
//  Created by apple on 14-1-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectDBItem : NSObject

@property (nonatomic, retain) NSString *catid;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSString *imgArr;

- (void)initData:(NSArray *)dataArray;
@end
