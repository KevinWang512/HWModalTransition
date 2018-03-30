//
//  UILabel+Category.h
//  HWExtension
//
//  Created by houwen.wang on 16/6/6.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWCategorys.h"

#define kTextHeight(text, limitWidth, font)                                                                                    \
((!text || text.length == 0) ? 0 : [text boundingRectWithSize:CGSizeMake(limitWidth, MAXFLOAT)                                                               \
options:NSStringDrawingUsesLineFragmentOrigin                                                          \
attributes:@{NSFontAttributeName: font}                                                                   \
context:nil]                                                                                           \
.size.height)

#define kTextWidth(text, limitHeight, font)                                                                                    \
((!text || text.length == 0) ? 0 : [text boundingRectWithSize:CGSizeMake(MAXFLOAT, limitHeight)                                                              \
options:NSStringDrawingUsesLineFragmentOrigin                                                          \
attributes:@{NSFontAttributeName: font}                                                                   \
context:nil]                                                                                           \
.size.width)

#define kAttributedTextHeight(attributedText, limitWidth)                                                                      \
((!attributedText || attributedText.length == 0) ? 0 : [attributedText boundingRectWithSize:CGSizeMake(limitWidth, MAXFLOAT)                                                     \
options:NSStringDrawingUsesLineFragmentOrigin                                                \
context:nil]                                                                                 \
.size.height)

#define kAttributedTextWidth(attributedText, limitHeight)                                                                      \
((!attributedText || attributedText.length == 0) ? 0 : [attributedText boundingRectWithSize:CGSizeMake(MAXFLOAT, limitHeight)                                                    \
options:NSStringDrawingUsesLineFragmentOrigin                                                \
context:nil]                                                                                 \
.size.width)

@interface UILabel (Utils)

+ (UILabel *)labelWithText:(NSString *)text frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)ali;
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)ali;
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color;
+ (UILabel *)labelWithText:(NSString *)text frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color;

@end

@interface UILabel (UIEdgeInsets)

@property (nonatomic, assign) UIEdgeInsets edgeInsets;  //  上下左右间距

@end

#pragma mark - 正数／0.0／负数 不同状态的颜色

@interface UILabel (ValueStateColors)

@property (nonatomic, assign) BOOL showPositiveSign;  // 正数前是否添加 "+" , default is NO

// 该范围内查找金额字段
@property (nonatomic, assign) NSRange detectorRange; // 识别区域, default is NSMakeRange(0, self.text.length)

// key : @(NSComparisonResult), value : UIColor
@property (nonatomic, strong) NSDictionary <NSNumber *, UIColor *>*valueStateColors;  //

@end

@interface UILabel (Display)

- (void)fixBlurredText; // 坐标取整, 避免显示模糊

@end

@interface UILabel (Size)

/**
 *  单行文字高度
 *  @return 单行文字高度
 */
- (CGFloat)singleLineHeight;

/**
 *  单行文字宽度
 *  @return 单行文字宽度
 */
- (CGFloat)singleLineWidth;

/**
 *  单行文字bounds
 *  @return 单行文字bounds
 */
- (CGSize)singleLineSize;

/**
 *  设定的高度下文本宽度
 *  @param  limitHeight 设定的高度
 *  @return 设定的高度下文本宽度
 */
- (CGFloat)textWidthForHeight:(CGFloat)limitHeight;

/**
 *  设定的宽度下文本高度
 *  @param  limitWidth 设定的宽度
 *  @return 设定的宽度下文本高度
 */
- (CGFloat)textHeightForWidth:(CGFloat)limitWidth;

@end

@interface UILabel (NSAttributedString)

/**
 *  设置label文字局部颜色
 *  @param color 颜色
 *  @param rang  范围
 */
- (void)replaceTextColor:(UIColor *)color inRang:(NSRange)rang;

/**
 *  设置label文字局部颜色
 *  @param color 颜色
 *  @param ranges ,NSArray <NSRange> 除了一组NSRange之外的文字将被替换颜色
 */
- (void)replaceTextColor:(UIColor *)color exceptRanges:(NSArray <NSValue *>*)ranges;

/**
 *  设置label文字局部字体
 *  @param font 字体
 *  @param rang 范围
 */
- (void)replaceTextFont:(UIFont *)font inRang:(NSRange)rang;

/**
 *  设置label文字局部字体 && 颜色
 *  @param font  字体
 *  @param color 颜色
 *  @param rang  范围
 */
- (void)replaceTextFont:(UIFont *)font color:(UIColor *)color inRang:(NSRange)rang;

/**
 *  设置label文行距
 *  @param lineSpace  行距
 */
- (void)setLineSpace:(CGFloat)lineSpace;

/**
 *  设置label文字局部行距
 *  @param lineSpace  行距
 *  @param rang       范围
 */
- (void)setLineSpace:(CGFloat)lineSpace inRang:(NSRange)rang;

/**
 *  设置label文字局部行距 && 对齐方式
 *  @param lineSpace    行距
 *  @param alignment    对齐方式
 */
- (void)setLineSpace:(CGFloat)lineSpace alignment:(NSTextAlignment)alignment;

/**
 *  设置label文字局部行距 && 对齐方式
 *  @param lineSpace    行距
 *  @param alignment    对齐方式
 *  @param rang         范围
 */
- (void)setLineSpace:(CGFloat)lineSpace alignment:(NSTextAlignment)alignment inRang:(NSRange)rang;

// 插入图片
- (void)insertImage:(UIImage *)image atIndex:(NSUInteger)index bounds:(CGRect)bounds ;

@end
