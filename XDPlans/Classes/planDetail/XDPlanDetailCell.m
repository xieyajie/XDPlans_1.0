//
//  XDPlanDetailCell.m
//  XDPlans
//
//  Created by xieyajie on 13-9-15.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDPlanDetailCell.h"

#import "XDPlanLocalDefault.h"

@implementation XDPlanDetailCell

@synthesize dayStr = _dayStr;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initSubviews];
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
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    _dayLabel.layer.borderWidth = 3.0f;
    _dayLabel.layer.cornerRadius = 20 / 2;
    _dayLabel.layer.masksToBounds = YES;
    _dayLabel.textAlignment = KTextAlignmentCenter;
    _dayLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [self.contentView addSubview:_dayLabel];
    
//    _detailView = [[UIView alloc] initWithFrame:CGRectMake(_dayLabel.frame.origin.x + _dayLabel.frame.size.width + 15, 10, self.frame.size.width - (_dayLabel.frame.origin.x + _dayLabel.frame.size.width + 25), 80)];
//    _detailView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:_detailView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_dayLabel.frame.origin.x + _dayLabel.frame.size.width + 15, 10, self.frame.size.width - (_dayLabel.frame.origin.x + _dayLabel.frame.size.width + 25), 80)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    [self.contentView addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, _scrollView.frame.origin.y + _scrollView.frame.size.height + 5, 90, 20)];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    [self.contentView addSubview:_pageControl];
}

#pragma mark - UIScrollDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    int page = _scrollView.contentOffset.x / _scrollView.frame.size.width;//通过滚动的偏移量来判断目前页面所对应的小白点
    
    _pageControl.currentPage = page;//pagecontroll响应值的变化
}

#pragma mark - set

- (void)setDayStr:(NSString *)day
{
    _dayStr = day;
    _dayLabel.text = day;
}

@end
