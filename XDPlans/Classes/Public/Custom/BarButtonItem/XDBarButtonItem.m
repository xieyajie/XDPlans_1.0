//
//  XDBarButtonItem.m
//  XDHoHo
//
//  Created by xieyajie on 13-12-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDBarButtonItem.h"

@implementation XDBarButtonItem

@synthesize itemType = _itemType;
@synthesize button = _button;
@synthesize title = _title;
@synthesize image = _image;
@synthesize font = _font;
@synthesize normalColor = _normalColor;
@synthesize selectedColor = _selectedColor;
@synthesize selector = _selector;
@synthesize target = _target;
@synthesize highlightedWhileSwitch = _highlightedWhileSwitch;

- (void)dealloc {
    
    self.target = nil;
    self.selector = nil;
}

- (id)initWithType:(XDBarButtonItemType)itemType
{
    self = [super init];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button  = button;
        self.itemType = itemType;
        button.titleLabel.font  = [UIFont systemFontOfSize:ItemTextFont];
        [button setTitleColor:ItemTextNormalColor forState:UIControlStateNormal];
        
        [button setTitleColor:ItemTextSelectedColor forState:UIControlStateHighlighted];
        [button setTitleColor:ItemTextSelectedColor forState:UIControlStateSelected];
        button.frame =CGRectMake(0, 0, ItemWidth, ItemHeight);
    }
    
    return self;
}

+ (id)defauleItemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    XDBarButtonItem *item = [[XDBarButtonItem alloc] initWithType:XDBarButtonItemTypeDefault];
    item.title = title;
    [item setTarget:target withAction:action];
    return item;
}

+ (id)defauleItemWithTarget:(id)target action:(SEL)action image:(NSString *)image
{
    XDBarButtonItem *item = [[XDBarButtonItem alloc] initWithType:XDBarButtonItemTypeDefault];
    item.image = image;
    [item setTarget:target withAction:action];
    return item;
}

+ (id)backItemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    XDBarButtonItem *item = [[XDBarButtonItem alloc] initWithType:XDBarButtonItemTypeBack];
    item.title = title;
    [item setTarget:target withAction:action];
    return item;
}

- (void)setItemType:(XDBarButtonItemType)itemType
{
    _itemType = itemType;
    UIImage *image;
    UIImage *image_s;
    switch (itemType) {
        case XDBarButtonItemTypeBack:
        {
            image = [UIImage imageNamed:BackItemImage];
            image_s = [UIImage imageNamed:BackItemSelectedImage];
            
            [_button setImage:image forState:UIControlStateNormal];
            [_button setImage:image_s forState:UIControlStateHighlighted];
            [_button setImage:image_s forState:UIControlStateSelected];
        }
            break;
        case XDBarButtonItemTypeDefault:
        {
            image = [UIImage imageNamed:ItemImage];
            image_s = [UIImage imageNamed:ItemSelectedImage];
            
            [_button setBackgroundImage:image forState:UIControlStateNormal];
            [_button setBackgroundImage:image_s forState:UIControlStateHighlighted];
            [_button setBackgroundImage:image_s forState:UIControlStateSelected];
        }
            break;
        default:
            break;
    }
    
    [self  titleOffsetWithType];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [_button setTitle:title forState:UIControlStateNormal];
    [_button setTitle:title forState:UIControlStateHighlighted];
    [_button setTitle:title forState:UIControlStateSelected];
    
    [self  titleOffsetWithType];
}

- (void)setImage:(NSString *)image
{
    _image = image;
    UIImage *image_ = [UIImage imageNamed:image];
    [_button setImage:image_  forState:UIControlStateNormal];
    [_button setImage:image_ forState:UIControlStateHighlighted];
    [_button setImage:image_ forState:UIControlStateSelected];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [_button.titleLabel setFont:font];
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    [_button setTitleColor:normalColor forState:UIControlStateNormal];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    [_button setTitleColor:selectedColor forState:UIControlStateHighlighted];
    [_button setTitleColor:selectedColor forState:UIControlStateSelected];
}

- (void)setTarget:(id)target withAction:(SEL)action
{
    [_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


- (void)titleOffsetWithType
{
    switch (_itemType) {
        case XDBarButtonItemTypeBack:
        {
            [_button setContentEdgeInsets:BackItemOffset];
        }
            break;
        case XDBarButtonItemTypeDefault:
        {
            [_button setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
            break;
        default:
            break;
    }
}

- (void)setHighlightedWhileSwitch:(BOOL)highlightedWhileSwitch
{
    UIImage *image;
    if (!highlightedWhileSwitch) {
        
        switch (_itemType) {
            case XDBarButtonItemTypeBack:
            {
                image = [UIImage imageNamed:BackItemImage];
            }
                break;
            case XDBarButtonItemTypeDefault:
            {
                image = [UIImage imageNamed:ItemImage];
                
            }
                break;
            default:
                break;
        }
    }else
    {
        switch (_itemType) {
            case XDBarButtonItemTypeBack:
            {
                image = [UIImage imageNamed:BackItemSelectedImage];
            }
                break;
            case XDBarButtonItemTypeDefault:
            {
                image = [UIImage imageNamed:ItemSelectedImage];
                
            }
                break;
            default:
                break;
        }
    }
    [_button setBackgroundImage:image forState:UIControlStateNormal];
    [_button setBackgroundImage:image forState:UIControlStateHighlighted];
    [_button setBackgroundImage:image forState:UIControlStateSelected];
}
@end