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
#import "XDPostPlanViewController.h"

#import "XDManagerHelper.h"
#import "REMenu.h"

#define KMENU_TAG_ALLPLANS 0
#define KMENU_TAG_DETAILPLANS 1
#define KMENU_TAG_DAYPLANS 2
#define KMENU_TAG_SETTING 3

@interface XDRootViewController ()
{
    UIBarButtonItem *_menuItem;
    UIBarButtonItem *_createItem;
    
    NSInteger _currentType;
    UIView *_currentView;
    UIView *_wantView;
    
    REMenu *_actionMenu;
    REMenu *_unactionMenu;
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
    
    self.allPlansVC.view.frame = self.view.bounds;
    self.detailPlanVC.view.frame = self.view.bounds;
    self.dayPlanVC.view.frame = self.view.bounds;
    self.settingVC.view.frame = self.view.bounds;
    
    self.title = @"想做的事";
    [self layoutNavigationBar];
    _currentType = KMENU_TAG_ALLPLANS;
    _currentView = self.allPlansVC.view;
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
        _dayPlanVC = [XDDayPlanViewController defaultToday];
    }
    
    return _dayPlanVC;
}

- (XDSettingViewController *)settingVC
{
    if (_settingVC == nil) {
        _settingVC = [[XDSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    
    return _settingVC;
}

- (REMenu *)menu
{
    if (_menu == nil) {
        REMenuItem *wantItem = [[REMenuItem alloc] initWithTitle:@"想做的事"
                                                        subtitle:@"有很多想做的事情，先来几件排个队"
                                                           image:[UIImage imageNamed:@"menu_allPlans.png"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              [self menuSelectedItem:item withtype:KMENU_TAG_ALLPLANS];
                                                          }];
        
        REMenuItem *actionItem = [[REMenuItem alloc] initWithTitle:@"正在进行的事"
                                                           subtitle:@"贪多嚼不烂哦，专心做一件事情吧"
                                                              image:[UIImage imageNamed:@"menu_actionPlan.png"]
                                                   highlightedImage:nil
                                                             action:^(REMenuItem *item) {
                                                                 NSLog(@"Item: %@", item);
                                                                 [self menuSelectedItem:item withtype:KMENU_TAG_DETAILPLANS];
                                                             }];
        
        REMenuItem *todayItem = [[REMenuItem alloc] initWithTitle:@"今天的计划"
                                                            subtitle:@"想做些什么呢？坚持进行下去吧"
                                                               image:[UIImage imageNamed:@"menu_todayPlan.png"]
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                  NSLog(@"Item: %@", item);
                                                                  [self menuSelectedItem:item withtype:KMENU_TAG_DAYPLANS];
                                                              }];
        
        REMenuItem *settingItem = [[REMenuItem alloc] initWithTitle:@"设置"
                                                           subtitle:@"调整一下，让使用更加得心应手"
                                                              image:[UIImage imageNamed:@"menu_setting.png"]
                                                   highlightedImage:nil
                                                             action:^(REMenuItem *item) {
                                                                 NSLog(@"Item: %@", item);
                                                                 [self menuSelectedItem:item withtype:KMENU_TAG_SETTING];
                                                             }];
        
        wantItem.tag = KMENU_TAG_ALLPLANS;
        actionItem.tag = KMENU_TAG_DETAILPLANS;
        todayItem.tag = KMENU_TAG_DAYPLANS;
        settingItem.tag = KMENU_TAG_SETTING;
        
        
        
        if (_actionMenu == nil) {
            _actionMenu = [[REMenu alloc] initWithItems:@[wantItem, actionItem, todayItem, settingItem]];
            _actionMenu.cornerRadius = 4;
            _actionMenu.shadowColor = [UIColor blackColor];
            _actionMenu.shadowOffset = CGSizeMake(0, 1);
            _actionMenu.shadowOpacity = 1;
            _actionMenu.imageOffset = CGSizeMake(5, -1);
        }
        if (_unactionMenu == nil) {
            _unactionMenu = [[REMenu alloc] initWithItems:@[wantItem, settingItem]];
            _unactionMenu.cornerRadius = 4;
            _unactionMenu.shadowColor = [UIColor blackColor];
            _unactionMenu.shadowOffset = CGSizeMake(0, 1);
            _unactionMenu.shadowOpacity = 1;
            _unactionMenu.imageOffset = CGSizeMake(5, -1);
        }
    }
    
    WantPlan *actionPlan = [[XDManagerHelper shareHelper] actionPlan];
    if (actionPlan == nil) {
        return _unactionMenu;
    }
    else{
        return _actionMenu;
    }
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
    [self.allPlansVC createEvent:sender];
}

- (void)menuSelectedItem:(REMenuItem *)item withtype:(NSInteger)type
{
    if (_currentType != type) {
        _currentType = type;
        
        switch (type) {
            case KMENU_TAG_ALLPLANS:
                _wantView = self.allPlansVC.view;
                break;
            case KMENU_TAG_DETAILPLANS:
                _wantView = self.detailPlanVC.view;
                break;
            case KMENU_TAG_DAYPLANS:
                _wantView = self.dayPlanVC.view;
                break;
            case KMENU_TAG_SETTING:
                _wantView = self.settingVC.view;
                break;
                
            default:
                break;
        }
        
        [_currentView removeFromSuperview];
        [self.view addSubview:_wantView];
        
        if (type == KMENU_TAG_ALLPLANS) {
            self.navigationItem.rightBarButtonItem = _createItem;
        }
        else{
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        self.title = item.title;
        [_menuItem setImage:item.image];
        
        _currentView = _wantView;
        _wantView = nil;
    }
}

@end
