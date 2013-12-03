//
//  NSDate+Category.m
//  XDUI
//
//  Created by xieyajie on 13-10-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

- (NSString *)timeIntervalDescription;//距离当前的时间间隔描述
- (NSString *)minuteDescription;/*精确到分钟的日期描述*/
- (NSString *)formattedDateDescription;//格式化日期描述

@end
