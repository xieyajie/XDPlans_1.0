//
//  XDTabBarController.h
//  New
//
//  Created by yajie xie on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDTabBarController : UIViewController
{
    UIView *_slideBg;
}

@property (nonatomic, assign) int currentSelectedIndex;
@property (nonatomic, strong)  NSArray *viewControllers;

- (void)tabBarHidden:(BOOL)hidden;
- (void)tabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
