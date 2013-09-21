//
//  XDMenuCell.h
//  XDPlans
//
//  Created by xieyajie on 13-9-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDMenuCell : UITableViewCell
{
    UIImage *_normalIcon;
    UIImage *_highlightedIcon;
}

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImage *normalIcon;
@property (nonatomic, strong) UIImage *highlightedIcon;

@property (nonatomic) CGSize availableSize;

@end
