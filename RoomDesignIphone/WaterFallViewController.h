//
//  WaterFallViewController.h
//  RoomDesignIphone
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "MBProgressHUD.h"
@class UrlStr;
@class JsonParser;
@class MBProgressHUD;
@class RecordDao;
@interface WaterFallViewController : UIViewController<EGORefreshTableDelegate,MBProgressHUDDelegate>
{
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
    
    UrlStr *urlStr;
    JsonParser *jsonParser;
    MBProgressHUD *HUD;
    RecordDao *recordDB;
    
    UIScrollView *mainScrollView;
    UIScrollView *titleScrollView;
    UIButton *cookLabel;
    UILabel *flagLine;
    NSString *totalPage;
    NSMutableArray *img_str_array;
    int tempTag;
    int thirdTime;//三次的加载机会
    int pageNum;
    int cat_id;
}

@property (nonatomic,assign) BOOL isForeign;
@property (nonatomic,retain) NSArray *dataArray;

@end
