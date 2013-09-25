//
//  XDPlanDetailCell.m
//  XDPlans
//
//  Created by xieyajie on 13-9-15.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDPlanDetailCell.h"

#import "XDPlanScrollView.h"
#import "XDPlanLocalDefault.h"

@implementation XDPlanDetailCell

@synthesize dayStr = _dayStr;
@synthesize yearMonthStr = _yearMonthStr;
@synthesize scrollView = _scrollView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initSubviews];
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initSubviews
{
    _yearMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 55, 20)];
    _yearMonthLabel.textAlignment = KTextAlignmentCenter;
    _yearMonthLabel.textColor = [UIColor grayColor];
    _yearMonthLabel.backgroundColor = [UIColor clearColor];
    _yearMonthLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:_yearMonthLabel];
    
    
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 30, 30)];
    _dayLabel.layer.borderWidth = 3.0f;
    _dayLabel.layer.cornerRadius = 20 / 2;
    _dayLabel.layer.masksToBounds = YES;
    _dayLabel.textAlignment = KTextAlignmentCenter;
    _dayLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [self.contentView addSubview:_dayLabel];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(_dayLabel.frame.origin.x + (_dayLabel.frame.size.width / 2 - 2), _dayLabel.frame.origin.y + _dayLabel.frame.size.height + 2, 4, 120 - (_dayLabel.frame.origin.y + _dayLabel.frame.size.height + 2))];
    lineView1.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(_dayLabel.frame.origin.x + _dayLabel.frame.size.width + 1, _dayLabel.frame.origin.y + (_dayLabel.frame.size.width / 2 - 2), 13, 4)];
    lineView2.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:lineView2];
}

#pragma mark - set

- (void)setDayStr:(NSString *)day
{
    _dayStr = day;
    _dayLabel.text = day;
}

- (void)setYearMonthStr:(NSString *)str
{
    _yearMonthStr = str;
    _yearMonthLabel.text = str;
}

- (void)setScrollView:(XDPlanScrollView *)view
{
    [_scrollView removeFromSuperview];
    _scrollView = view;
    _scrollView.frame = CGRectMake(_dayLabel.frame.origin.x + _dayLabel.frame.size.width + 15, 10, self.frame.size.width - (_dayLabel.frame.origin.x + _dayLabel.frame.size.width + 25), 100);
//    _scrollView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_scrollView];
}

@end
