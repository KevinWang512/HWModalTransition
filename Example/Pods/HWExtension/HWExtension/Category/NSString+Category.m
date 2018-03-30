//
//  NSString+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/11/4.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

+ (BOOL)isEmpty:(NSString *)str {
    return (str == nil || str.length == 0);
}

- (BOOL)containsString:(NSString *)str {
    if (str && str.length) {
        return [self rangeOfString:str].location != NSNotFound;
    }
    return NO;
}

- (NSString *)stringByAdd:(NSString *)str {
    return [self stringByAppendingString:str ? str : @""];
}

// 和 NSNumber 比较
- (NSComparisonResult)compareNumber:(NSNumber *)otherNumber {
    return [@(self.doubleValue) compare:otherNumber];
}

// 空字符串处理
+ (NSString *)handlerString:(NSString *)str emptyReplacing:(NSString *)replacing {
    if (str == nil || str .length == 0) {
        return replacing ? [replacing copy] : nil;
    }
    return [str copy];
}

// 替换一组string
- (NSString *)stringByReplacingOccurrencesOfStrings:(NSArray <NSString *>*)targets withSting:(NSString *)string {
    if (targets == nil || targets.count == 0 || string == nil) {
        return self;
    }
    NSString *result = [self copy];
    for (NSString *target in targets) {
        result = [result stringByReplacingOccurrencesOfString:target withString:string];
    }
    return result;
}

@end

@implementation NSString (Filter)

// 遍历字符串中所有数字字符
- (NSArray <NSString *>*) numberStrings {
    return [self filterCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]];
}

// 遍历字符串中所有 'a'-'z' ,'A'-'Z'的字符串
- (NSArray<NSString *> *)alphabetStrings {
    char c_set[52];
    for (int i = 0; i < 52; i ++) {
        c_set[i] = i < 26 ? ('a' + i) : ('A' + i - 26);
    }
    return [self filterCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithUTF8String:c_set]]];
}

// 大写字符串
- (NSArray<NSString *> *)uppercaseAlphabetStrings {
    char c_set[26];
    for (int i = 0; i < 26; i ++) {
        c_set[i] = 'A' + i;
    }
    return [self filterCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithUTF8String:c_set]]];
}

// 小写字符串
- (NSArray<NSString *> *)lowercaseAlphabetStrings {
    char c_set[26];
    for (int i = 0; i < 26; i ++) {
        c_set[i] = 'a' + i;
    }
    return [self filterCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithUTF8String:c_set]]];
}

// 按字符集遍历字符串
- (NSArray <NSString *>*)filterCharactersFromSet:(NSCharacterSet *)set {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    scanner.caseSensitive = NO;
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    while ([scanner isAtEnd] == NO) {
        NSString *result;
        [scanner scanCharactersFromSet:set intoString:&result];
        if (result && result.length) {
            [resultArray addObject:result];
        }
        if (scanner.isAtEnd == NO) {
            scanner.scanLocation += 1;
        }
    }
    return [resultArray copy];
}

// 使用正则表达式匹配字符串
- (NSArray <NSString *>*)matcheStringsWithRegexString:(NSString *)regexStr {
    return [self  matcheStringsWithRegexString:regexStr inRange:NSMakeRange(0, self.length)];
}

// 使用正则表达式匹配字符串
- (NSArray <NSString *>*)matcheStringsWithRegexString:(NSString *)regexStr inRange:(NSRange)range {
    NSArray <NSTextCheckingResult *>*matches = [self matchesWithRegularExpressionPattern:regexStr range:range];
    NSMutableArray <NSString *>*array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        [array addObject:[self substringWithRange:match.range]];
    }
    return [array copy];
}

// 使用正则表达式匹配字符串
- (NSArray <NSTextCheckingResult *>*)matchesWithRegularExpressionPattern:(NSString *)pattern {
    return [self matchesWithRegularExpressionPattern:pattern range:NSMakeRange(0, self.length)];
}

// 使用正则表达式匹配字符串
- (NSArray <NSTextCheckingResult *>*)matchesWithRegularExpressionPattern:(NSString *)pattern range:(NSRange)range {
    if (self.length == 0 || pattern == nil || pattern.length == 0 || range.length == 0) {
        return @[];
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSRange intersectionRange = NSIntersectionRange(range, NSMakeRange(0, self.length));
    NSArray <NSTextCheckingResult *>*matches = [regex matchesInString:self
                                                              options:NSMatchingReportProgress
                                                                range:intersectionRange];
    return matches;
}

@end

@implementation NSString (NSPredicate)

#define kEmailRegex                 (@"^[A-Za-z0-9]+([._\\-]*[A-Za-z0-9])*@([A-Za-z0-9]+[-A-Za-z0-9]*[A-Za-z0-9]+.){1,63}[A-Za-z0-9]+$")
#define kURLRegex                   (@"^(http|ftp|https)://([\\w-]+\.)+[\\w-]+(/[\\w-./?%&=]*)?$")
#define kIdentificationNumberRegex  (@"\\d{14}[[0-9],0-9xX]")

// Email
-(BOOL)isValidateEmail {
    return [self canMatcheWithRegex:kEmailRegex];
}

// URL
-(BOOL)isValidateURL {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-escape-sequence"
    return [self canMatcheWithRegex:kURLRegex];
#pragma clang diagnostic pop
}

// 验证身份证号（15位或18位数字）
-(BOOL)isValidateIdentificationNumber {
    return [self canMatcheWithRegex:kIdentificationNumberRegex];
}

- (BOOL)canMatcheWithRegex:(NSString *)regex {
    
    if (!regex || regex.length == 0) {
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", regex];
    return [predicate evaluateWithObject:self];
}

@end

@implementation NSString (NSDate)

// timeZone is GMT+0800
- (NSDate *)dateWithFormat:(NSString *)format {
    return [self dateWithFormat:format timeZone:[NSTimeZone timeZoneForSecondsFromGMT:28800]];
}

- (NSDate *)dateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = timeZone;
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:self];
}

