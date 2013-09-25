//
//  XDRootViewController.m
//  XDPlans
//
//  Created by xie yajie on 13-9-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDRootViewController.h"

#import "XDAllPlansViewController.h"
#import "XDPlanDetailViewController.h"
#import "XDDayPlanViewController.h"
#import "XDSettingViewController.h"
#import "XDNewPlanViewController.h"

#import "REMenu.h"

@interface XDRootViewController ()
{
    UIBarButtonItem *_menuItem;
    UIBarButtonItem *_createItem;
}

@property (nonatomic, strong) REMenu *menu;

@end

@implementation XDRootViewController

@synthesize menu = _menu;

@synthesize allPlansVC = _allPlansVC;
@synthesize detailPlanVC = _detailPlanVC;
@synthesize dayPlanVC = _dayPlanVC;
@synthesize settingVC = _settingVC;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addChildViewController:self.allPlansVC];
    [self addChildViewController:self.detailPlanVC];
    [self addChildViewController:self.dayPlanVC];
    [self addChildViewController:self.settingVC];
    
    self.title = @"想做的事";
    [self layoutNavigationBar];
    [self.view addSubview:self.allPlansVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getting

- (XDAllPlansViewController *)allPlansVC
{
    if (_allPlansVC == nil) {
        _allPlansVC = [[XDAllPlansViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    
    return _allPlansVC;
}

- (XDPlanDetailViewController *)detailPlanVC
{
    if (_detailPlanVC == nil) {
        _detailPlanVC = [[XDPlanDetailViewController alloc] initWithStyle:UITableViewStylePlain action:YES];
    }
    
    return _detailPlanVC;
}

- (XDDayPlanViewController *)dayPlanVC
{
    if (_dayPlanVC == nil) {
        _dayPlanVC = [[XDDayPlanViewController alloc] initWithStyle:UITableViewStylePlain canEdit:YES];
    }
    
    return _dayPlanVC;
}

- (XDSettingViewController *)settingVC
{
    if (_settingVC == nil) {
        _settingVC = [[XDSettingViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    
    return _settingVC;
}

- (REMenu *)menu
{
    if (_menu == nil) {
        REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"想做的事"
                                                        subtitle:@"有很多想做的事情，先来几件排个队"
                                                           image:[UIImage imageNamed:@"menu_allPlans.png"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              self.title = @"想做的事";
                                                              [_menuItem setImage:[UIImage imageNamed:@"menu_allPlans.png"]];
                                                              self.navigationItem.rightBarButtonItem = _createItem;
                                                              
                                                              
                                                          }];
        
        REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"正在进行的事"
                                                           subtitle:@"贪多嚼不烂哦，专心做一件事情吧"
                                                              image:[UIImage imageNamed:@"menu_actionPlan.png"]
                                                   highlightedImage:nil
                                                             action:^(REMenuItem *item) {
                                                                 NSLog(@"Item: %@", item);
                                                                 self.title = @"正在进行的事";
                                                                 [_menuItem setImage:[UIImage imageNamed:@"menu_actionPlan.png"]];
                                                                 self.navigationItem.rightBarButtonItem = nil;
                                                             }];
        
        REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"今天的计划"
                                                            subtitle:@"想做些什么呢？坚持进行下去吧"
                                                               image:[UIImage imageNamed:@"menu_todayPlan.png"]
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                  NSLog(@"Item: %@", item);
                                                                  self.title = @"今天的计划";
                                                                  [_menuItem setImage:[UIImage imageNamed:@"menu_todayPlan.png"]];
                                                                  self.navigationItem.rightBarButtonItem = nil;
                                                              }];
        
        REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"设置"
                                                              image:[UIImage imageNamed:@"menu_setting.png"]
                                                   highlightedImage:nil
                                                             action:^(REMenuItem *item) {
                                                                 NSLog(@"Item: %@", item);
                                                                 self.title = @"设置";
                                                                 [_menuItem setImage:[UIImage imageNamed:@"menu_setting.png"]];
                                                                 self.navigationItem.rightBarButtonItem = nil;
                                                             }];
        
        homeItem.tag = 0;
        exploreItem.tag = 1;
        activityItem.tag = 2;
        profileItem.tag = 3;
        
        _menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem]];
        _menu.cornerRadius = 4;
        _menu.shadowColor = [UIColor blackColor];
        _menu.shadowOffset = CGSizeMake(0, 1);
        _menu.shadowOpacity = 1;
        _menu.imageOffset = CGSizeMake(5, -1);
    }
    
    return _menu;
}

#pragma mark - layouts

- (void)layoutNavigationBar
{
    if (_menuItem == nil) {
        _menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(menuAction:)];
    }
    self.navigationItem.leftBarButtonItem = _menuItem;
    
    if (_createItem == nil) {
        _createItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createEvent:)];
    }
    
    self.navigationItem.rightBarButtonItem = _createItem;
}

#pragma mark - item/button action

- (void)menuAction:(id)sender
{
    if (self.menu.isOpen)
    {
        return [self.menu close];
    }
    
    [self.menu showFromNavigationController:self.navigationController];
    
}

- (void)createEvent:(id)sender
{
//    NSInteger count = [_dataSource count] + 1;
//    if (count > KPLAN_MAXEVENTCOUNT) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"你已经添加了20件想做的事，完成这些再添加吧" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        return;
//    }
    
    XDNewPlanViewController *newPlanVC = [[XDNewPlanViewController alloc] init];
    [self.navigationController presentModalViewController:newPlanVC animated:YES];
}

@end
