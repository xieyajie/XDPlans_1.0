//
//  XDActionPlanCell.m
//  XDPlans
//
//  Created by xieyajie on 13-9-15.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDActionPlanCell.h"

#import "XDPlanLocalDefault.h"

@implementation XDActionPlanCell

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
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    _dayLabel.layer.borderWidth = 3.0f;
    _dayLabel.layer.cornerRadius = 20 / 2;
    _dayLabel.layer.masksToBounds = YES;
    _dayLabel.textAlignment = KTextAlignmentCenter;
    _dayLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [self.contentView addSubview:_dayLabel];
}

#pragma mark - set

- (void)setDayStr:(NSString *)day
{
    _dayStr = day;
    _dayLabel.text = day;
}

@end
