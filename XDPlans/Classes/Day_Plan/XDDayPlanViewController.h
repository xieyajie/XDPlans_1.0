//
//  XDDayPlanViewController.h
//  XDPlans
//
//  Created by xie yajie on 13-9-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DayPlan;
@interface XDDayPlanViewController : UITableViewController

@property (nonatomic, strong) NSString *planContent;
@property (nonatomic, strong) DayPlan *dayPlan;

+ (id)defaultToday;

- (id)initWithStyle:(UITableViewStyle)style canEdit:(BOOL)canEdit;

@end
