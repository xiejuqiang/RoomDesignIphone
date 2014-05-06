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
}

- (void)onConnectionError
{
    [self showWithTime:@"网络连接出错"];
}

- (void)onConnectionNull
{
    [self showWithTime:@"暂无数据"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    pageNum = offset_H/10 +1;
    
    if (isCollect == YES) {
        productsData = urlArray;
        [self createTopView];
        [self createView:offset_H];
    }
    else
    {
        offset_H = offset_H%10;
        [self getData];
        [self createTopView];
    }
    
    
    
    
}

- (void)createTopView
{
    
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(445-320, 30, 50, 30)];
    titleLabel1.text = @"设计";
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.textColor = [UIColor blackColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
    imgView.frame = CGRectMake(titleLabel1.right-7, 20, 40, 40);
    
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(425+65-320, 30, 50, 30)];
    titleLabel2.text = @"助理";
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    titleLabel2.textColor = [UIColor blackColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, 320-10, 2)];
    lineLabel.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineLabel];
    
    //    UILabel *cookLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, lineLabel.top-30, 90, 30)];
    //    cookLabel.text = @"现代风格";
    //    cookLabel.textAlignment = NSTextAlignmentCenter;
    //    cookLabel.textColor = [UIColor blackColor];
    //
    //    UILabel *houseLabel = [[UILabel alloc] initWithFrame:CGRectMake(425+60, lineLabel.top-30, 90, 30)];
    //    houseLabel.text = @"欧式风格";
    //    houseLabel.textAlignment = NSTextAlignmentCenter;
    //    houseLabel.textColor = [UIColor blackColor];
    //
    //    UILabel *officeLabel = [[UILabel alloc] initWithFrame:CGRectMake(904-90, lineLabel.top-30, 90, 30)];
    //    officeLabel.text = @"田园风格";
    //    officeLabel.textAlignment = NSTextAlignmentCenter;
    //    officeLabel.textColor = [UIColor blackColor];
    
    if (isForeign) {
        titleLabel1.text = @"Design";
        titleLabel2.text = @"Assistant";
        //        cookLabel.text = @"Smartness";
        //        houseLabel.text = @"European";
        //        officeLabel.text = @"Rural";
        
        titleLabel1.frame = CGRectMake(445, 30, 60, 30);
        imgView.frame = CGRectMake(titleLabel1.right-10, 10, 50, 50);
        titleLabel2.frame = CGRectMake(titleLabel1.right-10+40, 30, 70, 30);
    }
    
    [self.view addSubview:titleLabel1];
    [self.view addSubview:titleLabel2];
    //    [self.view addSubview:cookLabel];
    //    [self.view addSubview:houseLabel];
    //    [self.view addSubview:officeLabel];
    [self.view addSubview:imgView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 50, 30)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    if (isCollect) {
        UIButton *clearUpButton = [[UIButton alloc] initWithFrame:CGRectMake(320-70, 30, 60, 30)];
        [clearUpButton setTitle:@"清除" forState:UIControlStateNormal];
        [clearUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [clearUpButton addTarget:self action:@selector(clearTap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:clearUpButton];
    }
    else
    {
        UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(320-70, 30, 60, 30)];
        [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [collectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [collectButton addTarget:self action:@selector(collectItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:collectButton];
    }
    
    //
    //    if (isForeign) {
    //        [backButton setTitle:@"back" forState:UIControlStateNormal];
    //        [collectButton setTitle:@"collect" forState:UIControlStateNormal];
    //    }
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
    leftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 120, 250, Screen_height-120)];
    leftScrollView.tag = 100;
    leftScrollView.delegate = self;
    leftScrollView.pagingEnabled = YES;
    [self.view addSubview:leftScrollView];
    
    rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(260, 120, 320-265, Screen_height-120)];
    rightScrollView.tag = 200;
    rightScrollView.delegate = self;
    [self.view addSubview:rightScrollView];
    
    bgTileView = [[UIView alloc] initWithFrame:CGRectMake(0, 166.5*offset_H, 183, 180)];
    bgTileView.backgroundColor = [UIColor grayColor];
    [rightScrollView addSubview:bgTileView];
    
    int offsetH = 0;
    int left_offsetH = 0;
    for (int i = 0; i<[productsData count]; i++)
    {
        //        NSString *imagePath = [[NSString alloc] initWithFormat:@"%@",[urlArray objectAtIndex:i]];
        //        NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //        NSString *imagePath1 = [[[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"EGOCache"] copy] stringByAppendingPathComponent:[NSString stringWithFormat:@"EGOImageLoader-%u", [[imagePath description] hash]]];
        //        NSLog(@"%u",[[imagePath description] hash]);
        EGOImageView *imageView = [[EGOImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(5+10, 13.5+(162+4.5)*i, 161-8, 161-8);
        imageView.imageURL = [[NSURL alloc] initWithString:[[productsData objectAtIndex:i] objectForKey:@"image1"]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.backgroundColor = [UIColor whiteColor];
        [rightScrollView addSubview:imageView];
        offsetH = imageView.frame.origin.y;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBg:)];
        [imageView addGestureRecognizer:tap];
        tap.view.tag = 100+i;
        
    }
    
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
        imageViewBig.frame = CGRectMake(0, 600*j, 720+70, 600);
        imageViewBig.imageURL = [[NSURL alloc] initWithString:[imgArr objectAtIndex:j]];
        [imgViewTempArray addObject:imageViewBig];
        [leftScrollView addSubview:imageViewBig];
        left_offsetH = imageViewBig.frame.origin.y;
        
    }
    
    rightScrollView.contentSize = CGSizeMake(183, offsetH+161);
    if ([productsData count]<4) {
        rightScrollView.contentOffset = CGPointMake(0, 0);
    }
    else
    {
        rightScrollView.contentOffset = CGPointMake(0, 162*offset_H);
    }
    
    leftScrollView.contentSize = CGSizeMake(720+70, left_offsetH+600);
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
    NSMutableArray *myTempArray =[[NSMutableArray alloc] init];
    [tempArray addObject:[productsData objectAtIndex:offset_H]];
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
    
    NSArray *collectClosArray = [[NSArray alloc] initWithObjects:[[tempArray objectAtIndex:0] objectForKey:@"id"], [[tempArray objectAtIndex:0] objectForKey:@"image1"],str,nil];
    BOOL tips = NO;
    for (CollectDBItem *item in [recordDB resultSet:COLLECT_TABLENAME Order:nil LimitCount:0]) {
        if ([[collectClosArray objectAtIndex:0] isEqualToString:item.catid]) {
            tips =YES;
        }
    }
    
    if (tips == NO) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"图片已经加入本地图库里" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
    }
    
    [recordDB insertAtTable:COLLECT_TABLENAME Clos:collectClosArray];
    NSArray *resultItem = [recordDB resultSet:COLLECT_TABLENAME Order:nil LimitCount:0];
    
    for (CollectDBItem *item in resultItem) {
        NSArray *img_array = [item.imgArr componentsSeparatedByString:@","];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:item.catid,@"id",item.thumb,@"image1",img_array,@"image_array", nil];
        [myTempArray addObject:dic];
    }
    
    
    WaterFallDetailViewController *waterVC = [[WaterFallDetailViewController alloc] init];
    waterVC.isCollect = YES;
    waterVC.urlArray = myTempArray;
    waterVC.offset_H = 0;
    [self.navigationController pushViewController:waterVC animated:YES];
    
    //    NSArray *collectClosArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",offset_H], [urlArray objectAtIndex:offset_H],nil];
    //    [recordDB insertAtTable:COLLECT_TABLENAME Clos:collectClosArray];
    //    NSArray *resultItem = [recordDB resultSet:COLLECT_TABLENAME Order:nil LimitCount:0];
    //    CollectViewController *collectVC = [[CollectViewController alloc] init];
    //    collectVC.imageArr = resultItem;
    //    [self.navigationController pushViewController:collectVC animated:YES];
    //    CollectDBItem *item = [resultItem objectAtIndex:0];
    //   NSString *imagePath =item.thumb;
    
    
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
        //        int offsetY = scrollView.contentOffset.y/600;
        //        bgTileView.frame = CGRectMake(0, 166.5*offsetY, 183, 180);
        //        rightScrollView.contentOffset = CGPointMake(0, 162*offsetY);
        
    }
    else if (scrollView.tag == 200)
    {
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
