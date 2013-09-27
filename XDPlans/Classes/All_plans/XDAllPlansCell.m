//
//  XDAllPlansCell.m
//  XDPlans
//
//  Created by xieyajie on 13-9-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDAllPlansCell.h"

#import "XDCircleProgressBar.h"
#import "XDPlanLocalDefault.h"

@interface XDAllPlansCell()

@end

@implementation XDAllPlansCell

@synthesize index = _index;
@synthesize content;
@synthesize action;
//@synthesize finish;

@synthesize progressValue = _progressValue;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.backgroundColor = [UIColor clearColor];
        _actionButton.frame = CGRectMake(0, 0, 30, 40 + 10);
        _actionButton.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_actionButton];
        
        _contentTextView = [[UILabel alloc] initWithFrame:CGRectMake(_actionButton.frame.origin.x + _actionButton.frame.size.width + 10, 5, 320 - 90, 40)];
        _contentTextView.numberOfLines = 0;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.textColor = [UIColor blackColor];
        _contentTextView.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:_contentTextView];
        
        _operateView = [[UIView alloc] initWithFrame:CGRectMake(_contentTextView.frame.origin.x + _contentTextView.frame.size.width, 0, self.frame.size.width - (_contentTextView.frame.origin.x + _contentTextView.frame.size.width), 40 + 10)];
        _operateView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_operateView];
        
        _progressBar = [[XDCircleProgressBar alloc] initWithFrame:CGRectMake(5, 0, 40, _operateView.frame.size.height)];
        _progressBar.backgroundColor = [UIColor clearColor];
        [_operateView addSubview:_progressBar];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - get

#pragma mark - set

- (void)setIndex:(NSInteger)aIndex
{
    _index = aIndex;
}

- (void)setContent:(NSString *)aContent
{
    _contentTextView.text = aContent;
    CGSize size = [aContent sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake((320 - 110), 600) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height > 40 ? size.height : 40;
    
    if (height > 40) {
        _actionButton.frame = CGRectMake(0, 0, 30, height + 10);
        _contentTextView.frame = CGRectMake(_actionButton.frame.origin.x + _actionButton.frame.size.width + 10, 5, 320 - 90, height);
        _operateView.frame = CGRectMake(_contentTextView.frame.origin.x + _contentTextView.frame.size.width, 0, self.frame.size.width - (_contentTextView.frame.origin.x + _contentTextView.frame.size.width), height + 10);
        
        _progressBar.frame = CGRectMake(5, 0, 40, _operateView.frame.size.height);
    }
}

- (void)setAction:(BOOL)aAction
{
    if (aAction) {
        [_actionButton setImage:[UIImage imageNamed:@"plans_action.png"] forState:UIControlStateNormal];
        [_actionButton setTintColor:[UIColor redColor]];
    }
    else{
        [_actionButton setImage:[UIImage imageNamed:@"plans_unaction.png"] forState:UIControlStateNormal];
    }
}

//- (void)setFinish:(BOOL)aFinish
//{
//    if (aFinish) {
//        self.contentView.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0];
//    }
//    else{
//        self.contentView.backgroundColor = [UIColor whiteColor];
//    }
//}

- (void)setProgressValue:(CGFloat)value
{
    _progressValue = value;
    
    NSString *str = [NSString stringWithFormat:@"%.0f", value * 100];
    [_progressBar setPercent:[str integerValue] animated:NO];
}

#pragma mark - setFrame

- (void)setSubviewsFrameNormal
{
    
}

- (void)setSubviewsFrameEdit
{
    
}

@end
