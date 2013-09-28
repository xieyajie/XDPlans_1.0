//
//  WantPlan.h
//  XDPlans
//
//  Created by xie yajie on 13-9-28.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayPlan, User;

@interface WantPlan : NSManagedObject

@property (nonatomic, retain) NSNumber * action;
@property (nonatomic, retain) NSNumber * finish;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * uId;
@property (nonatomic, retain) NSNumber * wpId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSSet *dayPlans;
@property (nonatomic, retain) User *inUser;
@end

@interface WantPlan (CoreDataGeneratedAccessors)

- (void)addDayPlansObject:(DayPlan *)value;
- (void)removeDayPlansObject:(DayPlan *)value;
- (void)addDayPlans:(NSSet *)values;
- (void)removeDayPlans:(NSSet *)values;

@end
