//
//  XDCircleProgressBar.h
//  XDPlans
//
//  Created by xieyajie on 13-9-27.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDCircleProgressBar : UIControl
{
    UILabel *_percentLabel;
    
    NSInteger _oldPercent;
    BOOL _animating;
}

@property (nonatomic) NSInteger percentValue;
@property (nonatomic, strong) UIColor *color;

- (void)setPercent:(NSInteger)percent animated:(BOOL)animated;

@end
