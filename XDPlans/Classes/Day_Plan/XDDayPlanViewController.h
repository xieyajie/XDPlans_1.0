//
//  XDDayPlanViewController.h
//  XDPlans
//
//  Created by xie yajie on 13-9-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDTableViewController.h"

@class WantPlan;
@class DayPlan;
@interface XDDayPlanViewController : XDTableViewController

@property (nonatomic, strong) WantPlan *actionPlan;
@property (nonatomic, strong) DayPlan *dayPlan;

+ (id)defaultToday;

- (id)initWithStyle:(UITableViewStyle)style canEdit:(BOOL)canEdit;

@end
