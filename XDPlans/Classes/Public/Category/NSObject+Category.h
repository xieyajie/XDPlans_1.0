//
//  NSObject+TIXACategory.h
//  XDUI
//
//  Created by xieyajie on 13-10-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)

//判定SEL是否可执行，去除ARC警告
- (void)performSafeSelector:(SEL)aSelector;
- (void)performSafeSelector:(SEL)aSelector withObject:(id)object;
- (void)performSafeSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;

@end
