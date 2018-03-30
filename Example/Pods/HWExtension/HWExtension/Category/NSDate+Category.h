//
//  NSDate+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/12/8.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSString)

// timeZone is GMT+0800
- (NSString *)stringWithFormat:(NSString *)format;

- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone;

@end

@interface NSDate (Utils)

@property (nonatomic, assign, readonly) NSDate *lastEra;
@property (nonatomic, assign, readonly) NSDate *lastYear;
@property (nonatomic, assign, readonly) NSDate *lastMonth;
@property (nonatomic, assign, readonly) NSDate *lastDay;
@property (nonatomic, assign, readonly) NSDate *lastHour;
@property (nonatomic, assign, readonly) NSDate *lastMinute;
@property (nonatomic, assign, readonly) NSDate *lastSecond;

@property (nonatomic, assign, readonly) NSDate *nextEra;
@property (nonatomic, assign, readonly) NSDate *nextYear;
@property (nonatomic, assign, readonly) NSDate *nextMonth;
@property (nonatomic, assign, readonly) NSDate *nextDay;
@property (nonatomic, assign, readonly) NSDate *nextHour;
@property (nonatomic, assign, readonly) NSDate *nextMinute;
@property (nonatomic, assign, readonly) NSDate *nextSecond;

- (NSDate *)dateByAddingUnit:(NSCalendarUnit)unit value:(NSInteger)value;
- (NSDate *)dateByAddingUnit:(NSCalendarUnit)unit value:(NSInteger)value options:(NSCalendarOptions)options;

- (NSDate *)dateByAddingComponents:(NSDateComponents *)comps;
- (NSDate *)dateByAddingComponents:(NSDateComponents *)comps options:(NSCalendarOptions)opts;

#pragma mark - def

- (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)startingDate;
- (NSDateComponents *)components:(NSCalendarUnit)unitFlags toDate:(NSDate *)resultDate;
- (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)startingDate options:(NSCalendarOptions)opts;
- (NSDateComponents *)components:(NSCalendarUnit)unitFlags toDate:(NSDate *)resultDate options:(NSCalendarOptions)opts;

- (NSInteger)component:(NSCalendarUnit)unitFlags fromDate:(NSDate *)startingDate;
- (NSInteger)component:(NSCalendarUnit)unitFlags toDate:(NSDate *)resultDate;

@end
