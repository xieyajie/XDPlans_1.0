//
//  XDManagerHelper.h
//  XDPlans
//
//  Created by xieyajie on 13-9-4.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WantPlan;
@interface XDManagerHelper : NSObject

@property (nonatomic, strong) WantPlan *actionPlan;

+ (id)shareHelper;

//正则表达式 验证格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isEmail:(NSString *)email;

//转换tag值
+ (NSInteger)tagCompileWithInteger:(NSInteger)integer;
+ (NSInteger)tagDecompileWithInteger:(NSInteger)integer;

//图片混合
+ (UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor;

//时间转换
- (NSInteger)dayForDate:(NSDate *)date;
- (NSString *)weekForDate:(NSDate *)date;
- (NSInteger)monthForDate:(NSDate *)date;
- (NSInteger)yearForDate:(NSDate *)date;
- (NSString *)year_monthForDate:(NSDate *)date;
- (NSString *)ymdForDate:(NSDate *)date;

//显示菜单
- (void)showMenuToViewController:(UIViewController *)viewController completion: (void (^)(NSDate *))completion;

//显示datePicker
- (void)showDatePickerToViewController:(UIViewController *)viewController completion: (void (^)(NSDate *))completion;

@end
