//
//  NSMutableAttributedString+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/4/19.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "NSMutableAttributedString+Category.h"

@implementation NSMutableAttributedString (Category)

#pragma mark - lineSpacing / alignment / range

- (void)resetLineSpacing:(CGFloat)lineSpacing {
    [self resetLineSpacing:lineSpacing range:NSMakeRange(0, self.length)];
}

- (void)resetLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSRange intersectionRange = NSIntersectionRange(NSMakeRange(0, self.length), range);
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:intersectionRange];
}

- (void)resetTextAlignment:(NSTextAlignment)alignment {
    [self resetTextAlignment:alignment range:NSMakeRange(0, self.length)];
}

- (void)resetTextAlignment:(NSTextAlignment)alignment range:(NSRange)range {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;
    NSRange intersectionRange = NSIntersectionRange(NSMakeRange(0, self.length), range);
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:intersectionRange];
}

- (void)resetLineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment {
    [self resetLineSpacing:lineSpacing alignment:alignment range:NSMakeRange(0, self.length)];
}

- (void)resetLineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment range:(NSRange)range {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.alignment = alignment;
    NSRange intersectionRange = NSIntersectionRange(NSMakeRange(0, self.length), range);
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:intersectionRange];
}

#pragma mark - color / font / range

- (void)resetFont:(UIFont *)font {
    [self resetFont:font range:NSMakeRange(0, self.length)];
}

- (void)resetColor:(UIColor *)color {
    return [self resetColor:color range:NSMakeRange(0, self.length)];
}

- (void)resetColor:(UIColor *)color font:(UIFont *)font {
    [self resetColor:color font:font range:NSMakeRange(0, self.length)];
}

- (void)resetColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range {
    [self resetFont:font range:range];
    [self resetColor:color range:range];
}

- (void)resetFont:(UIFont *)font range:(NSRange)range {
    NSRange intersectionRange = NSIntersectionRange(NSMakeRange(0, self.length), range);
    [self addAttribute:NSFontAttributeName value:font range:intersectionRange];
}

- (void)resetColor:(UIColor *)color range:(NSRange)range {
    NSRange intersectionRange = NSIntersectionRange(NSMakeRange(0, self.length), range);
    [self addAttribute:NSForegroundColorAttributeName value:color range:intersectionRange];
}

@end
