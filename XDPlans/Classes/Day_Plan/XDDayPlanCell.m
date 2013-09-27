//
//  XDDayPlanCell.m
//  XDPlans
//
//  Created by xieyajie on 13-9-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDDayPlanCell.h"

#import "XDSummaryView.h"
#import "XDManagerHelper.h"

@interface XDDayPlanCell()<XDSummaryViewDelegate>
{
    UIColor *_color;
}

@property (nonatomic, strong) UITextField *moodField;
@property (nonatomic, strong) RichTextEditor *textEditor;

//指数相关
@property (nonatomic, strong) NSMutableArray *buttons;

//评价相关
@property (nonatomic, strong) NSArray *summaryInfo;
@property (nonatomic, strong) NSMutableArray *summaryViews;
@property (nonatomic) NSInteger selectedSummaryIndex;

@end

@implementation XDDayPlanCell

@synthesize delegate = _delegate;

@synthesize moodField = _moodField;
@synthesize textEditor = _textEditor;

//public
@synthesize moodButton = _moodButton;
@synthesize textField = _textField;
@synthesize textView = _textView;

@synthesize colorKey = _colorKey;

//指数相关
@synthesize buttons = _buttons;

//评价相关
@synthesize summaryInfo = _summaryInfo;
@synthesize summaryViews = _summaryViews;
@synthesize selectedSummaryIndex = _selectedSummaryIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _colorKey = @"#000000";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setting

- (void)setColorKey:(NSString *)key
{
    _colorKey = key;
}

#pragma mark - get

- (RichTextEditor *)textEditor
{
    if (_textEditor == nil) {
        _textEditor = [[RichTextEditor alloc] init];
        _textEditor.backgroundColor = [UIColor clearColor];
    }
    
    return _textEditor;
}

- (UITextField *)textField
{
    return _moodField;
}

- (UITextView *)textView
{
    return _textEditor;
}

- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [[NSMutableArray alloc] init];
    }
    
    return _buttons;
}

#pragma mark - private

- (void)colorAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(planCellSelectedColorPicker:)]) {
        [_delegate planCellSelectedColorPicker:self];
    }
}

- (void)moodAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(planCellSelectedMoodPicker:)]) {
        [_delegate planCellSelectedMoodPicker:self];
    }
}

#pragma mark - public

- (void)updateWithColor:(UIColor *)color
{
    _color = color;
    
    UIButton *bt = [self.buttons objectAtIndex:0];
    UIImage *img = [bt imageForState:UIControlStateNormal];
    UIImage *image = [XDManagerHelper colorizeImage:img withColor:_color];
    
    for (UIButton *button in self.buttons) {
        [button setImage:image forState: UIControlStateSelected];
    }
}

#pragma mark - 心情

- (void)configurationMood
{
    _moodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moodButton.frame = CGRectMake(10, 10, 40, KTODAY_CELL_HEIGHT_NORMAL - 20);
    [_moodButton setImage:[UIImage imageNamed:@"plans_mood_image.png"] forState:UIControlStateNormal];
    _moodButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _moodButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _moodButton.backgroundColor = [UIColor clearColor];
    [_moodButton addTarget:self action:@selector(moodAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_moodButton];
    
    _moodField = [[UITextField alloc] initWithFrame:CGRectMake(_moodButton.frame.origin.x + _moodButton.frame.size.width + 10, (KTODAY_CELL_HEIGHT_NORMAL - 37) / 2, self.frame.size.width - (_moodButton.frame.origin.x + _moodButton.frame.size.width + 30), 37)];
    _moodField.borderStyle = UITextBorderStyleBezel;
    _moodField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    _moodField.placeholder = @"心情怎么样？";
    [self.contentView addSubview:_moodField];
}

#pragma mark - 工作量指数

- (void)configurationWordload
{
    NSInteger count = 5;
    CGFloat margin = 5.0;
    CGFloat width = (self.frame.size.width - 80 - 5 * margin) / count;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin + (margin + width) * i, 10, width, KTODAY_CELL_HEIGHT_NORMAL - 20)];
        button.contentMode = UIViewContentModeScaleAspectFit;
        [button setImage:[UIImage imageNamed:@"plans_workload.png"] forState: UIControlStateNormal];
        UIImage *image = [XDManagerHelper colorizeImage:[UIImage imageNamed:@"plans_workload.png"] withColor:_color];
        [button setImage:image forState: UIControlStateSelected];
        [button addTarget:self action:@selector(wordloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [self.buttons addObject:button];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, 10, 50, KTODAY_CELL_HEIGHT_NORMAL - 20)];
    button.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:[UIImage imageNamed:@"plans_paint_normal.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"plans_paint_selected.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(colorAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
}

- (void)wordloadButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    BOOL selected = button.selected;
    button.selected = !selected;
}

