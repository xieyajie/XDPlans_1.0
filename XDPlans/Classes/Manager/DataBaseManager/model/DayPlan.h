//
//  DayPlan.h
//  XDPlans
//
//  Created by xieyajie on 13-10-10.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WantPlan;

@interface DayPlan : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * finishColor;
@property (nonatomic, retain) NSNumber * finishConfidence;
@property (nonatomic, retain) NSString * moodImage;
@property (nonatomic, retain) NSString * moodText;
@property (nonatomic, retain) NSString * scoreKey;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * workColor;
@property (nonatomic, retain) NSNumber * workLoad;
@property (nonatomic, retain) WantPlan *inWantPlans;

@end
