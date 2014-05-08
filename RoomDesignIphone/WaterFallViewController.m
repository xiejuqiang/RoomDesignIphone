//
//  WaterFallViewController.m
//  RoomDesignIphone
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "WaterFallViewController.h"

#import "TMQuiltView.h"
#import "EGOImageView.h"

#import "TMPhotoQuiltViewCell.h"

#import "SVPullToRefresh.h"
#import "WaterFallDetailViewController.h"
#import "UIImage+thumUIImage.h"
#import "UIView+UIViewEx.h"
#import "UrlStr.h"
#import "JsonParser.h"
#import "GetObj.h"
#import "CollectViewController.h"
#import "RecordDao.h"
#import "AboutViewController.h"
#import "CollectDBItem.h"

@interface WaterFallViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate>
{
	TMQuiltView *qtmquitView;
    NSArray *imageArr;
}
@property (nonatomic, retain) NSMutableArray *images;
@end

@implementation WaterFallViewController
@synthesize images = _images;
@synthesize isForeign;
@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        thirdTime = 1;
        totalPage = @"1";
        imageArr = [[NSArray alloc] initWithObjects:@"http://d.hiphotos.baidu.com/image/w%3D2048/sign=c839e1304936acaf59e091fc48e18c10/9825bc315c6034a85d091a88c9134954082376cb.jpg",
                    @"http://e.hiphotos.baidu.com/image/w%3D2048/sign=5ac7acca3887e9504217f46c24005243/37d12f2eb9389b50a305435b8735e5dde6116ec5.jpg",
                    @"http://c.hiphotos.baidu.com/image/w%3D2048/sign=7d423bfa7b310a55c424d9f4837d42a9/a8014c086e061d95800f963179f40ad162d9ca6a.jpg",
                    @"http://d.hiphotos.baidu.com/image/w%3D2048/sign=8214425457fbb2fb342b5f127b7221a4/37d3d539b6003af3e17d9669372ac65c1138b6f0.jpg",
                    @"http://d.hiphotos.baidu.com/image/w%3D2048/sign=599484b51c178a82ce3c78a0c23b728d/63d9f2d3572c11df725ec15a612762d0f703c238.jpg",
                    @"http://h.hiphotos.baidu.com/image/w%3D2048/sign=64e12999f503918fd7d13aca65052797/242dd42a2834349b04fd10fccbea15ce37d3becb.jpg",
                    @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=7ae833780855b3199cf9857577918326/4d086e061d950a7bd72331bd08d162d9f2d3c9b1.jpg",
                    @"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b1cd9fb1a2ec08fa260014a76dd63c6d/2934349b033b5bb58f241bf034d3d539b700bcc8.jpg",
                    @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=436dd70dca95d143da76e32347c88302/dbb44aed2e738bd4b2d6893fa38b87d6267ff9cc.jpg",
                    @"http://e.hiphotos.baidu.com/image/w%3D2048/sign=5148d1a32934349b74066985fdd214ce/2fdda3cc7cd98d10758c3c88203fb80e7bec902a.jpg",
                    @"http://c.hiphotos.baidu.com/image/w%3D2048/sign=11b2f576f01fbe091c5ec4145f580d33/64380cd7912397ddcb3d52045b82b2b7d0a2876e.jpg",
                    @"http://e.hiphotos.baidu.com/image/w%3D2048/sign=9f704512d60735fa91f049b9aa690eb3/f703738da977391287736268fa198618367ae266.jpg",
                    @"http://d.hiphotos.baidu.com/image/w%3D2048/sign=65cc1e8e0d2442a7ae0efaa5e57bac4b/f9198618367adab4b1703f4e89d4b31c8701e41f.jpg",
                    @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=08f233a1f403738dde4a0b228723b151/a8ec8a13632762d046f0e8bea2ec08fa503dc6e1.jpg",
                    @"http://e.hiphotos.baidu.com/image/w%3D2048/sign=8736bc2f9113b07ebdbd570838ef9023/e61190ef76c6a7efb2df9328fffaaf51f2de66c6.jpg",nil];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initData];
    [self getData];
    
    
    
    
}

- (void)getData
{
    [self showWithLoding];
    NSString *categoryUrl = [urlStr returnURL:1 Obj:nil];
    [jsonParser parse:categoryUrl withDelegate:self onComplete:@selector(connectionSuccess:) onErrorComplete:@selector(connectionError) onNullComplete:@selector(connectionNull)];
    
}

- (void)connectionSuccess:(JsonParser *)jsonP
{
    NSArray *resultData = [jsonP getItems];
    self.dataArray = resultData;
    NSLog(@"%@",resultData);
    //    [HUD hide:YES];
    [self createTopView];
    [self createScrollView];
    [self getData:cat_id];
}

