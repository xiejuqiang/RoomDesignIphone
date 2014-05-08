//
//  WaterFallDetailViewController.m
//  RoomDesignIphone
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "WaterFallDetailViewController.h"

#import "EGOImageView.h"
#import "UIImage+thumUIImage.h"
#import <CoreText/CoreText.h>
#import "UIView+UIViewEx.h"
#import "UrlStr.h"
#import "JsonParser.h"
#import "GetObj.h"
#import "CollectViewController.h"
#import "RecordDao.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CollectDBItem.h"


@interface WaterFallDetailViewController ()
{
    UIView *bgTileView;
    UIScrollView *leftScrollView;
    UIScrollView *rightScrollView;
}

@end

@implementation WaterFallDetailViewController
@synthesize urlArray;
@synthesize offset_H;
@synthesize isForeign;
@synthesize cat_id = _cat_id;
@synthesize isCollect;
@synthesize titleName = _titleName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        urlStr = [[UrlStr alloc] init];
        jsonParser = [[JsonParser alloc] init];
        isCollect = NO;
        //数据库
        pageNum = 1;
        recordDB = [[RecordDao alloc]init];
        HUD = [[MBProgressHUD alloc] init];
        [recordDB createDB:DATABASE_NAME];
        imgViewTempArray = [[NSMutableArray alloc] init];
        imgURLArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)getData
{
    [self showWithLoding];
    GetObj *getObj = [[GetObj alloc] init];
    getObj.catID = [NSString stringWithFormat:@"%d",_cat_id];
    getObj.page = [NSString stringWithFormat:@"%d",pageNum];
    NSString *productListURL = [urlStr returnURL:2 Obj: getObj];
    [jsonParser parse:productListURL withDelegate:self onComplete:@selector(onConnectionSuccess:) onErrorComplete:@selector(onConnectionError) onNullComplete:@selector(onConnectionNull)];
}

- (void)onConnectionSuccess:(JsonParser *)jsonP
{
    [HUD hide:YES];
    NSDictionary *resultDicData = [jsonP getItems];
    productsData = [[NSArray alloc] initWithArray:[resultDicData objectForKey:@"productLists"]];
    [self createView:offset_H];
    [self createTopView];
}

- (void)onConnectionError
{
    [self showWithTime:@"网络连接出错"];
    [self createTopView];
}

- (void)onConnectionNull
{
    [self showWithTime:@"暂无数据"];
    [self createTopView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    pageNum = offset_H/10 +1;
    
    
    
    offset_H = offset_H%10;
    [self getData];
        
    
    
    
    
    
}

- (void)createTopView
{
    
    UIFont *font = [UIFont systemFontOfSize:16.0];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(425-320, 30, 50, 30)];
    titleLabel1.text = @"设计";
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.textColor = [UIColor blackColor];
    titleLabel1.font = font;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel1.right-7, 25, 30, 30)];
    imgView.image = [UIImage imageNamed:@"logo.jpg"];
    
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(425+65-320, 30, 50, 30)];
    titleLabel2.text = @"助理";
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    titleLabel2.textColor = [UIColor blackColor];
    titleLabel2.font = font;
    

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, 320-10, 2)];
    lineLabel.backgroundColor = [UIColor blackColor];
    [whiteView addSubview:lineLabel];
    
    UILabel *titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    titleNameLabel.bottom = lineLabel.top-2;
    titleNameLabel.text = _titleName;
    titleNameLabel.textAlignment = NSTextAlignmentCenter;
    titleNameLabel.textColor = [UIColor blackColor];
    titleNameLabel.font = font;
    [whiteView addSubview:titleNameLabel];
    
    
    
    [whiteView addSubview:titleLabel1];
    [whiteView addSubview:titleLabel2];
    [whiteView addSubview:imgView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:backButton];
    backButton.titleLabel.font = font;
   
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(320-70, 20, 60, 50)];
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectItem:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:collectButton];
    collectButton.titleLabel.font = font;
    if (isCollect) {
        collectButton.hidden = YES;
    }
    
    BOOL ios7 = [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0 ? YES : NO;
    if (!ios7) {
        backButton.top = 0;
        titleLabel1.top = 10;
        titleLabel2.top = 10;
        collectButton.top = 0;
        imgView.top = 5;
    }
    

}

- (void)clearTap
{
    NSArray *itemArray = [recordDB resultSet:COLLECT_TABLENAME Order:nil LimitCount:10];
    if ([itemArray count]>0) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"是否清空收藏" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertV show];
    }
    else
    {
        [self showWithTime:@"收藏无内容"];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    else
    {
        [recordDB deleteAtIndex:COLLECT_TABLENAME CloValue:0];
        [leftScrollView removeAllSubviews];
        [rightScrollView removeAllSubviews];
        [self showWithTime:@"清除成功"];
        
    }
}

