//
//  NSString+Category.h
//  XDUI
//
//  Created by xieyajie on 13-10-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSMutableArray (Category)

///按数组元素的指定关键字(属性)进行升序排序
- (void)sortWithKey:(NSString *)key;
///按数组元素的指定关键字(属性)和顺序进行排序
- (void)sortWithKey:(NSString *)key ascending:(BOOL)ascending;
///按数组元素的指定关键字(属性)、顺序和比较器进行排序
- (void)sortWithKey:(NSString *)key ascending:(BOOL)ascending selector:(SEL)selector;

///截取从index开始的count个元素的非空数组
- (NSMutableArray *)subarrayFromIndex:(NSUInteger)index count:(NSUInteger)count;

@end
