//
//  XDPostPlanViewController.h
//  XDPlans
//
//  Created by xieyajie on 13-9-15.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WantPlan;
@interface XDPostPlanViewController : UIViewController

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *endDate;

- (id)initWithCreateNew;

- (id)initWithEditPlan:(WantPlan *)plan;

@end
