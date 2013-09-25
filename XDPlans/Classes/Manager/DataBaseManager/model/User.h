//
//  User.h
//  XDPlans
//
//  Created by xieyajie on 13-9-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WantPlan;

@interface User : NSManagedObject

@property (nonatomic) int64_t uId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userEmail;
@property (nonatomic, retain) NSString * password;
@property (nonatomic) NSTimeInterval dayBegin;
@property (nonatomic) NSTimeInterval dayEnd;
@property (nonatomic, retain) NSOrderedSet *wantPlans;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)insertObject:(WantPlan *)value inWantPlansAtIndex:(NSUInteger)idx;
- (void)removeObjectFromWantPlansAtIndex:(NSUInteger)idx;
- (void)insertWantPlans:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeWantPlansAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInWantPlansAtIndex:(NSUInteger)idx withObject:(WantPlan *)value;
- (void)replaceWantPlansAtIndexes:(NSIndexSet *)indexes withWantPlans:(NSArray *)values;
- (void)addWantPlansObject:(WantPlan *)value;
- (void)removeWantPlansObject:(WantPlan *)value;
- (void)addWantPlans:(NSOrderedSet *)values;
- (void)removeWantPlans:(NSOrderedSet *)values;
@end
