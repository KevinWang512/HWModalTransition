//
//  NSDate+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/12/8.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (NSString)

- (NSString *)stringWithFormat:(NSString *)format {
    return [self stringWithFormat:format timeZone:[NSTimeZone timeZoneForSecondsFromGMT:28800]];
}

- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = timeZone;
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:self];
}

@end

@implementation NSDate (Utils)

- (NSDate *)lastEra {
    return [self dateByAddingUnit:NSCalendarUnitEra value:-1];
}

- (NSDate *)lastYear {
    return [self dateByAddingUnit:NSCalendarUnitYear value:-1];
}

- (NSDate *)lastMonth {
    return [self dateByAddingUnit:NSCalendarUnitMonth value:-1];
}

- (NSDate *)lastDay {
    return [self dateByAddingUnit:NSCalendarUnitDay value:-1];
}

- (NSDate *)lastHour {
    return [self dateByAddingUnit:NSCalendarUnitHour value:-1];
}

- (NSDate *)lastMinute {
    return [self dateByAddingUnit:NSCalendarUnitMinute value:-1];
}

- (NSDate *)lastSecond {
    return [self dateByAddingUnit:NSCalendarUnitSecond value:-1];
}

- (NSDate *)nextEra {
    return [self dateByAddingUnit:NSCalendarUnitEra value:1];
}

- (NSDate *)nextYear {
    return [self dateByAddingUnit:NSCalendarUnitYear value:1];
}

- (NSDate *)nextMonth {
    return [self dateByAddingUnit:NSCalendarUnitMonth value:1];
}

- (NSDate *)nextDay {
    return [self dateByAddingUnit:NSCalendarUnitDay value:1];
}

- (NSDate *)nextHour {
    return [self dateByAddingUnit:NSCalendarUnitHour value:1];
}

- (NSDate *)nextMinute {
    return [self dateByAddingUnit:NSCalendarUnitMinute value:1];
}

- (NSDate *)nextSecond {
    return [self dateByAddingUnit:NSCalendarUnitSecond value:1];
}

- (NSDate *)dateByAddingUnit:(NSCalendarUnit)unit value:(NSInteger)value {
    return [self dateByAddingUnit:unit value:value options:NSCalendarWrapComponents];
}

- (NSDate *)dateByAddingUnit:(NSCalendarUnit)unit value:(NSInteger)value options:(NSCalendarOptions)options {
    NSDateComponents *coms = [[NSDateComponents alloc] init];
    [self setUnit:unit value:value forComponents:coms];
    return [self dateByAddingComponents:coms options:options];
}

- (NSDate *)dateByAddingComponents:(NSDateComponents *)comps {
    return [self dateByAddingComponents:comps options:NSCalendarWrapComponents];
}

- (NSDate *)dateByAddingComponents:(NSDateComponents *)comps options:(NSCalendarOptions)opts {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar dateByAddingComponents:comps toDate:self options:opts];
}

#pragma mark - def

- (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)startingDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar components:unitFlags fromDate:startingDate toDate:self options:NSCalendarWrapComponents];
}

- (NSDateComponents *)components:(NSCalendarUnit)unitFlags toDate:(NSDate *)resultDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar components:unitFlags fromDate:self toDate:resultDate options:NSCalendarWrapComponents];
}

- (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)startingDate options:(NSCalendarOptions)opts {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar components:unitFlags fromDate:startingDate toDate:self options:opts];
}

- (NSDateComponents *)components:(NSCalendarUnit)unitFlags toDate:(NSDate *)resultDate options:(NSCalendarOptions)opts {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar components:unitFlags fromDate:self toDate:resultDate options:opts];
}

- (NSInteger)component:(NSCalendarUnit)unitFlags fromDate:(NSDate *)startingDate {
    return [[self components:unitFlags fromDate:startingDate] valueForComponent:unitFlags];
}
- (NSInteger)component:(NSCalendarUnit)unitFlags toDate:(NSDate *)resultDate {
    return [[self components:unitFlags toDate:resultDate] valueForComponent:unitFlags];
}

- (void)setUnit:(NSCalendarUnit)unit value:(NSInteger)value forComponents:(NSDateComponents *)coms {
    switch (unit) {
        case NSCalendarUnitEra:
            coms.era = value;
            break;
            
        case NSCalendarUnitYear:
            coms.year = value;
            break;
            
        case NSCalendarUnitMonth:
            coms.month = value;
            break;
            
        case NSCalendarUnitDay:
            coms.day = value;
            break;
            
        case NSCalendarUnitHour:
            coms.hour = value;
            break;
            
        case NSCalendarUnitMinute:
            coms.minute = value;
            break;
            
        case NSCalendarUnitSecond:
            coms.second = value;
            break;
            
        case NSCalendarUnitNanosecond:
            coms.nanosecond = value;
            break;
            
        case NSCalendarUnitWeekday:
            coms.weekday = value;
            break;
            
        case NSCalendarUnitWeekdayOrdinal:
            coms.weekdayOrdinal = value;
            break;
            
        case NSCalendarUnitQuarter:
            coms.quarter = value;
            break;
            
        case NSCalendarUnitWeekOfMonth:
            coms.weekOfMonth = value;
            break;
            
        case NSCalendarUnitWeekOfYear:
            coms.weekOfYear = value;
            break;
            
        case NSCalendarUnitYearForWeekOfYear:
            coms.yearForWeekOfYear = value;
            break;
            
        default:
            break;
    }
}

@end
