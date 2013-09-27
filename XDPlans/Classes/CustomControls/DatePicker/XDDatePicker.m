//
//  XDDatePicker.m
//  XDPlans
//
//  Created by xieyajie on 13-9-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDDatePicker.h"

@implementation XDDatePicker

@synthesize cancelClicked = _cancelClicked;
@synthesize sureClicked = _sureClicked;

@synthesize toolBar = _toolBar;
@synthesize datePicker = _datePicker;
@synthesize shandowView = _shandowView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _mainView = [[UIView alloc] init];
        [self addSubview:self.shandowView];
        [self addSubview:_mainView];
        [_mainView addSubview:self.toolBar];
        [_mainView addSubview:self.datePicker];
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

#pragma mark - get

-(UIToolbar *)toolBar
{
    if (_toolBar == nil)
    {
        _toolBar = [[UIToolbar alloc] init];//WithFrame: CGRectMake(0, 0, self.frame.size.width, 44)];
        [_toolBar setTintColor:[UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0]];
        
        UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"选择结束时间" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle: @"取消" style: UIBarButtonItemStyleBordered target:self action: @selector(cancelButtonClicked)];
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle: @"确定" style: UIBarButtonItemStyleDone target:self action: @selector(sureButtonClicked)];
        
        UIBarButtonItem *fexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray *items = [[NSArray alloc] initWithObjects: cancelItem, fexibleSpace, titleItem, fexibleSpace, doneItem, nil];
        [_toolBar setItems: items animated: YES];
    }
    return _toolBar;
}

-(UIDatePicker *)datePicker
{
    if (_datePicker == nil)
    {
        _datePicker=[[UIDatePicker alloc] init];
        _datePicker.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
        _datePicker.date = [NSDate date];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.minimumDate = [NSDate date];
        
    }
    return _datePicker;
}

- (UIView *)shandowView
{
    if (_shandowView == nil) {
        _shandowView = [[UIView alloc] init];
        _shandowView.backgroundColor = [UIColor blackColor];
        _shandowView.alpha = 0.0;
    }
    
    return _shandowView;
}

#pragma mark - private

-(void)cancelButtonClicked
{
    self.cancelClicked();
    
    [UIView animateWithDuration:.3f animations:^{
        _mainView.frame = CGRectMake(0, self.shandowView.frame.size.height, self.shandowView.frame.size.width, 204);
        _shandowView.alpha = 0.0;
    }completion:^(BOOL finish){
        [self removeFromSuperview];
        _shandowView.alpha = 0.5;
    }];
}
-(void)sureButtonClicked
{
    self.sureClicked(self.datePicker.date);
    
    [UIView animateWithDuration:.3f animations:^{
        _mainView.frame = CGRectMake(0, self.shandowView.frame.size.height, self.shandowView.frame.size.width, 204);
        _shandowView.alpha = 0.0;
    }completion:^(BOOL finish){
        [self removeFromSuperview];
        _shandowView.alpha = 0.5;
    }];
}

#pragma mark - public

- (void)selectedDate:(NSDate *)date
{
    if (date == nil) {
        _datePicker.date = [NSDate date];
    }
    else{
        _datePicker.date = date;
    }
}

- (void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    self.shandowView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    self.datePicker.frame = CGRectMake(0, 44, view.frame.size.width, 160);
    self.toolBar.frame = CGRectMake(0, 0, view.frame.size.width, 44);
    _shandowView.alpha = 0.0;
    
    _mainView.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, 204);
    [view addSubview:self];
    
    [UIView animateWithDuration:.3f animations:^{
        _shandowView.alpha = 0.5;
        _mainView.frame = CGRectMake(0, view.frame.size.height - 204, view.frame.size.width, 204);
    }];
}

@end
