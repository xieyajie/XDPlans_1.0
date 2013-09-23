//
//  XDTodayPlanCell.m
//  XDPlans
//
//  Created by xieyajie on 13-9-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDDataPlanCell.h"

#import "XDManagerHelper.h"
#import "XDPlanLocalDefault.h"

@implementation XDSummaryView

@synthesize delegate = _delegate;

@synthesize faceButton = _faceButton;
@synthesize faceTitleLabel = _faceTitleLabel;

@synthesize index = _index;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _faceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20)];
        _faceButton.contentMode = UIViewContentModeScaleAspectFit;
        _faceButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_faceButton addTarget:self action:@selector(faceAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_faceButton];
        
        _faceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _faceButton.frame.origin.y + _faceButton.frame.size.height, self.frame.size.width, 20.0)];
        _faceTitleLabel.backgroundColor = [UIColor clearColor];
        _faceTitleLabel.textAlignment = KTextAlignmentCenter;
        _faceTitleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_faceTitleLabel];
        
        self.layer.borderColor = [[UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0] CGColor];
    }
    
    return self;
}

- (void)faceAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(summaryView:didSelectedAtIndex:)]) {
        [_delegate summaryView:self didSelectedAtIndex:_index];
    }
    else{
        self.layer.borderColor = [[UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0] CGColor];
        self.layer.borderWidth = 2.0;
        
        self.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    }
}

@end

@interface XDDataPlanCell()<XDSummaryViewDelegate>
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

@implementation XDDataPlanCell

@synthesize delegate = _delegate;

@synthesize moodField = _moodField;
@synthesize textEditor = _textEditor;

//public
@synthesize moodButton = _moodButton;
@synthesize textField = _textField;
@synthesize textView = _textView;

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

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - set

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
    NSArray *titles = [NSArray arrayWithObjects:@"太糟糕了", @"一般般", @"还不错", @"非常好", nil];
    NSInteger count = 4;
    CGFloat margin = 5.0;
    CGFloat width = (self.frame.size.width - 5 * margin) / count;
    
    for (int i = 0; i < count; i++) {
        XDSummaryView *summaryView = [[XDSummaryView alloc] initWithFrame:CGRectMake(margin + (width + margin) * i, 10, width, KTODAY_CELL_HEIGHT_NORMAL - 20)];
        summaryView.delegate = self;
        summaryView.index = i;
        NSString *imgName = [NSString stringWithFormat:@"plans_summary_%i", i];
        [summaryView.faceButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        summaryView.faceTitleLabel.text = [titles objectAtIndex:i];
        
        [self.summaryViews addObject:summaryView];
        [self.contentView addSubview:summaryView];
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
