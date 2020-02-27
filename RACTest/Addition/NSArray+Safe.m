//
//  NSArray+Safe.m
//  TestModuleStock
//
//  Created by mzl on 2020/2/7.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "NSArray+Safe.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation NSArray (Safe)
- (id)gj_objectAtIndexPath:(NSIndexPath *)indexPath {
    if (self.count > indexPath.section) {
        NSArray *subArray = self[indexPath.section];
        if ([subArray isKindOfClass:[NSArray class]]) {
            if (subArray.count > indexPath.row) {
                return subArray[indexPath.row];
            }
        }
    }
    return nil;
}

- (id)gj_safeObjectAtIndex:(NSUInteger)index {
    if (self.count <= index) {
        //        NSLog(@"<<< 警告：数组越界 >>>");
        return nil;
    }
    return [self objectAtIndex:index];
}

- (NSArray *)gj_subArrayWithRange:(NSRange)range {
    if (self.count == 0 || range.length == 0 || range.location >= self.count) {
        return @[];
    }
    
    NSUInteger maxLength = self.count - range.location;
    return [self subarrayWithRange:NSMakeRange(range.location, MIN(maxLength, range.length))];
}

@end

@implementation NSMutableArray (Safe)

- (void)gj_safeRemoveObjectAtIndex:(NSUInteger)index {
    if (self.count <= index) {
        //        NSLog(@"<<< 警告：数组越界 >>>");
        return;
    }
    
    [self removeObjectAtIndex:index];
}

- (void)gj_removeFirstObject {
    if (self.count > 0) {
        [self removeObjectAtIndex:0];
    }
}

- (void)gj_removeLastObject {
    if (self.count > 0) {
        [self removeLastObject];
    }
}

- (void)gj_safeAddObject:(id)object {
    if (!object) {
        return;
    }
    [self addObject:object];
}

@end
