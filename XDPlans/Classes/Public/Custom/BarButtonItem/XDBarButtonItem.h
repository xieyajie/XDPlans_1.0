//
//  XDBarButtonItem.h
//  XDHoHo
//
//  Created by xieyajie on 13-12-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 自定义barbuttonitem
 *
 * @param
 * @return
 */

#define BackgroundImage @"navigationbar_bg.png"
#define ItemImage @""
#define ItemSelectedImage @""

#define BackItemImage @"navigationBar_back.png"
#define BackItemSelectedImage @"navigationBar_back.png"

#define BackItemOffset UIEdgeInsetsMake(0, 0, 0, 0)
#define ItemLeftMargin 10
#define ItemWidth 52
#define ItemHeight 44
#define ItemTextFont 12
#define ItemTextNormalColor [UIColor colorWithRed:240 / 255.0 green:118 / 255.0 blue:56 / 255.0 alpha:1.0]
#define ItemTextSelectedColor [UIColor colorWithRed:240 / 255.0 green:118 / 255.0 blue:56 / 255.0 alpha:1.0]


typedef enum {
    
    XDBarButtonItemTypeDefault = 0,
    XDBarButtonItemTypeBack = 1
    
}XDBarButtonItemType;


@interface XDBarButtonItem : NSObject

@property (nonatomic,assign)XDBarButtonItemType itemType;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *image;
@property (nonatomic,strong)UIFont *font;
@property (nonatomic,strong)UIColor *normalColor;
@property (nonatomic,strong)UIColor *selectedColor;
@property (nonatomic,weak)id target;
@property (nonatomic,assign)SEL selector;
@property (nonatomic,assign)BOOL highlightedWhileSwitch;

- (id)initWithType:(XDBarButtonItemType)itemType;

+ (id)defauleItemWithTarget:(id)target action:(SEL)action title:(NSString *)title;
+ (id)defauleItemWithTarget:(id)target action:(SEL)action image:(NSString *)image;
+ (id)backItemWithTarget:(id)target action:(SEL)action title:(NSString *)title;

- (void)setTarget:(id)target withAction:(SEL)action;


@end