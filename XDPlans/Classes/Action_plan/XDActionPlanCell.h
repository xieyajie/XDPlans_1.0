//
//  XDActionPlanCell.h
//  XDPlans
//
//  Created by xieyajie on 13-9-15.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDActionPlanCell : UITableViewCell
{
    UILabel *_dayLabel;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

@property (nonatomic, strong) NSString *dayStr;

@end
