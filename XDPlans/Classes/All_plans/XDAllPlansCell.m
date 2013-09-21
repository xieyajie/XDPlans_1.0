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

@implementation XDAllPlansCell

@synthesize index;
@synthesize content;
@synthesize action;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        _indexLabel.layer.borderWidth = 3.0f;
        _indexLabel.layer.cornerRadius = 20 / 2;
        _indexLabel.layer.masksToBounds = YES;
        _indexLabel.textAlignment = KTextAlignmentCenter;
        _indexLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:_indexLabel];
        
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(_indexLabel.frame.origin.x + _indexLabel.frame.size.width + 10, 10, 320 - 90, 40)];
        _contentTextView.scrollEnabled = NO;
        _contentTextView.userInteractionEnabled = NO;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.textColor = [UIColor blackColor];
        _contentTextView.font = [UIFont systemFontOfSize:17.0];
        [self.contentView addSubview:_contentTextView];
        
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.frame = CGRectMake(_contentTextView.frame.origin.x + _contentTextView.frame.size.width + 10, 10, 20, _contentTextView.frame.size.height);
        _actionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_actionButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - set

- (void)setIndex:(NSInteger)aIndex
{
    _indexLabel.text = [NSString stringWithFormat:@"%i",aIndex];
}

- (void)setContent:(NSString *)aContent
{
    _contentTextView.text = aContent;
    CGSize size = [aContent sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake((320 - 110), 600) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height > 40 ? size.height : 40;
    
    _indexLabel.frame = CGRectMake(10, 10 + (height - 30) / 2, 30, 30);
    _contentTextView.frame = CGRectMake(_indexLabel.frame.origin.x + _indexLabel.frame.size.width + 10, 10, 320 - 90, height);
    _actionButton.frame = CGRectMake(_contentTextView.frame.origin.x + _contentTextView.frame.size.width + 10, 10, 20, height);
}

- (void)setAction:(BOOL)aAction
{
    if (aAction) {
        _indexLabel.layer.borderColor = [[UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0] CGColor];
        _indexLabel.backgroundColor = [UIColor whiteColor];
        _indexLabel.textColor = [UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0];
        
        [_actionButton setImage:[UIImage imageNamed:@"plans_action.png"] forState:UIControlStateNormal];
        [_actionButton setTintColor:[UIColor redColor]];
    }
    else{
        _indexLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
        _indexLabel.backgroundColor = [UIColor colorWithRed:115 / 255.0 green:166 / 255.0 blue:184 / 255.0 alpha:1.0];
        _indexLabel.textColor = [UIColor whiteColor];
        
        [_actionButton setImage:[UIImage imageNamed:@"plans_unaction.png"] forState:UIControlStateNormal];
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
