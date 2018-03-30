//
//  UILabel+Category.m
//  HWExtension
//
//  Created by houwen.wang on 16/6/6.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UILabel+Category.h"
#import <objc/message.h>

@interface UILabel ()

@property (nonatomic, weak) UIFont *realFont;        // 实际的font
@property (nonatomic, weak) UIColor *realTextColor;  // 实际的textColor
@property (strong, nonatomic, readonly) NSAttributedString *hx_attributedText;  // 最终显示的文本

@end

@implementation UILabel (Utils)

+ (UILabel *)labelWithText:(NSString *)text frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)ali {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.textAlignment = ali;
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)ali {
    return [self labelWithText:text frame:CGRectZero font:font textColor:color alignment:ali];
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color {
    return [self labelWithText:text frame:CGRectZero font:font textColor:color alignment:NSTextAlignmentLeft];
}

+ (UILabel *)labelWithText:(NSString *)text frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color {
    return [self labelWithText:text frame:frame font:font textColor:color alignment:NSTextAlignmentLeft];
}

@end

@implementation UILabel (UIEdgeInsets)

+ (void)load {
    [self exchangeImplementations:@selector(drawTextInRect:) otherMethod:@selector(hx_drawTextInRect:) isInstance:YES];
}

- (UIEdgeInsets)edgeInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    objc_setAssociatedObject(self, @selector(edgeInsets), [NSValue valueWithUIEdgeInsets:edgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}

- (void)hx_drawTextInRect:(CGRect)rect {
    CGRect r = CGRectMake(self.edgeInsets.left + rect.origin.x,
                          self.edgeInsets.top + rect.origin.y,
                          rect.size.width - self.edgeInsets.left - self.edgeInsets.right,
                          rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom);
    [self hx_drawTextInRect:r];
}

@end

#pragma mark - ValueStateColors

@interface UILabel ()
@property (nonatomic, assign) BOOL didSetShowPositiveSignProperty;  //
@property (nonatomic, assign) BOOL didSetValueStateColorsProperty;  //
@property (nonatomic, assign) BOOL didSetDetectorRangeProperty;     //
@end

@implementation UILabel (ValueStateColors)

+ (void)load {
    [self exchangeImplementations:@selector(setText:) otherMethod:@selector(hx_setText:) isInstance:YES];
    [self exchangeImplementations:@selector(setAttributedText:) otherMethod:@selector(hx_setAttributedText:) isInstance:YES];
}

- (void)hx_setText:(NSString *)text {
    
    [self hx_setText:(text != nil ? [text copy] : nil)];
    
    if (self.didSetValueStateColorsProperty || self.didSetShowPositiveSignProperty) {
        [self _resetTextColorAndAddPositiveSign];
    }
}

- (void)hx_setAttributedText:(NSAttributedString *)attributedText {
    
    [self hx_setAttributedText:(attributedText != nil ? [attributedText copy] : nil)];
    
    if (self.didSetValueStateColorsProperty || self.didSetShowPositiveSignProperty) {
        [self _resetTextColorAndAddPositiveSign];
    }
}

- (NSDictionary<NSNumber *,UIColor *> *)valueStateColors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setValueStateColors:(NSDictionary<NSNumber *,UIColor *> *)valueStateColors {
    objc_setAssociatedObject(self, @selector(valueStateColors), valueStateColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.didSetValueStateColorsProperty = YES;
    [self _resetTextColorAndAddPositiveSign];
}

- (BOOL)showPositiveSign {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setShowPositiveSign:(BOOL)showPositiveSign {
    if (self.showPositiveSign != showPositiveSign) {
        objc_setAssociatedObject(self, @selector(showPositiveSign), @(showPositiveSign), OBJC_ASSOCIATION_ASSIGN);
        self.didSetShowPositiveSignProperty = YES;
        [self _resetTextColorAndAddPositiveSign];
    }
}

- (NSRange)detectorRange {
    if (self.didSetDetectorRangeProperty) {
        return [objc_getAssociatedObject(self, _cmd) rangeValue];
    } else {
        return NSMakeRange(0, self.attributedText ? self.attributedText.length : 0);
    }
}

- (void)setDetectorRange:(NSRange)detectorRange {
    objc_setAssociatedObject(self, @selector(detectorRange), [NSValue valueWithRange:detectorRange], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.didSetDetectorRangeProperty = YES;
    [self _resetTextColorAndAddPositiveSign];
}

- (BOOL)didSetShowPositiveSignProperty {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDidSetShowPositiveSignProperty:(BOOL)didSetShowPositiveSignProperty {
    objc_setAssociatedObject(self, @selector(didSetShowPositiveSignProperty), @(didSetShowPositiveSignProperty), OBJC_ASSOCIATION_ASSIGN);
    [self _resetTextColorAndAddPositiveSign];
}

- (BOOL)didSetValueStateColorsProperty {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDidSetValueStateColorsProperty:(BOOL)didSetValueStateColorsProperty {
    objc_setAssociatedObject(self, @selector(didSetValueStateColorsProperty), @(didSetValueStateColorsProperty), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)didSetDetectorRangeProperty {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDidSetDetectorRangeProperty:(BOOL)didSetDetectorRangeProperty {
    objc_setAssociatedObject(self, @selector(didSetDetectorRangeProperty), @(didSetDetectorRangeProperty), OBJC_ASSOCIATION_ASSIGN);
}

- (void) _resetTextColorAndAddPositiveSign {
    
    if (self.attributedText == nil || self.attributedText.length == 0) return;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-escape-sequence"
    NSString *regex = @"[+-]?\s*([0-9]+[,，]?)+((.?[0-9]+)|[0-9]*)[%%]?";
#pragma clang diagnostic pop
    
    NSMutableAttributedString *selfAttributedCopy = [self.attributedText mutableCopy];
    if (selfAttributedCopy == nil) return;
    
    NSArray <NSTextCheckingResult *>*matches = [selfAttributedCopy.string matchesWithRegularExpressionPattern:regex range:self.detectorRange];
    if (matches.count == 0) return;
    
    NSMutableArray <NSDictionary <NSValue *, NSAttributedString *>*>*resultItems = [NSMutableArray arrayWithCapacity:matches.count];
    
    NSUInteger offset = 0;
    for (NSTextCheckingResult *m in matches) {
        
        NSMutableAttributedString *itemAtt = [[selfAttributedCopy attributedSubstringFromRange:m.range] mutableCopy];
        
        // 去掉,，%
        NSString *str = [itemAtt.string stringByReplacingOccurrencesOfStrings:@[@",",
                                                                                @"，",
                                                                                @"%",
                                                                                @"%"]
                                                                    withSting:@""];
        NSComparisonResult r = NSOrderedSame;
        if (str.doubleValue > 0) {
            r = NSOrderedAscending;
        } else if (str.doubleValue < 0) {
            r = NSOrderedDescending;
        }
        
        // 颜色
        if (self.valueStateColors && self.valueStateColors.count) {
            if ([self.valueStateColors.allKeys containsObject:@(r)]) {
                [itemAtt resetColor:self.valueStateColors[@(r)]];
            }
        }
        
        // 自动添加 "+" 符号
        BOOL addPositive = NO;
        if (self.showPositiveSign &&
            r != NSOrderedSame &&
            ![str hasPrefix:@"+"] &&
            ![str hasPrefix:@"-"]) {
            
            addPositive = YES;
            offset++;
            
            NSDictionary *attributes = [itemAtt attributesAtIndex:0 effectiveRange:NULL];
            NSAttributedString *positive = [[NSAttributedString alloc] initWithString:@"+" attributes:attributes];
            [itemAtt insertAttributedString:positive atIndex:0];
        }
        [resultItems addObject:@{[NSValue valueWithRange:NSMakeRange(m.range.location + offset - addPositive, m.range.length)] : itemAtt}];
    }
    
    for (NSDictionary <NSValue *, NSAttributedString *>*item in resultItems) {
        NSRange range = item.allKeys.firstObject.rangeValue;
        NSAttributedString *att = item.allValues.firstObject;
        [selfAttributedCopy replaceCharactersInRange:range withAttributedString:att];
    }
    
    if (![self.attributedText isEqualToAttributedString:selfAttributedCopy]) {
        self.attributedText = selfAttributedCopy;
    }
}

@end

@implementation UILabel (Display)

- (void)fixBlurredText {
    CGRect rect = self.frame;
    rect.origin = CGPointMake(ceilf(rect.origin.x), ceilf(rect.origin.y));
    rect.size = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
    self.frame = rect;
}

@end

@implementation UILabel (Size)

+ (void)load {
    [self exchangeImplementations:@selector(setFont:) otherMethod:@selector(_hx_setFont:) isInstance:YES];
    [self exchangeImplementations:@selector(setTextColor:) otherMethod:@selector(_hx_setTextColor:) isInstance:YES];
}

- (void)_hx_setFont:(UIFont *)font {
    [self _hx_setFont:font];
    self.realFont = font;
}

- (void)_hx_setTextColor:(UIColor *)textColor {
    [self _hx_setTextColor:textColor];
    self.realTextColor = textColor;
}

#pragma mark -

- (UIFont *)realFont {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRealFont:(UIFont *)realFont {
    objc_setAssociatedObject(self, @selector(realFont), realFont, OBJC_ASSOCIATION_ASSIGN);
}

- (UIColor *)realTextColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRealTextColor:(UIColor *)realTextColor {
    objc_setAssociatedObject(self, @selector(realTextColor), realTextColor, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark -

- (UILabel *)copyLabel:(UILabel *)label {
    if (label == nil) return nil;
    UILabel *l = [[[label class] alloc] init];
    l.numberOfLines = label.numberOfLines;
    l.lineBreakMode = label.lineBreakMode;
    l.textAlignment = label.textAlignment;
    l.adjustsFontSizeToFitWidth = label.adjustsFontSizeToFitWidth;
    l.baselineAdjustment = label.baselineAdjustment;
    l.minimumScaleFactor = label.minimumScaleFactor;
    l.font = label.font;
    l.attributedText = (label.attributedText ? [label.attributedText copy] : nil);
    return l;
}

/**
 *  单行文字高度
 *  @return 单行文字高度
 */
- (CGFloat)singleLineHeight {
    return [self singleLineSize].height;
}

/**
 *  单行文字宽度
 *  @return 单行文字宽度
 */
- (CGFloat)singleLineWidth {
    return [self singleLineSize].width;
}

/**
 *  单行文字bounds
 *  @return 单行文字bounds
 */
- (CGSize)singleLineSize {
    UILabel *l = [self copyLabel:self];
    [l sizeToFit];
    
    CGSize size = l.bounds.size;
    size.width += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    
    return size;
}

/**
 *  设定的高度下文本宽度
 *  @param  limitHeight 设定的高度
 *  @return 设定的高度下文本宽度
 */
- (CGFloat)textWidthForHeight:(CGFloat)limitHeight {
    return kAttributedTextWidth(self.hx_attributedText, limitHeight - self.edgeInsets.top - self.edgeInsets.bottom) + self.edgeInsets.left + self.edgeInsets.right;
}

/**
 *  设定的宽度下文本高度
 *  @param  limitWidth 设定的宽度
 *  @return 设定的宽度下文本高度
 */
- (CGFloat)textHeightForWidth:(CGFloat)limitWidth {
    UILabel *l = [self copyLabel:self];
    l.width = limitWidth - self.edgeInsets.left - self.edgeInsets.right;
    [l sizeToFit];
    return l.bounds.size.height + self.edgeInsets.top + self.edgeInsets.bottom;
}

// 最终显示的文本
- (NSAttributedString *)hx_attributedText {
    @try {
        
        if (self.attributedText == nil || self.attributedText.length == 0) {
            return (self.attributedText == nil ? nil : [self.attributedText copy]);
        }
        
        __block NSMutableAttributedString *attributedStringM = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        if (attributedStringM == nil) return [self.attributedText copy];
        
        if (self.realFont) {
            [attributedStringM addAttribute:NSFontAttributeName value:self.realFont range:NSMakeRange(0, attributedStringM.length)];
        }
        
        if (self.realTextColor) {
            [attributedStringM addAttribute:NSForegroundColorAttributeName
                                      value:self.realTextColor
                                      range:NSMakeRange(0, attributedStringM.length)];
        }
        
        [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length)
                                                options:NSAttributedStringEnumerationReverse
                                             usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                                                 if (attrs && range.location != NSNotFound) {
                                                     [attributedStringM addAttributes:attrs range:range];
                                                 }
                                             }];
        
        return [[NSAttributedString alloc] initWithAttributedString:attributedStringM];
        
    } @catch (NSException *exception) {
        
        return self.attributedText == nil ? nil : [self.attributedText copy];
        
    }
}

@end

@implementation UILabel (NSAttributedString)

/**
 *  设置label文字局部颜色
 *  @param color 颜色
 *  @param rang  范围
 */
- (void)replaceTextColor:(UIColor *)color inRang:(NSRange)rang {
    if (!self.attributedText.length || !color || !rang.length) {
        return;
    }
    NSRange r = NSMakeRange(0, self.attributedText.string.length);
    
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange intersectionRang = NSIntersectionRange(rang, r);
    [aStr addAttributes:@{ NSForegroundColorAttributeName: color } range:intersectionRang];
    self.attributedText = aStr;
}

/**
 *  设置label文字局部颜色
 *  @param color 颜色
 *  @param ranges ,NSArray <NSRange> 除了一组NSRange之外的文字将被替换颜色
 */
- (void)replaceTextColor:(UIColor *)color exceptRanges:(NSArray <NSValue *>*)ranges {
    if (!self.attributedText.length || !color || !ranges || !ranges.count) {
        return;
    }
    
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSMutableArray <NSDictionary <NSValue *,NSAttributedString *>*>*attributedSubstrings = [NSMutableArray array];
    
    for (NSValue *range in ranges) {
        !range.rangeValue.length ? : [attributedSubstrings addObject:@{range : [aStr attributedSubstringFromRange:range.rangeValue]}];
    }
    
    [aStr addAttributes:@{ NSForegroundColorAttributeName: color } range:NSMakeRange(0, aStr.length)];
    
    for (NSDictionary <NSValue *,NSAttributedString *>*attributedSubstring in attributedSubstrings) {
        [aStr replaceCharactersInRange:attributedSubstring.allKeys.firstObject.rangeValue
                  withAttributedString:attributedSubstring.allValues.firstObject];
    }
    self.attributedText = aStr;
}

/**
 *  设置label文字局部字体
 *  @param font 字体
 *  @param rang 范围
 */
- (void)replaceTextFont:(UIFont *)font inRang:(NSRange)rang {
    if (!self.attributedText.length || !font || !rang.length) {
        return;
    }
    NSRange r = NSMakeRange(0, self.attributedText.string.length);
    
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange intersectionRang = NSIntersectionRange(rang, r);
    [aStr addAttributes:@{ NSFontAttributeName: font } range:intersectionRang];
    
    self.attributedText = aStr;
    
}

/**
 *  设置label文字局部字体 && 颜色
 *  @param font  字体
 *  @param color 颜色
 *  @param rang  范围
 */
- (void)replaceTextFont:(UIFont *)font color:(UIColor *)color inRang:(NSRange)rang {
    [self replaceTextFont:font inRang:rang];
    [self replaceTextColor:color inRang:rang];
}

/**
 *  设置label文行距
 *  @param lineSpace  行距
 */
- (void)setLineSpace:(CGFloat)lineSpace {
    [self setLineSpace:lineSpace alignment:self.textAlignment inRang:NSMakeRange(0, self.attributedText.length)];
}

/**
 *  设置label文字局部行距
 *  @param lineSpace    行距
 *  @param rang         范围
 */
- (void)setLineSpace:(CGFloat)lineSpace inRang:(NSRange)rang {
    [self setLineSpace:lineSpace alignment:self.textAlignment inRang:rang];
}

/**
 *  设置label文字局部行距 && 对齐方式
 *  @param lineSpace    行距
 *  @param alignment    对齐方式
 *  @param rang         范围
 */
- (void)setLineSpace:(CGFloat)lineSpace alignment:(NSTextAlignment)alignment {
    [self setLineSpace:lineSpace alignment:alignment inRang:NSMakeRange(0, self.attributedText.length)];
}

/**
 *  设置label文字局部行距 && 对齐方式
 *  @param lineSpace    行距
 *  @param alignment    对齐方式
 *  @param rang         范围
 */
- (void)setLineSpace:(CGFloat)lineSpace alignment:(NSTextAlignment)alignment inRang:(NSRange)rang {
    
    NSAttributedString *aStr = [self.attributedText attributedStringByResetLineSpacing:lineSpace alignment:alignment range:rang];
    self.attributedText = aStr;
}

- (void)insertImage:(UIImage *)image atIndex:(NSUInteger)index bounds:(CGRect)bounds {
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    imageAttachment.image = image;
    imageAttachment.bounds = bounds;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSAttributedString* imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    [att insertAttributedString:imageAttributedString atIndex:index];
    self.attributedText = att;
}

@end
