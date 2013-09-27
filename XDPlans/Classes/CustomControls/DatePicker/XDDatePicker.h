//
//  XDDatePicker.h
//  XDPlans
//
//  Created by xieyajie on 13-9-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^cancel)();
typedef void (^sure)(NSDate *date);

@interface XDDatePicker : UIView
{
    UIView *_mainView;
}

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *shandowView;

@property (nonatomic, copy) cancel cancelClicked;
@property (nonatomic, copy) sure sureClicked;

- (void)selectedDate:(NSDate *)date;

- (void)showInView:(UIView *)view;

@end
