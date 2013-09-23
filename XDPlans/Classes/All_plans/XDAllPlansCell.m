//
//  XDAllPlansCell.m
//  XDPlans
//
//  Created by xieyajie on 13-9-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDAllPlansCell.h"

#import "XDPlanLocalDefault.h"

@interface XDAllPlansCell()

@property (nonatomic) UIView *progressView;

@end

@implementation XDAllPlansCell

@synthesize progressView = _progressView;

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
        
//        _mainView = [[UIView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 5)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:view];
        
        self.progressView.frame = CGRectMake(0, 0, 0, 5);
        [self.contentView addSubview:self.progressView];
        
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _actionButton.backgroundColor = [UIColor redColor];
        _actionButton.frame = CGRectMake(0, 10, 40, 40);
        _actionButton.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_actionButton];
        
        _contentTextView = [[UILabel alloc] initWithFrame:CGRectMake(_actionButton.frame.origin.x + _actionButton.frame.size.width + 10, 10, 320 - 90, 40)];
        _contentTextView.numberOfLines = 0;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.textColor = [UIColor blackColor];
        _contentTextView.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:_contentTextView];
        
        _progressValue = 0.0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - get

- (UIView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:103 / 255.0 blue:90 / 255.0 alpha:1.0];
    }
    
    return _progressView;
}

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
    
    _actionButton.frame = CGRectMake(0, 10, 40, height);
    _contentTextView.frame = CGRectMake(_actionButton.frame.origin.x + _actionButton.frame.size.width + 10, 10, 320 - 90, height);
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
    
    if (_progressValue > 0) {
        self.progressView.frame = CGRectMake(0, 0, self.frame.size.width * _progressValue, 5);
    }
    else{
        self.progressView.frame = CGRectMake(0, 0, 0, 5);
    }
}

#pragma mark - setFrame

- (void)setSubviewsFrameNormal
{
    
}

- (void)setSubviewsFrameEdit
{
    
}

@end
