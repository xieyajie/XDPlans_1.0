//
//  XDDataPlanViewController.h
//  XDPlans
//
//  Created by xie yajie on 13-9-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDDataPlanViewController : UITableViewController

@property (nonatomic, strong) NSString *planContent;

- (id)initWithStyle:(UITableViewStyle)style canEdit:(BOOL)canEdit;



@end
