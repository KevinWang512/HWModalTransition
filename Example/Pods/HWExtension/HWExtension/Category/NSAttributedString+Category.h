//
//  NSAttributedString+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/4/19.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (Category)

#pragma mark - lineSpacing / alignment / range

// 行间距
- (NSAttributedString *)attributedStringByResetLineSpacing:(CGFloat)lineSpacing;
// 行间距
- (NSAttributedString *)attributedStringByResetLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;
// 对齐方式
- (NSAttributedString *)attributedStringByResetTextAlignment:(NSTextAlignment)alignment;
// 对齐方式
- (NSAttributedString *)attributedStringByResetTextAlignment:(NSTextAlignment)alignment range:(NSRange)range;
// 对齐方式 & 行间距
- (NSAttributedString *)attributedStringByResetLineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment;
// 对齐方式 & 行间距
- (NSAttributedString *)attributedStringByResetLineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment range:(NSRange)range;


#pragma mark - color / font / range

- (NSAttributedString *)attributedStringByResetFont:(UIFont *)font;

- (NSAttributedString *)attributedStringByResetColor:(UIColor *)color;

- (NSAttributedString *)attributedStringByResetColor:(UIColor *)color font:(UIFont *)font;

- (NSAttributedString *)attributedStringByResetColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range;

- (NSAttributedString *)attributedStringByResetFont:(UIFont *)font range:(NSRange)range;

- (NSAttributedString *)attributedStringByResetColor:(UIColor *)color range:(NSRange)range;

@end
