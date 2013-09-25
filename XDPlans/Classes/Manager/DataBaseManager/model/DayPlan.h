//
//  DayPlan.h
//  XDPlans
//
//  Created by xieyajie on 13-9-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DayPlan : NSManagedObject

@property (nonatomic) int64_t dpId;
@property (nonatomic) int64_t wpId;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * moodImage;
@property (nonatomic, retain) NSString * moodText;
@property (nonatomic, retain) NSString * workColor;
@property (nonatomic) int16_t workLoad;
@property (nonatomic) int16_t finishConfidence;
@property (nonatomic, retain) NSString * finishColor;
@property (nonatomic) NSTimeInterval date;
@property (nonatomic) int16_t score;
@property (nonatomic, retain) NSManagedObject *wanPlan;

@end
