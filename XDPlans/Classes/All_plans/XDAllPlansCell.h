//
//  XDAllPlansCell.h
//  XDPlans
//
//  Created by xieyajie on 13-9-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RichTextEditor;
@interface XDAllPlansCell : UITableViewCell
{
    UILabel *_indexLabel;
    UITextView *_contentTextView;
    UIButton *_actionButton;
}

@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString *content;
@property (nonatomic) BOOL action;

@end
