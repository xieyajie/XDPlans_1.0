//
//  XDAppDelegate.m
//  XDPlans
//
//  Created by xie yajie on 13-9-21.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDAppDelegate.h"

#import "XDRootViewController.h"
#import "XDNavigationController.h"
#import "XDMenuController.h"
#import "XDAllPlansViewController.h"
#import "XDPlanDetailViewController.h"
#import "XDDayPlanViewController.h"
#import "XDSettingViewController.h"
#import "REMenuItem.h"

@implementation XDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [MagicalRecord setupCoreDataStackWithStoreNamed:KDATABASE_NAME];
    
//    XDMenuController *menuController = [[XDMenuController alloc] init];
//    XDAllPlansViewController *allPlansViewController = [[XDAllPlansViewController alloc] initWithStyle:UITableViewStylePlain];
//    allPlansViewController.menuItem = [[REMenuItem alloc] initWithTitle:@"想做的事" subtitle:@"有很多想做的事情，先来几件排个队" image:[UIImage imageNamed:@"menu_allPlans.png"] highlightedImage:nil action:^(REMenuItem *item) {
//        NSLog(@"Item: %@", item);
//        [menuController menuSelectedItem:item withtype:0];
//    }];
//    
//    XDPlanDetailViewController *detailPlanVC = [[XDPlanDetailViewController alloc] initWithStyle:UITableViewStylePlain action:YES];
//    detailPlanVC.menuItem = [[REMenuItem alloc] initWithTitle:@"正在进行的事" subtitle:@"贪多嚼不烂哦，专心做一件事情吧" image:[UIImage imageNamed:@"menu_actionPlan.png"] highlightedImage:nil action:^(REMenuItem *item) {
//        NSLog(@"Item: %@", item);
//        [menuController menuSelectedItem:item withtype:1];
//    }];
//    
//    XDDayPlanViewController *dayPlanVC = [XDDayPlanViewController defaultToday];
//    dayPlanVC.menuItem = [[REMenuItem alloc] initWithTitle:@"今天的计划" subtitle:@"想做些什么呢？坚持进行下去吧" image:[UIImage imageNamed:@"menu_todayPlan.png"] highlightedImage:nil action:^(REMenuItem *item) {
//        NSLog(@"Item: %@", item);
//        [menuController menuSelectedItem:item withtype:2];
//    }];
//    
//    XDSettingViewController *settingVC = [[XDSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    settingVC.menuItem = [[REMenuItem alloc] initWithTitle:@"设置" subtitle:@"调整一下，让使用更加得心应手" image:[UIImage imageNamed:@"menu_setting.png"] highlightedImage:nil action:^(REMenuItem *item) {
//        NSLog(@"Item: %@", item);
//        [menuController menuSelectedItem:item withtype:3];
//    }];
//    
//    menuController.viewControllers = @[allPlansViewController, detailPlanVC, dayPlanVC, settingVC];
//    
//    self.navigationController = [[XDNavigationController alloc] initWithRootViewController:menuController];
    
    XDRootViewController *rootViewController = [[XDRootViewController alloc] init];
    self.navigationController = [[XDNavigationController alloc] initWithRootViewController:rootViewController];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0]];
    
    self.window.rootViewController = self.navigationController;
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
    [MagicalRecord cleanUp];
}

@end
