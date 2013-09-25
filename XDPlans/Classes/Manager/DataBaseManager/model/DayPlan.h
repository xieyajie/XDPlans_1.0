//
//  DayPlan.h
//  XDPlans
//
//  Created by xie yajie on 13-9-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WantPlan;

@interface DayPlan : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * dpId;
@property (nonatomic, retain) NSString * finishColor;
@property (nonatomic, retain) NSNumber * finishConfidence;
@property (nonatomic, retain) NSString * moodImage;
@property (nonatomic, retain) NSString * moodText;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * workColor;
@property (nonatomic, retain) NSNumber * workLoad;
@property (nonatomic, retain) NSNumber * wpId;
@property (nonatomic, retain) WantPlan *inWantPlans;

@end
