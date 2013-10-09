//
//  XDDayPlanViewController.h
//  XDPlans
//
//  Created by xie yajie on 13-9-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDDayPlanViewController : UITableViewController

@property (nonatomic, strong) NSString *planContent;

+ (id)defaultToday;

- (id)initWithStyle:(UITableViewStyle)style canEdit:(BOOL)canEdit;



@end