#pragma mark - 完成信心指数

- (void)configurationFinishFaith
{
    NSInteger count = 5;
    CGFloat margin = 5.0;
    CGFloat width = (self.frame.size.width - 80 - 5 * margin) / count;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin + (margin + width) * i, 10, width, KTODAY_CELL_HEIGHT_NORMAL - 20)];
        button.contentMode = UIViewContentModeScaleAspectFit;
        [button setImage:[UIImage imageNamed:@"plans_finish.png"] forState: UIControlStateNormal];
        UIImage *image = [XDManagerHelper colorizeImage:[UIImage imageNamed:@"plans_finish.png"] withColor:_color];
        [button setImage:image forState: UIControlStateSelected];
        [button addTarget:self action:@selector(finishButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [self.buttons addObject:button];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, 10, 50, KTODAY_CELL_HEIGHT_NORMAL - 20)];
    button.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:[UIImage imageNamed:@"plans_paint_normal.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"plans_paint_selected.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(colorAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
}

- (void)finishButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    BOOL selected = button.selected;
    button.selected = !selected;
}

#pragma mark - 今日安排

- (void)configurationPlan
{
    self.textEditor.frame = CGRectMake(10, 10, self.frame.size.width - 20, KTODAY_CELL_HEIGHT_CONTENT - 20);
    [self.contentView addSubview:self.textEditor];
}

#pragma mark - 今日总结

- (void)configurationSummary
{
    self.textEditor.frame = CGRectMake(10, 10, self.frame.size.width - 20, KTODAY_CELL_HEIGHT_CONTENT - 20);
    [self.contentView addSubview:self.textEditor];
}

#pragma mark - 评价表现

//- (NSArray *)summaryInfo
//{
//    
//}

- (NSArray *)summaryViews
{
    if (_summaryViews == nil) {
        _summaryViews = [[NSMutableArray alloc] init];
        _selectedSummaryIndex = -1;
    }
    
    return _summaryViews;
}

- (void)configurationGrand
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XDSummary" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    CGFloat margin = 5.0;
    CGFloat width = (self.frame.size.width - 5 * margin) / data.count;
    
    NSInteger count = 0;
    for (NSString *key in data) {
        NSDictionary *dic = [data objectForKey:key];
        XDSummaryView *summaryView = [[XDSummaryView alloc] initWithFrame:CGRectMake(margin + (width + margin) * count, 10, width, KTODAY_CELL_HEIGHT_NORMAL - 20)];
        summaryView.delegate = self;
        summaryView.key = key;
        summaryView.index = count;
        [summaryView.faceButton setImage:[UIImage imageNamed:[dic objectForKey:@"icon"]] forState:UIControlStateNormal];
        summaryView.faceTitleLabel.text = [dic objectForKey:@"title"];
        
        [self.summaryViews addObject:summaryView];
        [self.contentView addSubview:summaryView];
        
        count++;
    }
}

#pragma mark - XDSummaryViewDelegate

- (void)summaryView:(XDSummaryView *)summaryView didSelectedAtIndex:(NSInteger)index
{
    if (_selectedSummaryIndex != index) {
        if (_selectedSummaryIndex >= 0) {
            XDSummaryView *view = [self.summaryViews objectAtIndex:_selectedSummaryIndex];
            view.backgroundColor = [UIColor clearColor];
            view.layer.borderWidth = 0;
        }
        
        _selectedSummaryIndex = index;
        XDSummaryView *selectedView = [self.summaryViews objectAtIndex:_selectedSummaryIndex];
        selectedView.layer.borderWidth = 2.0;
        selectedView.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    }
}

@end
