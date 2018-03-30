//
//  NSMutableAttributedString+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/4/19.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Category)

#pragma mark - lineSpacing / alignment / range

// 行间距
- (void)resetLineSpacing:(CGFloat)lineSpacing;
// 行间距
- (void)resetLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;
// 对齐方式
- (void)resetTextAlignment:(NSTextAlignment)alignment;
// 对齐方式
- (void)resetTextAlignment:(NSTextAlignment)alignment range:(NSRange)range;
// 对齐方式 & 行间距
- (void)resetLineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment;
// 对齐方式 & 行间距
- (void)resetLineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment range:(NSRange)range;

#pragma mark - color / font / range

- (void)resetFont:(UIFont *)font;

- (void)resetColor:(UIColor *)color;

- (void)resetColor:(UIColor *)color font:(UIFont *)font;

- (void)resetColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range;

- (void)resetFont:(UIFont *)font range:(NSRange)range;

- (void)resetColor:(UIColor *)color range:(NSRange)range;

@end
