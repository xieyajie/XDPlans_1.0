//
//  XDRootViewController.h
//  XDPlans
//
//  Created by xie yajie on 13-9-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDAllPlansViewController;
@class XDPlanDetailViewController;
@class XDDayPlanViewController;
@class XDSettingViewController;
@interface XDRootViewController : UIViewController

@property (nonatomic, strong) XDAllPlansViewController *allPlansVC;
@property (nonatomic, strong) XDPlanDetailViewController *detailPlanVC;
@property (nonatomic, strong) XDDayPlanViewController *dayPlanVC;
@property (nonatomic, strong) XDSettingViewController *settingVC;

@end
