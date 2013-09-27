//
//  XDAllPlansCell.h
//  XDPlans
//
//  Created by xieyajie on 13-9-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDAllPlansCellDelegate;

@class RichTextEditor;
@class XDCircleProgressBar;
@interface XDAllPlansCell : UITableViewCell
{
    UILabel *_contentTextView;
    UIButton *_actionButton;
    UIView *_operateView;
    
    XDCircleProgressBar *_progressBar;
    UIButton *_deleteButton;
    UIButton *_editButton;
}

@property (nonatomic, unsafe_unretained) id<XDAllPlansCellDelegate> delegate;

@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString *content;
@property (nonatomic) BOOL action;
//@property (nonatomic) BOOL finish;

@property (nonatomic) CGFloat progressValue;

- (void)showDapAnimation;

@end

@protocol XDAllPlansCellDelegate <NSObject>

@optional
- (void)plansCellFinishAction:(XDAllPlansCell *)cell;
- (void)plansCellDeleteAction:(XDAllPlansCell *)cell;
- (void)plansCellEditAction:(XDAllPlansCell *)cell;

@end
