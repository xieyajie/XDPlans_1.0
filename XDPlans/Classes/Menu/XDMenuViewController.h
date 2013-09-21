//
//  XDMenuViewController.h
//  XDPlans
//
//  Created by xie yajie on 13-9-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+JASidePanel.h"

@interface XDMenuViewController : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style selectedIndex:(NSInteger)index;

- (UINavigationController *)navigationForIndex:(NSInteger)index;

@end
