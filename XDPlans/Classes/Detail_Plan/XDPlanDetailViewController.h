//
//  XDPlanDetailViewController.h
//  XDPlans
//
//  Created by xieyajie on 13-9-6.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDTableViewController.h"

@class WantPlan;
@interface XDPlanDetailViewController : XDTableViewController

@property (nonatomic, strong) WantPlan *basePlan;

- (id)initWithStyle:(UITableViewStyle)style action:(BOOL)isAction;


@end