- (void)connectionError
{
    [self showWithTime:@"网络连接错误"];
}

- (void)connectionNull
{
    [self showWithTime:@"暂无数据"];
}

- (void)initData
{
    pageNum = 0;
    cat_id = 2;
    urlStr = [[UrlStr alloc] init];
    jsonParser = [[JsonParser alloc] init];
    HUD = [[MBProgressHUD alloc] init];
    _images = [[NSMutableArray alloc] init];
    img_str_array = [[NSMutableArray alloc] init];
    
    recordDB = [[RecordDao alloc]init];
    [recordDB createDB:DATABASE_NAME];
}

- (void)getData:(int)catid
{
    [self showWithLoding];
    if (tempTag == catid+99) {
        pageNum++;
        if (pageNum>[totalPage intValue]) {
            [self showWithTime:@"没有内容了"];
            TMQuiltView *qtmView = (TMQuiltView *)[mainScrollView viewWithTag:tempTag];
            [qtmView reloadData];
            [self removeFooterView];
            [self testFinishedLoadData:qtmView];
            return;
        }
    }
    else
    {
        pageNum = 1;
        if ([_images count]>0) {
            [_images removeAllObjects];
        }
    }
    
    GetObj *getObj = [[GetObj alloc] init];
    getObj.catID = [[dataArray objectAtIndex:catid-1] objectForKey:@"id"];
    getObj.page = [NSString stringWithFormat:@"%d",pageNum];;
    
    tempTag = 99+catid;
    NSString *productListURL = [urlStr returnURL:2 Obj: getObj];
    [jsonParser parse:productListURL withDelegate:self onComplete:@selector(onConnectionSuccess:) onErrorComplete:@selector(onConnectionError) onNullComplete:@selector(onConnectionNull)];
}

- (void)onConnectionSuccess:(JsonParser *)jsonP
{
    //    if ([_images count]>0) {
    //        [_images removeAllObjects];
    //    }
    [img_str_array removeAllObjects];
    NSDictionary *resultDicData = [jsonP getItems];
    NSArray *productsData = [[NSArray alloc] initWithArray:[resultDicData objectForKey:@"productLists"]];
    [_images addObjectsFromArray:productsData];
    for (NSDictionary *imgStrDic in productsData) {
        
        NSString *imgStr = [imgStrDic objectForKey:@"image1"];
        [img_str_array addObject:imgStr];
        
    }
    totalPage = [resultDicData objectForKey:@"totalPages"];
    
    TMQuiltView *qtmView = (TMQuiltView *)[mainScrollView viewWithTag:tempTag];
    [self createHeaderView:qtmView];
    [self getNextPageView:qtmView];
    
    [HUD hide:YES];
}

- (void)onConnectionError
{
    [self showWithTime:@"网络出错！"];
    
}

- (void)onConnectionNull
{
    [self showWithTime:@"暂无内容"];
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

- (void)createScrollView
{
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 320, Screen_height-100)];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.delegate = self;
    mainScrollView.tag = 1000;
    mainScrollView.contentSize = CGSizeMake(320*[dataArray count], Screen_height-100);
    mainScrollView.contentOffset = CGPointMake(320, 0);
    [self.view addSubview:mainScrollView];
    for (int i = 0; i<[dataArray count]; i++) {
        TMQuiltView  *qtmView = [[TMQuiltView alloc] initWithFrame:CGRectMake(5+320*i, 0, 320-10, Screen_height-100)];
        qtmView.delegate = self;
        qtmView.dataSource = self;
        qtmView.tag = i+100;
        
        //	qtmquitView.backgroundColor = [UIColor grayColor];
        [mainScrollView addSubview:qtmView];
        
        if (i == 1) {
            tempTag = qtmView.tag;
        }
        
        
        
        
        //    [qtmquitView addInfiniteScrollingWithActionHandler:^{
        //        [self insertRowAtBottom];
        //    }];
        
        
    }
}

