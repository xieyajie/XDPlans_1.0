//
//  XDMoodPicker.h
//  XDPlans
//
//  Created by xieyajie on 13-9-9.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDMoodPickerDelegate;
@interface XDMoodPicker : UIActionSheet

@property (nonatomic, unsafe_unretained) id<XDMoodPickerDelegate> moodDelegate;
@property (nonatomic, strong) UIView *moodView;

@end

@protocol XDMoodPickerDelegate <NSObject>

@optional
- (void)moodPicker:(XDMoodPicker *)moodPicker selectedImage:(UIImage *)image;

@end
