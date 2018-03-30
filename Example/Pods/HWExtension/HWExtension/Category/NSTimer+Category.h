//
//  NSTimer+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/12/6.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Category)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval fireDate:(NSDate *)date repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end
