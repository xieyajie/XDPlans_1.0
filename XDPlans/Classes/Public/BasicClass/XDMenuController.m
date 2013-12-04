//
//  XDMenuController.m
//  XDPlans
//
//  Created by xieyajie on 13-12-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDMenuController.h"

#import "REMenu.h"
#import "WantPlan.h"
#import "XDManagerHelper.h"
#import "XDTableViewController.h"

#define KMENU_TAG_ALLPLANS 0
#define KMENU_TAG_DETAILPLANS 1
#define KMENU_TAG_DAYPLANS 2
#define KMENU_TAG_SETTING 3

@interface XDMenuController ()

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) REMenu *menu;
@property (nonatomic, strong) REMenu *actionMenu;
@property (nonatomic, strong) REMenu *unactionMenu;
@property (nonatomic, strong) NSMutableArray *menuItems;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation XDMenuController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _currentSelectedIndex  = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, applicationFrame.size.width, applicationFrame.size.height)];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [view setBackgroundColor:[UIColor whiteColor]];
    self.view = view;
    
    [view addSubview:self.contentView];
}

#pragma mark - getting

- (UIButton *)menuButton
{
    if (_menuButton == nil) {
        _menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _menuButton;
}

- (REMenu *)actionMenu
{
    if (_actionMenu == nil) {
        _actionMenu = [[REMenu alloc] init];
        _actionMenu.cornerRadius = 4;
        _actionMenu.shadowColor = [UIColor blackColor];
        _actionMenu.shadowOffset = CGSizeMake(0, 1);
        _actionMenu.shadowOpacity = 1;
        _actionMenu.imageOffset = CGSizeMake(5, -1);
        
        _actionMenu.textColor = [UIColor whiteColor];
    }
    
    return _actionMenu;
}

- (REMenu *)unactionMenu
{
    if (_unactionMenu == nil) {
        _unactionMenu = [[REMenu alloc] init];
        _unactionMenu.cornerRadius = 4;
        _unactionMenu.shadowColor = [UIColor blackColor];
        _unactionMenu.shadowOffset = CGSizeMake(0, 1);
        _unactionMenu.shadowOpacity = 1;
        _unactionMenu.imageOffset = CGSizeMake(5, -1);
        
        _unactionMenu.textColor = [UIColor whiteColor];
    }
    
    return _unactionMenu;
}

- (REMenu *)menu
{
    WantPlan *actionPlan = [[XDManagerHelper shareHelper] actionPlan];
    if (actionPlan == nil) {
        return self.unactionMenu;
    }
    else{
        return self.actionMenu;
    }
}

- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    
    return _contentView;
}

#pragma mark - setting

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = viewControllers;
        
        [self configurationMenuItems];
    }
    else {
        _viewControllers = nil;
    }
}

#pragma mark - layout subviews

- (void)configurationMenuItems
{
//    REMenuItem *wantItem = [[REMenuItem alloc] initWithTitle:@"想做的事"
//                                                    subtitle:@"有很多想做的事情，先来几件排个队"
//                                                       image:[UIImage imageNamed:@"menu_allPlans.png"]
//                                            highlightedImage:nil
//                                                      action:^(REMenuItem *item) {
//                                                          NSLog(@"Item: %@", item);
//                                                          [self menuSelectedItem:item withtype:KMENU_TAG_ALLPLANS];
//                                                      }];
//    
//    REMenuItem *actionItem = [[REMenuItem alloc] initWithTitle:@"正在进行的事"
//                                                      subtitle:@"贪多嚼不烂哦，专心做一件事情吧"
//                                                         image:[UIImage imageNamed:@"menu_actionPlan.png"]
//                                              highlightedImage:nil
//                                                        action:^(REMenuItem *item) {
//                                                            NSLog(@"Item: %@", item);
//                                                            [self menuSelectedItem:item withtype:KMENU_TAG_DETAILPLANS];
//                                                        }];
//    
//    REMenuItem *todayItem = [[REMenuItem alloc] initWithTitle:@"今天的计划"
//                                                     subtitle:@"想做些什么呢？坚持进行下去吧"
//                                                        image:[UIImage imageNamed:@"menu_todayPlan.png"]
//                                             highlightedImage:nil
//                                                       action:^(REMenuItem *item) {
//                                                           NSLog(@"Item: %@", item);
//                                                           [self menuSelectedItem:item withtype:KMENU_TAG_DAYPLANS];
//                                                       }];
//    
//    REMenuItem *settingItem = [[REMenuItem alloc] initWithTitle:@"设置"
//                                                       subtitle:@"调整一下，让使用更加得心应手"
//                                                          image:[UIImage imageNamed:@"menu_setting.png"]
//                                               highlightedImage:nil
//                                                         action:^(REMenuItem *item) {
//                                                             NSLog(@"Item: %@", item);
//                                                             [self menuSelectedItem:item withtype:KMENU_TAG_SETTING];
//                                                         }];
//    
//    wantItem.tag = KMENU_TAG_ALLPLANS;
//    actionItem.tag = KMENU_TAG_DETAILPLANS;
//    todayItem.tag = KMENU_TAG_DAYPLANS;
//    settingItem.tag = KMENU_TAG_SETTING;
    
    self.menuItems = [NSMutableArray array];
    NSMutableArray *unactionArray = [NSMutableArray array];
    for (XDTableViewController *vc in self.viewControllers) {
        [self.menuItems addObject:vc.menuItem];
    }
    [unactionArray addObject:self.menuItems.firstObject];
    [unactionArray addObject:self.menuItems.lastObject];
    
    self.actionMenu.items = self.menuItems;
    self.unactionMenu.items = unactionArray;
    
    [self menuSelectedItem:[self.menuItems objectAtIndex:0] withtype:0];
}

- (void)configurationNavigationBar
{
    
}

#pragma mark - button action

- (void)menuAction:(id)sender
{
    if (self.menu.isOpen)
    {
        return [self.menu close];
    }
    
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)menuSelectedItem:(REMenuItem *)item withtype:(NSInteger)type
{
    if (self.currentSelectedIndex != type) {
        if (self.currentSelectedIndex > -1) {
            UIViewController *oldViewController = [self.viewControllers objectAtIndex: self.currentSelectedIndex];
            [oldViewController.view removeFromSuperview];
            [oldViewController removeFromParentViewController];
        }
        
        _currentSelectedIndex = type;
        
        UIViewController *viewController = [self.viewControllers objectAtIndex:type];
        [self addChildViewController:viewController];
        viewController.view.frame = self.contentView.bounds;
        [self.view addSubview:viewController.view];
//        self.navigationItem.rightBarButtonItem = viewController.rightItem;
        
        self.title = item.title;
        [self.menuButton setImage:item.image forState:UIControlStateNormal];
        
//        _currentView = _wantView;
//        _wantView = nil;
    }
}


@end
