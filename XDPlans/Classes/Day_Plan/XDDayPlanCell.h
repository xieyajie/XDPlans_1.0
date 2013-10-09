//
//  XDDayPlanCell.h
//  XDPlans
//
//  Created by xieyajie on 13-9-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextEditor.h"

@protocol XDTodayPlayCellDelegate;
@interface XDDayPlanCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id<XDTodayPlayCellDelegate>delegate;

@property (nonatomic, strong) UIButton *moodButton;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSString *colorKey;

//不可编辑状态下，显示的内容
@property (nonatomic, strong) UIImage *moodImage;
@property (nonatomic, strong) NSString *moodText;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) NSInteger workloadCount;

@property (nonatomic) NSInteger finishCount;

@property (nonatomic, strong) NSString *planContent;

@property (nonatomic, strong) NSString *summaryContent;

@property (nonatomic, strong) NSString *summaryKey;



//心情
- (void)configurationMood;
//工作量指数
- (void)configurationWordload;
//完成信心指数
- (void)configurationFinishFaith;
//今日安排
- (void)configurationPlan;
//今日总结
- (void)configurationSummary;
//评价表现
- (void)configurationGrand;


- (void)updateWithColor:(UIColor *)color;

@end

@protocol XDTodayPlayCellDelegate <NSObject>

@optional
- (void)planCellSelectedMoodPicker:(XDDayPlanCell *)planCell;
- (void)planCellSelectedColorPicker:(XDDayPlanCell *)planCell;

@end
