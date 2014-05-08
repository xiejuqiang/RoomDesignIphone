//
//  AboutViewController.m
//  RoomDesignIphone
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "AboutViewController.h"
#import "UIView+UIViewEx.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    if (Screen_height>480) {
        
        imageView.image = [UIImage imageNamed:@"about5.jpg"];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"about4.jpg"];
    }
    
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    BOOL ios7 = [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0 ? YES : NO;
    if (!ios7) {
        backButton.top = 0;
    }
    
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

@end