- (void)createTopView
{
    UIFont *font = [UIFont systemFontOfSize:16.0];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
    [backButton setTitle:@"更多" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(425-320, 30, 50, 30)];
    titleLabel1.text = @"设计";
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.textColor = [UIColor blackColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel1.right-7, 25, 30, 30)];
    imgView.image = [UIImage imageNamed:@"logo.jpg"];
    
    
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(425+65-320, 30, 50, 30)];
    titleLabel2.text = @"助理";
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    titleLabel2.textColor = [UIColor blackColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, 320-10, 2)];
    lineLabel.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineLabel];
    
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(320-70, 20, 60, 50)];
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectButton];
    
    backButton.titleLabel.font = font;
    titleLabel1.font = font;
    titleLabel2.font = font;
    collectButton.titleLabel.font = font;
    BOOL ios7 = [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0 ? YES : NO;
    if (!ios7) {
        backButton.top = 0;
        titleLabel1.top = 10;
        titleLabel2.top = 10;
        collectButton.top = 0;
        imgView.top = 5;
    }
    
    
    titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, lineLabel.top-33, 320-10, 33)];
    titleScrollView.delegate = self;
    titleScrollView.tag = 2000;
    titleScrollView.scrollEnabled = NO;
    titleScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleScrollView];
    titleScrollView.contentSize = CGSizeMake(200*(([dataArray count]+2)/3+1), 33);
    titleScrollView.contentOffset = CGPointMake(0, 0);
    flagLine = [[UILabel alloc] initWithFrame:CGRectMake(360+75-320, titleScrollView.top+30, 80, 3)];
    flagLine.backgroundColor = [UIColor blackColor];
    [self.view addSubview:flagLine];
    
    for (int i = 0; i<[dataArray count]; i++) {

        cookLabel = [[UIButton alloc] initWithFrame:CGRectMake(30+(i+1)*90, 0, 70, 30)];
        [cookLabel setTitle:[[dataArray objectAtIndex:i] objectForKey:@"cname"] forState:UIControlStateNormal];
        cookLabel.tag = i + 99;
        [cookLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cookLabel.backgroundColor = [UIColor clearColor];
        cookLabel.titleLabel.font = [UIFont systemFontOfSize:14.0];
        //        [cookLabel addTarget:self action:@selector(categoryTap:) forControlEvents:UIControlEventTouchUpInside];
        [titleScrollView addSubview:cookLabel];
        
    }
    
    
    
    [self.view addSubview:titleLabel1];
    [self.view addSubview:titleLabel2];
    [self.view addSubview:imgView];
    
}

- (void)collectTap
{
    NSArray *resultItem = [recordDB resultSet:COLLECT_TABLENAME Order:nil LimitCount:0];
    if ([resultItem count]>0) {
        NSMutableArray *myTempArray =[[NSMutableArray alloc] init];
        for (CollectDBItem *item in resultItem) {
            NSArray *img_array = [item.imgArr componentsSeparatedByString:@","];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:item.catid,@"id",item.thumb,@"image1",img_array,@"image_array", nil];
            [myTempArray addObject:dic];
        }
        
        
//        WaterFallDetailViewController *waterVC = [[WaterFallDetailViewController alloc] init];
//        waterVC.isCollect = YES;
//        waterVC.urlArray = myTempArray;
//        waterVC.offset_H = 0;
//        [self.navigationController pushViewController:waterVC animated:YES];
        CollectViewController *collectVC = [[CollectViewController alloc] init];
        collectVC.imageArr = resultItem;
        collectVC.categoryId = [[[dataArray objectAtIndex:cat_id-1] objectForKey:@"id"] intValue];
        [self.navigationController pushViewController:collectVC animated:YES];
    }
    else
    {
        [self showWithTime:@"暂无收藏内容"];
    }
    
    
}

