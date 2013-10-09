//
//  XDPlanScrollView.m
//  XDPlans
//
//  Created by xieyajie on 13-9-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDPlanScrollView.h"

#import "XDSummaryView.h"

@implementation XDPlanScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        self.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowColor = [[UIColor colorWithRed:211 / 255.0 green:209 / 255.0 blue:202 / 255.0 alpha:1.0] CGColor];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.clipsToBounds = YES;
        _scrollView.layer.cornerRadius = 5;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
//        _scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = 3;
//        _pageControl.backgroundColor = [UIColor blackColor];
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
        
        _doneLabel = [[UILabel alloc] init];
        _doneLabel.numberOfLines = 0;
        _doneLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _doneLabel.backgroundColor = [UIColor clearColor];
//        _doneLabel.layer.borderColor = [[UIColor redColor] CGColor];
//        _doneLabel.layer.borderWidth = 2.0;
        [_scrollView addSubview:_doneLabel];
        
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.numberOfLines = 0;
        _summaryLabel.contentMode = UIViewContentModeTop;
        _summaryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _summaryLabel.backgroundColor = [UIColor clearColor];
//        _summaryLabel.layer.borderColor = [[UIColor yellowColor] CGColor];
//        _summaryLabel.layer.borderWidth = 2.0;
        [_scrollView addSubview:_summaryLabel];
        
        _evaluationView = [[UIView alloc] init];
        _evaluationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _evaluationView.backgroundColor = [UIColor clearColor];
        _evaluationView.layer.borderColor = [[UIColor blueColor] CGColor];
        _evaluationView.layer.borderWidth = 2.0;
        [_scrollView addSubview:_evaluationView];
        
        _moodImage = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
        _moodImage.enabled = NO;
        _moodImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _moodImage.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        _moodImage.backgroundColor = [UIColor blueColor];
        [_evaluationView addSubview:_moodImage];

        _workImage = [[UIImageView alloc] init];
//        _workImage.backgroundColor = [UIColor darkTextColor];
        _workImage.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeCenter;
        [_workImage setImage:[UIImage imageNamed:@"plans_workload.png"]];
        [_evaluationView addSubview:_workImage];
        
        _workLabel = [[UILabel alloc] init];
        _workLabel.font = [UIFont boldSystemFontOfSize:25];
        _workLabel.backgroundColor = [UIColor clearColor];
        [_evaluationView addSubview:_workLabel];
        
        _finishImage = [[UIImageView alloc] init];
//        _finishImage.backgroundColor = [UIColor orangeColor];
        _finishImage.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeCenter;
        [_finishImage setImage:[UIImage imageNamed:@"plans_finish.png"]];
        [_evaluationView addSubview:_finishImage];
        
        _finishLabel = [[UILabel alloc] init];
        _finishLabel.font = [UIFont boldSystemFontOfSize:25];
        _finishLabel.backgroundColor = [UIColor clearColor];
        [_evaluationView addSubview:_finishLabel];
        
        _summaryView = [[XDSummaryView alloc] init];
        _summaryView.userInteractionEnabled = NO;
        _summaryView.backgroundColor = [UIColor clearColor];
        [_evaluationView addSubview:_summaryView];
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
    
    CGFloat oldWidth = _scrollView.frame.size.width;
    _scrollView.frame = CGRectMake(0, 0, frame.size.width, 80);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
    _pageControl.frame = CGRectMake(frame.size.width - 100, _scrollView.frame.origin.y + _scrollView.frame.size.height + 5, 90, 15);
    
    if (frame.size.width != oldWidth) {
        _doneLabel.frame = CGRectMake(10, 0, _scrollView.frame.size.width - 20, _scrollView.frame.size.height);
        _summaryLabel.frame = CGRectMake(_scrollView.frame.size.width + 10, 0, _scrollView.frame.size.width - 20, _scrollView.frame.size.height);
        _evaluationView.frame = CGRectMake(_scrollView.frame.size.width * 2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        
        CGFloat evaluationWidth = _evaluationView.frame.size.width / 3;
        CGFloat moodWidth = evaluationWidth > 50 ? 50 : evaluationWidth;
        _moodImage.frame = CGRectMake((evaluationWidth - moodWidth) / 2, 0, moodWidth, _evaluationView.frame.size.height);
        _workImage.frame = CGRectMake(evaluationWidth, 10, evaluationWidth / 2, _evaluationView.frame.size.height / 2 - 10);
        _workLabel.frame = CGRectMake(evaluationWidth + evaluationWidth / 2, 0, evaluationWidth / 2, _evaluationView.frame.size.height / 2);
        _finishImage.frame = CGRectMake(evaluationWidth, _evaluationView.frame.size.height / 2 + 10 , evaluationWidth / 2, _evaluationView.frame.size.height / 2 - 10);
        _finishLabel.frame = CGRectMake(evaluationWidth + evaluationWidth / 2, _evaluationView.frame.size.height / 2 , evaluationWidth / 2, _evaluationView.frame.size.height / 2);
        _summaryView.frame = CGRectMake(evaluationWidth * 2, 0, evaluationWidth, _evaluationView.frame.size.height);
    }
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
    _doneLabel.text = @"完成： 确定写些什么";
    _summaryLabel.text = @"总结：完成的不错";
    
    [_moodImage setImage:[UIImage imageNamed:@"MY_ICON_0.png"] forState:UIControlStateNormal];
    
    _workLabel.text = @"3";
    _finishLabel.text = @"4";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XDSummary" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *dic = [data objectForKey:@"ok"];
    _summaryView.key = @"ok";
    [_summaryView.faceButton setImage:[UIImage imageNamed:[dic objectForKey:@"icon"]] forState:UIControlStateNormal];
    _summaryView.faceTitleLabel.text = [dic objectForKey:@"title"];
}

@end
