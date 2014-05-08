//
//  CollectViewController.m
//  RoomDesignIphone
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "CollectViewController.h"
#import "TMQuiltView.h"
#import "EGOImageView.h"

#import "TMPhotoQuiltViewCell.h"
#import "UIImage+thumUIImage.h"
#import "UIView+UIViewEx.h"
#import "CollectDBItem.h"
#import "WaterFallDetailViewController.h"
#import "RecordDao.h"

@interface CollectViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate>
{
    TMQuiltView *qtmquitView;
    
}

@end

@implementation CollectViewController
@synthesize images = _images;
@synthesize imageArr;
@synthesize categoryId = _categoryId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        imageArr = [[NSArray alloc] init];
        HUD = [[MBProgressHUD alloc] init];
        recordDB = [[RecordDao alloc] init];
        [recordDB createDB:DATABASE_NAME];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self createTopView];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 50, 50)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(320-65, 20, 60, 50)];
    [collectButton setTitle:@"清除" forState:UIControlStateNormal];
    [collectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(clearTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectButton];
    collectButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    BOOL ios7 = [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0 ? YES : NO;
    if (!ios7) {
        backButton.top = 0;
        collectButton.top = 0;
        
    }
    
    qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(5, 100, 310, Screen_height-100)];
    qtmquitView.delegate = self;
    qtmquitView.dataSource = self;
    [self.view addSubview:qtmquitView];
    
    [self getNextPageView];
    [self createHeaderView];
	// Do any additional setup after loading the view.
}

- (void)createTopView
{
    UIFont *font = [UIFont systemFontOfSize:16.0];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, 320-10, 2)];
    lineLabel.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineLabel];
    
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
    
    BOOL ios7 = [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0 ? YES : NO;
    if (!ios7) {
        
        titleLabel1.top = 10;
        titleLabel2.top = 10;
        imgView.top = 5;
    }
    
    UILabel *titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    titleNameLabel.bottom = lineLabel.top-2;
    titleNameLabel.text = @"收藏夹";
    titleNameLabel.textAlignment = NSTextAlignmentCenter;
    titleNameLabel.textColor = [UIColor blackColor];
    titleNameLabel.font = font;
    [self.view addSubview:titleNameLabel];
    
    [self.view addSubview:titleLabel1];
    [self.view addSubview:titleLabel2];
    [self.view addSubview:imgView];
 
}

- (void)clearTap
{
    NSArray *itemArray = [recordDB resultSet:COLLECT_TABLENAME Order:nil LimitCount:0];
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
        [self.images removeAllObjects];
        [qtmquitView reloadData];
        
    }
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

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     qtmquitView.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[qtmquitView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

//加载调用的方法
-(void)getNextPageView
{
    //	for(int i = 0; i < 10; i++) {
    //		[_images addObject:[NSString stringWithFormat:@"%d.jpeg", i % 10 + 1]];
    //	}
    //    [qtmquitView.infiniteScrollingView stopAnimating];
    //    [_images addObjectsFromArray:imageArr];
	[qtmquitView reloadData];
    [self removeFooterView];
    [self testFinishedLoadData];
    
}

- (NSMutableArray *)images
{
    if (!_images)
	{
        //        NSMutableArray *imageNames = [NSMutableArray array];
        //        for(int i = 0; i < 10; i++) {
        //            [imageNames addObject:[NSString stringWithFormat:@"%d.jpeg", i % 10 + 1]];
        //        }
        _images = [[NSMutableArray alloc] initWithArray:imageArr];
        //        _images = [imageNames retain];
    }
    return _images;
}

-(void)testFinishedLoadData{
	
    [self finishReloadingData];
    [self setFooterView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmquitView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmquitView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(qtmquitView.contentSize.height, qtmquitView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              qtmquitView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         qtmquitView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [qtmquitView addSubview:_refreshFooterView];
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

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
	NSLog(@"刷新完成");
    [self testFinishedLoadData];
	
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos targetscrollView:(UIScrollView *)scrollView
{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (UIImageView *)imageAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row>[self.images count]-1) {
        return nil;
    }
    CollectDBItem *item = [self.images objectAtIndex:indexPath.row];
    NSString *imagePath = item.thumb;
    NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath1 = [[[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"EGOCache"] copy] stringByAppendingPathComponent:[NSString stringWithFormat:@"EGOImageLoader-%u", [[imagePath description] hash]]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath1]];
    UIImage *img =  [imgView.image thumbWithWidth:imgView.image.size.width height:imgView.image.size.height];
    imgView.frame = CGRectMake(0, 0, img.size.width,img.size.height);
    return imgView;
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.images count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] autorelease];
    }
    
    CollectDBItem *item = [self.images objectAtIndex:indexPath.row];
    NSString *strImg = item.thumb;
    NSURL *url = [[NSURL alloc ] initWithString:strImg];
    cell.photoView.imageURL = url;
    if ([quiltView heightForCellAtIndexPath:indexPath]>0)
    {
        cell.titleLabel.hidden = NO;
        cell.titleLabel.text = item.titleName;
    }
    else
    {
        cell.titleLabel.hidden = YES;
    }
    
    //    [cell layoutSubviewsFunction];
    return cell;
}

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
    return 100;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"index:%d",indexPath.row);
    CollectDBItem *item = [self.images objectAtIndex:indexPath.row];
    NSString *offsetH = item.offsetH;
    WaterFallDetailViewController *waterFallDetailVC = [[WaterFallDetailViewController alloc] init];
    waterFallDetailVC.offset_H = [offsetH intValue];
    waterFallDetailVC.cat_id = _categoryId;
    waterFallDetailVC.urlArray = [item.imgArr componentsSeparatedByString:@","];
    waterFallDetailVC.titleName = item.titleName;
    waterFallDetailVC.isCollect = YES;
    [self.navigationController pushViewController:waterFallDetailVC animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
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
