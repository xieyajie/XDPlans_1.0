//
//  WantPlan.h
//  XDPlans
//
//  Created by xieyajie on 13-9-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayPlan;

@interface WantPlan : NSManagedObject

@property (nonatomic) int64_t wpId;
@property (nonatomic) int64_t uId;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) NSTimeInterval finishDate;
@property (nonatomic) BOOL action;
@property (nonatomic) BOOL finish;
@property (nonatomic, retain) NSManagedObject *user;
@property (nonatomic, retain) NSOrderedSet *day;
@end

@interface WantPlan (CoreDataGeneratedAccessors)

- (void)insertObject:(DayPlan *)value inDayAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDayAtIndex:(NSUInteger)idx;
- (void)insertDay:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDayAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDayAtIndex:(NSUInteger)idx withObject:(DayPlan *)value;
- (void)replaceDayAtIndexes:(NSIndexSet *)indexes withDay:(NSArray *)values;
- (void)addDayObject:(DayPlan *)value;
- (void)removeDayObject:(DayPlan *)value;
- (void)addDay:(NSOrderedSet *)values;
- (void)removeDay:(NSOrderedSet *)values;
@end
