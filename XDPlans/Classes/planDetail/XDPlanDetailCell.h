//
//  XDPlanDetailCell.h
//  XDPlans
//
//  Created by xieyajie on 13-9-15.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPlanDetailCell : UITableViewCell<UIScrollViewDelegate>
{
    UILabel *_dayLabel;
    UIView *_detailView;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

@property (nonatomic, strong) NSString *dayStr;

@end
