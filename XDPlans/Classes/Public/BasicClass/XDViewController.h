//
//  XDViewController.h
//  XDUI
//
//  Created by xieyajie on 13-10-14.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSELECTOR_BACK @selector(back:)

@class REMenuItem;
@interface XDViewController : UIViewController

@property (strong, nonatomic) REMenuItem *menuItem;
@property (strong, nonatomic) UIBarButtonItem *rightItem;

@property (nonatomic) CGRect viewFrame;
@property (nonatomic) CGFloat originY;
@property (nonatomic) CGFloat sizeHeight;

- (void)setBackItem;

@end
