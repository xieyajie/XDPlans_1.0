//
//  XDTableViewController.h
//  XDHoHo
//
//  Created by xieyajie on 13-12-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REMenuItem;
@interface XDTableViewController : UITableViewController

@property (strong, nonatomic) REMenuItem *menuItem;
@property (strong, nonatomic) UIBarButtonItem *rightItem;

- (void)configurationNavigationBar;

- (void)setBackItem;
- (void)back:(id)sender;

@end
