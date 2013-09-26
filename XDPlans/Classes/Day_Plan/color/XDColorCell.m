//
//  XDColorCell.m
//  XDPlans
//
//  Created by xieyajie on 13-9-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDColorCell.h"

#import "XDPlanLocalDefault.h"

@implementation XDColorCell

@synthesize name = _name;
@synthesize remark = _remark;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 40)];
        _nameLabel.textAlignment = KTextAlignmentCenter;
        _nameLabel.font = [UIFont boldSystemFontOfSize:35.0];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 5, self.frame.size.width, 20)];
        _remarkLabel.textAlignment = KTextAlignmentCenter;
        _remarkLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _remarkLabel.textColor = [UIColor whiteColor];
        _remarkLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_remarkLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)str
{
    _name = str;
    _nameLabel.text = str;
}

- (void)setRemark:(NSString *)str
{
    _remark = str;
    _remarkLabel.text = str;
}

@end