@end

@implementation NSString (NSNumberFormatter)

- (NSString *)numberStringWithPositiveFormat:(NSString *)positiveFormat negativeFormat:(NSString *)negativeFormat {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.positiveFormat = positiveFormat;
    numberFormatter.negativeFormat = negativeFormat;
    return [numberFormatter stringFromNumber:@(self.doubleValue)];
}

// 小数位四舍五入, scale : 小数点后有效位数, complete : 是否需要补齐位数
- (NSString *)roundedNumberStringWithScale:(short)scale complete:(BOOL)complete {
    return [self roundedNumberStringWithScale:scale roundingMode:NSRoundPlain complete:complete];
}

// 小数位处理, scale : 小数点后有效位数, roundingMode : 最后一位取舍策略, complete : 是否需要补齐位数
/*
 NSRoundPlain,  四舍五入
 NSRoundDown,   只舍不入
 NSRoundUp,     只入不舍
 NSRoundBankers 四舍六入, 中间值时, 取最近的,保持保留最后一位为偶数
 */
- (NSString *)roundedNumberStringWithScale:(short)scale roundingMode:(NSRoundingMode)roundingMode complete:(BOOL)complete {
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode
                                                                                                      scale:scale
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal = [[NSDecimalNumber alloc] initWithString:self];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    NSString *positiveFormat = @"#0.";
    for (int i=0; i<scale; i++) {
        positiveFormat = [positiveFormat stringByAppendingString:@"0"];
    }
    
    //  需要补齐位数
    if (complete) {
        return [roundedOunces.stringValue numberStringWithPositiveFormat:positiveFormat negativeFormat:nil];
    }
    return roundedOunces.stringValue;
}

@end

@implementation NSString (Unicode)

- (NSString *)stringByReplacingUnicodeString {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                                    options:NSPropertyListImmutable
                                                                     format:NULL
                                                                      error:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

@end

@implementation NSString (SecureFormatter)

- (NSString *)allSecureFormatterString {
    NSMutableString *copyString = [@"" mutableCopy];
    for (int i=0; i<self.length; i++) {
        [copyString appendString:@"*"];
    }
    return [copyString copy];
}

- (NSString *)secureFormatterUserName {
    if (![NSString isEmpty:self]) {
        NSMutableString *copyString = [self mutableCopy];
        if (self.length == 2) {
            [copyString replaceCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
        }else if (self.length > 2) {
            NSInteger count = copyString.length - 2;
            for (int i = 1; i <= count; i++) {
                [copyString replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
        return [copyString copy];
    }
    return [self copy];
}

- (NSString *)secureFormatterPhoneNumber {
    if (![NSString isEmpty:self]) {
        NSMutableString *copyString = [self mutableCopy];
        if (self.length >= 7) {
            [copyString replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }else if(self.length > 2){
            NSInteger count = copyString.length - 2;
            for (int i = 1; i <= count; i++) {
                [copyString replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
        return [copyString copy];
    }
    return [self copy];
}

@end

// 富文本
@implementation NSString (AttributedString)

- (NSMutableAttributedString *)attributedStringWithColor:(UIColor *)color {
    return [self attributedStringWithColor:color font:nil range:NSMakeRange(0, self.length)];
}

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font {
    return [self attributedStringWithColor:nil font:font range:NSMakeRange(0, self.length)];
}

- (NSMutableAttributedString *)attributedStringWithColor:(UIColor *)color font:(UIFont *)font {
    return [self attributedStringWithColor:color font:font range:NSMakeRange(0, self.length)];
}

- (NSMutableAttributedString *)attributedStringWithColor:(UIColor *)color range:(NSRange)range {
    return [self attributedStringWithColor:color font:nil range:range];
}

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font range:(NSRange)range {
    return [self attributedStringWithColor:nil font:font range:range];
}

- (NSMutableAttributedString *)attributedStringWithColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range {
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:self];
    if (!self.length || (!color && !font) || !range.length) {
        return aStr;
    }
    NSRange intersectionRang = NSIntersectionRange(range, NSMakeRange(0, self.length));
    if (font) {
        [aStr addAttributes:@{NSFontAttributeName : font} range:intersectionRang];
    }
    if (color) {
        [aStr addAttributes:@{NSForegroundColorAttributeName : color} range:intersectionRang];
    }
    return aStr;
}

- (NSAttributedString *)attributedFromHTML {
    NSDictionary *option = @{NSDocumentTypeDocumentOption : NSHTMLTextDocumentType,
                             NSCharacterEncodingDocumentOption : @(NSUTF8StringEncoding)};
    
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:option
                                                              documentAttributes:nil
                                                                           error:NULL];
    return attributedStr;
}

@end

@implementation NSString (URL)

- (NSString *)hw_stringByRemovingPercentEncoding {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        return [self stringByRemovingPercentEncoding];
    } else {
        return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

- (NSString *)hw_stringByAddingPercentEncoding {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    } else {
        return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

-(NSURL *)hw_URL {
    NSString *string = [[self hw_stringByRemovingPercentEncoding] hw_stringByAddingPercentEncoding];
    NSURL *url = [NSURL URLWithString:string];
    return url;
}

@end