- (void)more
{
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)categoryTap:(UIButton *)btn
{
    int flag = btn.tag - 99;
    [UIView animateWithDuration:0.5 animations:^{
        titleScrollView.contentOffset = CGPointMake(flag*331, 0);
        mainScrollView.contentOffset = CGPointMake(1024*flag, 0);
    }];
    
    [self getData:flag];
    
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView:(TMQuiltView *)qtmView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - qtmView.bounds.size.height,
                                     qtmView.frame.size.width, qtmView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[qtmView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData:(TMQuiltView *)qtmView{
	
    [self finishReloadingData:qtmView];
    [self setFooterView:qtmView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData:(TMQuiltView *)qtmView{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmView];
        [self setFooterView:qtmView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView:(TMQuiltView *)qtmView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(qtmView.contentSize.height, qtmView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              qtmView.frame.size.width,
                                              qtmView.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         qtmView.frame.size.width, qtmView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [qtmView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos qtmViewScrollView:(UIScrollView *)scrollView{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    int flag = scrollView.tag;
    TMQuiltView *qtmView = (TMQuiltView *)[mainScrollView viewWithTag:flag];
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
        
        [self performSelector:@selector(refreshView:) withObject:qtmView afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        [self performSelector:@selector(addMorePage:) withObject:qtmView afterDelay:2.0];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView:(TMQuiltView *)qtmView
{
	NSLog(@"刷新完成");
    [self testFinishedLoadData:qtmView];
	
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos targetscrollView:(UIScrollView *)scrollView
{
	if (scrollView.tag == 1000) {
        
    }
    else
    {
        [self beginToReloadData:aRefreshPos qtmViewScrollView:scrollView];
    }
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)reloadImageData:(TMQuiltView *)qtView
{
    [qtView reloadData];
    [self removeFooterView];
    [self testFinishedLoadData:qtView];
}

- (void)insertRowAtBottom:(TMQuiltView *)qtView
{
    [self getNextPageView:qtView];
    [self performSelector:@selector(reloadImageData:) withObject:qtmquitView afterDelay:2.5];
    
}

//翻页调用方法
- (void)addMorePage:(TMQuiltView *)qtView
{
    if (qtView.tag == tempTag) {
        
        return [self getData:qtView.tag-99];
    }
}

//加载调用的方法
-(void)getNextPageView:(TMQuiltView *)qtView
{
    //	for(int i = 0; i < 10; i++) {
    //		[_images addObject:[NSString stringWithFormat:@"%d.jpeg", i % 10 + 1]];
    //	}
    //    [qtmquitView.infiniteScrollingView stopAnimating];
    
    //    [_images addObjectsFromArray:imageArr];
	[qtView reloadData];
    [self removeFooterView];
    [self testFinishedLoadData:qtView];
    
}

//- (NSMutableArray *)images
//{
//    if (!_images)
//	{
//        _images = [[NSMutableArray alloc] initWithArray:imageArr];
//    }
//    return _images;
//}

- (UIImageView *)imageAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row>[self.images count]-1) {
        return nil;
    }
    NSString *imagePath = [[NSString alloc] initWithFormat:@"%@",[self.images objectAtIndex:indexPath.row]];
    NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath1 = [[[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"EGOCache"] copy] stringByAppendingPathComponent:[NSString stringWithFormat:@"EGOImageLoader-%u", [[imagePath description] hash]]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath1]];
    UIImage *img =  [imgView.image thumbWithWidth:imgView.image.size.width height:imgView.image.size.height];
    imgView.frame = CGRectMake(0, 0, img.size.width,img.size.height);
    return imgView;
}

//- (CGSize)imageAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSURL *url = [[NSURL alloc] initWithString:[self.images objectAtIndex:indexPath.row]];
//
//   return  [self getImageSizeWithURL:url];
//}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.images count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] autorelease];
    }
    
    //    cell.photoView.image = [self imageAtIndexPath:indexPath];
    NSDictionary *proDic = [self.images objectAtIndex:indexPath.row];
    NSString *strImg = [proDic objectForKey:@"image1"];
    NSString *titleName = [proDic objectForKey:@"sdesc"];
    NSURL *url = [[NSURL alloc ] initWithString:strImg];
    cell.photoView.imageURL = url;
    if ([quiltView heightForCellAtIndexPath:indexPath]>50)
    {
        cell.titleLabel.hidden = NO;
        cell.titleLabel.text = titleName;
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.titleLabel.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    }
    else
    {
        cell.titleLabel.hidden = YES;
    }
    
    return cell;
}

#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
	
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
	{
        return 3;
    } else {
        return 3;
    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%f",[self imageAtIndexPath:indexPath].size.height);
    NSLog(@"Page:%d",indexPath.row);
    //    if (indexPath.row>[self.images count]-1 || [self.images count] == 0) {
    //        return 0.0;
    //    }
    //    NSDictionary *proDic = [self.images objectAtIndex:indexPath.row];
    //    NSString *cellHeight = [proDic objectForKey:@"unit2"];
    //    if ([cellHeight floatValue]<350) {
    //        return [cellHeight floatValue]/1.5;
    //    }
    //    return [cellHeight floatValue]/3.0;
    return 100;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"index:%d",indexPath.row);
    NSDictionary *proDic = [self.images objectAtIndex:indexPath.row];
    NSString *titleName = [proDic objectForKey:@"sdesc"];
    WaterFallDetailViewController *waterFallDetailVC = [[WaterFallDetailViewController alloc] init];
    waterFallDetailVC.offset_H = indexPath.row;
    waterFallDetailVC.cat_id = [[[dataArray objectAtIndex:cat_id-1] objectForKey:@"id"] intValue];
    waterFallDetailVC.urlArray = img_str_array;
    waterFallDetailVC.isForeign = self.isForeign;
    waterFallDetailVC.titleName = titleName;
    
    [self.navigationController pushViewController:waterFallDetailVC animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 1000)
    {
        float flag = scrollView.contentOffset.x/320.0;
        titleScrollView.contentOffset = CGPointMake(flag*90, 0);
    }
    else if (scrollView.tag == 2000)
    {
        
    }
    else
    {
        
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag == 1000)
    {
        if (decelerate) {
            
        }
        
        
    }
    else if (scrollView.tag == 2000)
    {
        
    }
    else{
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1000)
    {
        
        int flag = scrollView.contentOffset.x/320;
        cat_id = flag+1;
        if (thirdTime!=flag) {
            
            [self getData:flag+1];
            thirdTime = flag;
        }
        
        
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
