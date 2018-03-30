//
//  NSArray+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/7/20.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)

- (NSArray <NSArray *>*)componentsByDividedLength:(NSUInteger)length {
    
    if (length <= 0) {
        
        return @[@[]];
        
    } else if (length >= self.count) {
        
        return [[NSArray alloc] initWithArray:@[[self subarrayWithRange:NSMakeRange(0, self.count)]] copyItems:YES];
        
    } else {
        
        NSMutableArray <NSArray *>*result = [NSMutableArray array];
        for (int i = 0; i<self.count; i+=length) {
            [result addObject:[self subarrayWithRange:NSMakeRange(i, MIN(length, self.count - i))]];
        }
        
        return [[NSArray alloc] initWithArray:result copyItems:YES];
    }
}

// 交集
- (NSArray *)intersectArrayWithArray:(NSArray *)otherArray {
    NSMutableSet *set1 = [NSMutableSet setWithArray:self];
    NSMutableSet *set2 = [NSMutableSet setWithArray:otherArray];
    [set1 intersectSet:set2];
    return set1.allObjects;
}

// 并集
- (NSArray *)unionArrayWithArray:(NSArray *)otherArray {
    NSMutableSet *set1 = [NSMutableSet setWithArray:self];
    NSMutableSet *set2 = [NSMutableSet setWithArray:otherArray];
    [set1 unionSet:set2];
    return set1.allObjects;
}

// 差集
- (NSArray *)minusArrayWithArray:(NSArray *)otherArray {
    NSMutableSet *set1 = [NSMutableSet setWithArray:self];
    NSMutableSet *set2 = [NSMutableSet setWithArray:otherArray];
    [set1 minusSet:set2];
    return set1.allObjects;
}

@end
