//
//  XDMenuCell.m
//  XDPlans
//
//  Created by xieyajie on 13-9-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDMenuCell.h"

#import "XDPlanLocalDefault.h"

#define KCELL_ICON_WIDTH 30.0
#define KCELL_ICON_HEIGHT 30.0
#define KCELL_TITLE_HEIGHT 20.0

@implementation XDMenuCell

@synthesize iconView = _iconView;
@synthesize titleLabel = _titleLabel;

@synthesize normalIcon = _normalIcon;
@synthesize highlightedIcon = _highlightedIcon;

@synthesize availableSize = _availableSize;

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
    if (selected) {
        _iconView.image = _highlightedIcon;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _titleLabel.textColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
        self.contentView.backgroundColor = [UIColor colorWithRed:74 / 255.0 green:78 / 255.0 blue:85 / 255.0 alpha:1.0];
    }
    else{
        _iconView.image = _normalIcon;
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.textColor = [UIColor colorWithRed:139 / 255.0 green:142 / 255.0 blue:147 / 255.0 alpha:1.0];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark- private

- (void)initSubviews
{
    _availableSize = CGSizeMake(320 * KSIDESLIP_PERCENT, KSIDESLIP_CELL_HEIGHT);
    
    _iconView =[[UIImageView alloc] initWithFrame:CGRectMake(15, (_availableSize.height - KCELL_ICON_HEIGHT) / 2, KCELL_ICON_WIDTH, KCELL_ICON_HEIGHT)];
    _iconView.contentMode = UIViewContentModeCenter | UIViewContentModeScaleToFill;
    [self.contentView addSubview:_iconView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25 + KCELL_ICON_WIDTH, 0, _availableSize.width - (40 + KCELL_ICON_WIDTH), _availableSize.height)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleLabel];
}

#pragma mark - set

- (void)setAvailableSize:(CGSize)size
{
    if (_availableSize.width != size.width || _availableSize.height != size.height) {
        _availableSize = size;
        [UIView animateWithDuration:.5f animations:^{
            _iconView.frame = CGRectMake(10, 0, KCELL_ICON_WIDTH, _availableSize.height);
            _titleLabel.frame = CGRectMake(0, _iconView.frame.origin.y + KCELL_ICON_HEIGHT, _availableSize.width, KCELL_TITLE_HEIGHT);
        }];
    }
}


@end
