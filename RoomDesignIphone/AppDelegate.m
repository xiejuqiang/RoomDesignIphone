//
//  AppDelegate.m
//  RoomDesignIphone
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "WaterFallViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    Appdate* appdate = [Appdate appdateWithAppleId:844768379];
    appdate.delegate = self;
    
#if NS_BLOCKS_AVAILABLE
    [appdate checkNowWithBlock: ^(NSError* error, NSDictionary* appInfo, BOOL updateAvailable) {
        if (!error)
        {
            
        }
    }];
#endif
    
    WaterFallViewController *waterfallVC = [[WaterFallViewController alloc] init];
    //    HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:waterfallVC];
    self.window.rootViewController = nav;
    [nav setNavigationBarHidden:YES];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark -
#pragma mark Appdate Delegate
//==============================================================================
- (void) appdateComplete: (NSDictionary*) appInfo updateAvailable: (BOOL) updateAvailable
{
    NSLog(@"%@",appInfo);
    if (updateAvailable) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"更新" message:@"发现新版本，是否更新?" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
        [alertV show];
        
    }
}

- (void) appdateFailed: (NSError*) error
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSURL *url = [NSURL URLWithString:AppStorURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        
    }
}

@end
