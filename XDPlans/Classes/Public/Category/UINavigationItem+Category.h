//
//  UINavigationItem+Category.h
//  XDHoHo
//
//  Created by xieyajie on 13-12-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDBarButtonItem;
@interface UINavigationItem (Category)

- (void)setCustomTitle:(NSString *)title;
- (void)setCustomTitleImage:(UIImage *)image;

- (void)setLeftItemWithTarget:(id)target action:(SEL)action title:(NSString *)title;
- (void)setLeftItemWithTarget:(id)target action:(SEL)action image:(UIImage *)image;
- (void)setLeftItemWithButtonItem:(XDBarButtonItem *)item;

- (void)setRightItemWithTarget:(id)target action:(SEL)action title:(NSString *)title;
- (void)setRightItemWithTarget:(id)target action:(SEL)action image:(UIImage *)image;
- (void)setRightItemWithButtonItem:(XDBarButtonItem *)item;

- (void)setBackItemWithTarget:(id)target action:(SEL)action;
- (void)setBackItemWithTarget:(id)target action:(SEL)action title:(NSString *)title;

@end
