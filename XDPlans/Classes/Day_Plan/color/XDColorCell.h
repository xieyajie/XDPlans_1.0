//
//  XDColorCell.h
//  XDPlans
//
//  Created by xieyajie on 13-9-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDColorCell : UITableViewCell
{
    UILabel *_nameLabel;
    UILabel *_remarkLabel;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *remark;

@end
