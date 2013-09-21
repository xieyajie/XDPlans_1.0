//
//  XDMoodPicker.m
//  XDPlans
//
//  Created by xieyajie on 13-9-9.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDMoodPicker.h"

@implementation XDMoodPicker

@synthesize moodDelegate = _moodDelegate;
@synthesize moodView = _moodView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.superview addSubview:self.moodView];
}

- (UIView *)moodView
{
    if (_moodView == nil) {
        _moodView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        NSInteger rowCount = 5;
        CGFloat margin = 10;
        CGFloat itemWidth = (self.frame.size.width - (rowCount + 1) * margin) / rowCount;
        
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < rowCount; j++) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin + (itemWidth + margin) * j, (itemWidth + margin) * i, itemWidth, itemWidth)];
                NSString *imgName = [NSString stringWithFormat:@"MY_ICON_%i.png", (i * rowCount) + j];
                [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(moodAction:) forControlEvents:UIControlEventTouchUpInside];
                button.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeCenter;
                [_moodView addSubview:button];
            }
        }
    }
    
    return _moodView;
}

- (void)moodAction:(id)sender
{
    if (_moodDelegate && [_moodDelegate respondsToSelector:@selector(moodPicker:selectedImage:)]) {
        UIButton *button = (UIButton *)sender;
        UIImage *image = [button imageForState:UIControlStateNormal];
        [_moodDelegate moodPicker:self selectedImage:image];
    }
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
