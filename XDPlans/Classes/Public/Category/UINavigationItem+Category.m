//
//  UINavigationItem+Category.m
//  XDHoHo
//
//  Created by xieyajie on 13-12-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "UINavigationItem+Category.h"

#import "XDBarButtonItem.h"

#define TitleFont 18
#define TitleColor [UIColor colorWithRed:240 / 255.0 green:118 / 255.0 blue:56 / 255.0 alpha:1.0]

@implementation UINavigationItem (Category)

- (void)setCustomTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 180, 20);
    label.backgroundColor = [UIColor clearColor];
    label.tag = 99901;
    label.font = [UIFont systemFontOfSize:TitleFont];
    label.textColor = TitleColor;
    label.textAlignment = kTextAlignmentCenter;
    label.text = title;
    self.titleView = label;
}

- (void)setCustomTitleImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect bounds = imageView.bounds;
    imageView.tag = 99902;
    bounds.size  =  image.size;
    imageView.bounds = bounds;
    self.titleView = imageView;
}

- (void)setLeftItemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    XDBarButtonItem *buttonItem = [XDBarButtonItem defauleItemWithTarget:target action:action title:title];
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

- (void)setLeftItemWithTarget:(id)target action:(SEL)action image:(UIImage *)image
{
//    XDBarButtonItem *buttonItem = [XDBarButtonItem defauleItemWithTarget:target action:action image:image];
//    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

- (void)setLeftItemWithButtonItem:(XDBarButtonItem *)item
{
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item.button];
}

- (void)setRightItemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    XDBarButtonItem *buttonItem = [XDBarButtonItem defauleItemWithTarget:target action:action title:title];
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

- (void)setRightItemWithTarget:(id)target action:(SEL)action image:(UIImage *)image
{
//    XDBarButtonItem *buttonItem = [XDBarButtonItem defauleItemWithTarget:target action:action image:image];
//    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

- (void)setRightItemWithButtonItem:(XDBarButtonItem *)item
{
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item.button];
}

- (void)setBackItemWithTarget:(id)target action:(SEL)action
{
    XDBarButtonItem *buttonItem = [XDBarButtonItem backItemWithTarget:target action:action title:@""];
    buttonItem.button.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

- (void)setBackItemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    XDBarButtonItem *buttonItem = [XDBarButtonItem backItemWithTarget:target action:action title:title];
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

@end
