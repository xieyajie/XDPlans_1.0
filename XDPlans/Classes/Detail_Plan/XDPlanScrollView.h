//
//  XDPlanScrollView.h
//  XDPlans
//
//  Created by xieyajie on 13-9-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDSummaryView;
@interface XDPlanScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    UILabel *_doneLabel;
    UILabel *_summaryLabel;
    UIView *_evaluationView;
    
    UIButton *_moodImage;
    UIImageView *_workImage;
    UILabel *_workLabel;
    UIImageView *_finishImage;
    UILabel *_finishLabel;
    XDSummaryView *_summaryView;
}

- (void)configurationViewWithPlan:(id)info;

@end