- (void)createView:(int)nId
{
    leftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 100, 310, Screen_height-170)];
    leftScrollView.tag = 100;
    leftScrollView.delegate = self;
    leftScrollView.pagingEnabled = YES;
    leftScrollView.clipsToBounds = NO;
    leftScrollView.maximumZoomScale = 3.0;
    leftScrollView.minimumZoomScale = 1.0;
    [self.view addSubview:leftScrollView];

    int left_offsetH = 0;

    NSArray *imagesArray = [[productsData objectAtIndex:offset_H] objectForKey:@"image_array"];
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    for (NSString *str in imagesArray) {
        if ([str isEqualToString:@""] == NO) {
            [imgArr addObject:str];
        }
    }
    
    for (int j = 0; j <[imgArr count]; j++) {
        EGOImageView *imageViewBig = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"imageDefault.png"]];
        imageViewBig.userInteractionEnabled = YES;
        imageViewBig.isUse = NO;
        imageViewBig.clipsToBounds = YES;
        imageViewBig.contentMode = UIViewContentModeScaleAspectFill;
        imageViewBig.frame = CGRectMake(0, 10+(Screen_height-170)*j, 310, Screen_height-180);
        imageViewBig.imageURL = [[NSURL alloc] initWithString:[imgArr objectAtIndex:j]];
        [imgViewTempArray addObject:imageViewBig];
        [leftScrollView addSubview:imageViewBig];
        left_offsetH = imageViewBig.frame.origin.y;
        imageViewBig.layer.borderWidth = 0.5;
        imageViewBig.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    
    leftScrollView.contentSize = CGSizeMake(310, left_offsetH+Screen_height-170);
    leftScrollView.contentOffset = CGPointMake(0, 0);
    
}

//点击图片移动背景
- (void)tapBg:(UITapGestureRecognizer *)recongnizer
{
    int tag = recongnizer.view.tag-100;
    offset_H = tag;
    int left_offsetH = 0;
    for (int i = 0; i<[imgViewTempArray count];i++) {
        EGOImageView *imgV = [imgViewTempArray objectAtIndex:i];
        [imgV cancelImageLoad];
    }
    [imgViewTempArray removeAllObjects];
    [leftScrollView removeAllSubviews];
    bgTileView.frame = CGRectMake(0, 166.5*tag, 183, 180);
    NSArray *imagesArray = [[productsData objectAtIndex:tag] objectForKey:@"image_array"];
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    for (NSString *str in imagesArray) {
        if ([str isEqualToString:@""] == NO) {
            [imgArr addObject:str];
        }
    }
    for (int i = 0; i<[imgArr count]; i++) {
        EGOImageView *imageViewBig = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"imageDefault.png"]];
        imageViewBig.userInteractionEnabled = YES;
        imageViewBig.isUse = NO;
        imageViewBig.clipsToBounds = YES;
        imageViewBig.contentMode = UIViewContentModeScaleAspectFill;
        imageViewBig.frame = CGRectMake(0, 600*i, 720+70, 600);
        imageViewBig.imageURL = [[NSURL alloc] initWithString:[imgArr objectAtIndex:i]];
        [imgViewTempArray addObject:imageViewBig];
        [leftScrollView addSubview:imageViewBig];
        left_offsetH = imageViewBig.frame.origin.y;
    }
    leftScrollView.contentSize = CGSizeMake(720+70, left_offsetH+600);
    leftScrollView.contentOffset = CGPointMake(0, 0);
}

//收藏点击事件
- (void)collectItem:(UIButton *)btn
{
    NSString *str = @"";
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//    NSMutableArray *myTempArray =[[NSMutableArray alloc] init];
    [tempArray addObject:[productsData objectAtIndex:offset_H]];
    NSString *offset = [NSString stringWithFormat:@"%d",offset_H];
    NSArray *collectClosArray = [[NSArray alloc] initWithObjects:[[tempArray objectAtIndex:0] objectForKey:@"id"],offset, [[tempArray objectAtIndex:0] objectForKey:@"image1"],str,_titleName,nil];
    BOOL tips = NO;
    for (CollectDBItem *item in [recordDB resultSet:COLLECT_TABLENAME Order:nil LimitCount:0]) {
        if ([[collectClosArray objectAtIndex:0] isEqualToString:item.catid]) {
            tips =YES;
        }
    }
    
    if (tips == NO) {
        
        for (NSString *imgStr in [[tempArray objectAtIndex:0] objectForKey:@"image_array"]) {
            str = [str stringByAppendingString:[imgStr stringByAppendingString:@","]];
            if ([imgStr isEqualToString:@""] == NO) {
                NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *imagePath1 = [[[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"EGOCache"] copy] stringByAppendingPathComponent:[NSString stringWithFormat:@"EGOImageLoader-%u", [[imgStr description] hash]]];
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath1]];
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                
                [library writeImageToSavedPhotosAlbum:[imgView.image CGImage] orientation:(ALAssetOrientation)[imgView.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                    if (error) {
                        // TODO: error handling
                    } else {
                        // TODO: success handling
                        NSLog(@"SUCCESS");
                        
                    }
                }];
                
            }
        }
        [recordDB insertAtTable:COLLECT_TABLENAME Clos:collectClosArray];
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"图片已经加入本地图库里" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
    }
    else
    {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"已在收藏夹中" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
    }
    
    
    NSArray *resultItem = [recordDB resultSet:COLLECT_TABLENAME Order:nil LimitCount:0];
    
    CollectViewController *collectVC = [[CollectViewController alloc] init];
    collectVC.imageArr = resultItem;
    collectVC.categoryId = _cat_id;
    [self.navigationController pushViewController:collectVC animated:YES];
    
    
    
    
}

#pragma mark showHud

- (void)showWithTime:(NSString *)lable
{
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = lable;
    [HUD showWhileExecutingT:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)showWithLoding
{
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"加载中...";
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
	// Do something usefull in here instead of sleeping ...
    sleep(1);
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma UIScrollView Delegate Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.tag == 100)
    {
       
        
    }
    else if (scrollView.tag == 200)
    {
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    int offsetY = scrollView.contentOffset.y/(Screen_height-100);
//    scrollView.contentOffset = CGPointMake(0, offsetY*(Screen_height-180));
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
