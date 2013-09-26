//
//  XDPlanDetailCell.h
//  XDPlans
//
//  Created by xieyajie on 13-9-15.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDPlanScrollView;
@interface XDPlanDetailCell : UITableViewCell
{
    UILabel *_dayLabel;
    UILabel *_yearMonthLabel;
    UIView *_lineNext;
}

@property (nonatomic, strong) XDPlanScrollView *scrollView;
@property (nonatomic, strong) NSString *yearMonthStr;
@property (nonatomic, strong) NSString *dayStr;

- (void)hideLine;
- (void)showLine;

@end
