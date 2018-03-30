//
//  NSAttributedString+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/4/19.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "NSAttributedString+Category.h"

@implementation NSAttributedString (Category)

#pragma mark - lineSpacing / alignment / range

- (NSAttributedString *)attributedStringByResetLineSpacing:(CGFloat)lineSpacing {
    return [self attributedStringByResetLineSpacing:lineSpacing range:NSMakeRange(0, self.length)];
}

- (NSAttributedString *)attributedStringByResetLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
    return [self attributedStringByResetLineSpacing:lineSpacing alignment:NSTextAlignmentLeft range:range];
}

- (NSAttributedString *)attributedStringByResetTextAlignment:(NSTextAlignment)alignment {
    return [self attributedStringByResetTextAlignment:alignment range:NSMakeRange(0, self.length)];
}

- (NSAttributedString *)attributedStringByResetTextAlignment:(NSTextAlignment)alignment range:(NSRange)range {
    return [self attributedStringByResetLineSpacing:0 alignment:alignment range:range];
}

- (NSAttributedString *)attributedStringByResetLineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment {
    return [self attributedStringByResetLineSpacing:lineSpacing alignment:alignment range:NSMakeRange(0, self.length)];
}

- (NSAttributedString *)attributedStringByResetLineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment range:(NSRange)range {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.alignment = alignment;
    NSRange intersectionRange = NSIntersectionRange(NSMakeRange(0, self.length), range);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:intersectionRange];
    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

#pragma mark - color / font / range

- (NSAttributedString *)attributedStringByResetFont:(UIFont *)font {
    return [self attributedStringByResetFont:font range:NSMakeRange(0, self.length)];
}

- (NSAttributedString *)attributedStringByResetColor:(UIColor *)color {
    return [self attributedStringByResetColor:color range:NSMakeRange(0, self.length)];
}

- (NSAttributedString *)attributedStringByResetColor:(UIColor *)color font:(UIFont *)font {
    return [self attributedStringByResetColor:color font:font range:NSMakeRange(0, self.length)];
}

- (NSAttributedString *)attributedStringByResetColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range {
    return [[self attributedStringByResetFont:font range:range] attributedStringByResetColor:color range:range];
}

- (NSAttributedString *)attributedStringByResetFont:(UIFont *)font range:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    NSRange intersectionRange = NSIntersectionRange(NSMakeRange(0, self.length), range);
    [attributedString addAttribute:NSFontAttributeName value:font range:intersectionRange];
    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

- (NSAttributedString *)attributedStringByResetColor:(UIColor *)color range:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    NSRange intersectionRange = NSIntersectionRange(NSMakeRange(0, self.length), range);
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:intersectionRange];
    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

@end
