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

#define KMENU_TAG_ALLPLANS 0
#define KMENU_TAG_DETAILPLANS 1
#define KMENU_TAG_DAYPLANS 2
#define KMENU_TAG_SETTING 3

@interface XDMenuController ()
{
    REMenu *_actionMenu;
    REMenu *_unactionMenu;
}

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) REMenu *menu;
@property (nonatomic, strong) NSMutableArray *menuItems;

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
    
    [self menuSelectedItem:];
    [self configurationNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (REMenu *)menu
{
    if (_menu == nil) {
        if (_actionMenu == nil) {
            _actionMenu = [[REMenu alloc] initWithItems:@[wantItem, actionItem, todayItem, settingItem]];
            _actionMenu.cornerRadius = 4;
            _actionMenu.shadowColor = [UIColor blackColor];
            _actionMenu.shadowOffset = CGSizeMake(0, 1);
            _actionMenu.shadowOpacity = 1;
            _actionMenu.imageOffset = CGSizeMake(5, -1);
            
            _actionMenu.textColor = [UIColor whiteColor];
        }
        if (_unactionMenu == nil) {
            _unactionMenu = [[REMenu alloc] initWithItems:@[wantItem, settingItem]];
            _unactionMenu.cornerRadius = 4;
            _unactionMenu.shadowColor = [UIColor blackColor];
            _unactionMenu.shadowOffset = CGSizeMake(0, 1);
            _unactionMenu.shadowOpacity = 1;
            _unactionMenu.imageOffset = CGSizeMake(5, -1);
            
            _unactionMenu.textColor = [UIColor whiteColor];
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
        _currentSelectedIndex = type;
        
//        switch (type) {
//            case KMENU_TAG_ALLPLANS:
//                _wantView = self.allPlansVC.view;
//                break;
//            case KMENU_TAG_DETAILPLANS:
//                _wantView = self.detailPlanVC.view;
//                break;
//            case KMENU_TAG_DAYPLANS:
//                _wantView = self.dayPlanVC.view;
//                break;
//            case KMENU_TAG_SETTING:
//                _wantView = self.settingVC.view;
//                break;
//                
//            default:
//                break;
//        }
//        
//        [_currentView removeFromSuperview];
//        [self.view addSubview:_wantView];
        
//        if (type == KMENU_TAG_ALLPLANS) {
//            self.navigationItem.rightBarButtonItem = _createItem;
//        }
//        else{
//            self.navigationItem.rightBarButtonItem = nil;
//        }
        
        self.title = item.title;
        [self.menuButton setImage:item.image forState:UIControlStateNormal];
        
//        _currentView = _wantView;
//        _wantView = nil;
    }
}


@end
