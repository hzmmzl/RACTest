//
//  NSArray+Safe.h
//  TestModuleStock
//
//  Created by mzl on 2020/2/7.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Safe)

/**
 二维数组获取元素

 @param indexPath indexPath
 @return 元素
 */
- (nullable id)gj_objectAtIndexPath:(NSIndexPath *)indexPath;

/**
 返回指定位置元素

 @param index index
 @return 元素
 */
- (nullable id)gj_safeObjectAtIndex:(NSUInteger)index;


/**
 返回数组中指定范围的数组

 @param range 范围
 @return 数组
 */
- (NSArray *)gj_subArrayWithRange:(NSRange)range;

@end

@interface NSMutableArray (Safe)

/**
 安全删除数组中指定位置元素

 @param index 位置
 */
- (void)gj_safeRemoveObjectAtIndex:(NSUInteger)index;

/**
 删除首个元素
 */
- (void)gj_removeFirstObject;

/**
 删除最后一个元素
 */
- (void)gj_removeLastObject;

/**
 添加元素

 @param object obj
 */
- (void)gj_safeAddObject:(id)object;

@end

NS_ASSUME_NONNULL_END
