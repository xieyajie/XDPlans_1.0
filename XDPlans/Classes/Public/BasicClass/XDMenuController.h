//
//  XDMenuController.h
//  XDPlans
//
//  Created by xieyajie on 13-12-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDMenuController : UIViewController

@property (nonatomic, readonly) int currentSelectedIndex;
@property (nonatomic, strong)  NSArray *viewControllers;

@end
