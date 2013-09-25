//
//  XDPlanScrollView.m
//  XDPlans
//
//  Created by xieyajie on 13-9-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDPlanScrollView.h"

@implementation XDPlanScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
//        _scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = 3;
        _pageControl.backgroundColor = [UIColor blackColor];
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
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

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _scrollView.frame = CGRectMake(0, 0, frame.size.width, 80);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
    _pageControl.frame = CGRectMake(frame.size.width - 100, _scrollView.frame.origin.y + _scrollView.frame.size.height + 5, 90, 15);
}

#pragma mark - UIScrollDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    int page = _scrollView.contentOffset.x / _scrollView.frame.size.width;//通过滚动的偏移量来判断目前页面所对应的小白点
    _pageControl.currentPage = page;//pagecontroll响应值的变化
}

#pragma mark - public

- (void)configurationViewWithPlan:(id)info
{
    
}

@end
