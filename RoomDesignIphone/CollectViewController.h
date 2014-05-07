//
//  CollectViewController.h
//  RoomDesignIphone
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
@class RecordDao;
@interface CollectViewController : UIViewController<EGORefreshTableDelegate>
{
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    RecordDao *recordDB;
    BOOL _reloading;
}
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSArray *imageArr;
@property (nonatomic, assign) int categoryId;

@end
