//
//  NSArray+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/7/20.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Category)

// 将数组按一定长度分段
- (NSArray <NSArray *>*)componentsByDividedLength:(NSUInteger)length;

// 交集
- (NSArray *)intersectArrayWithArray:(NSArray *)otherArray;

// 并集
- (NSArray *)unionArrayWithArray:(NSArray *)otherArray;

// 差集
- (NSArray *)minusArrayWithArray:(NSArray *)otherArray;

@end
