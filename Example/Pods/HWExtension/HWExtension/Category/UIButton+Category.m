//
//  UIButton+Category.m
//  HWExtension
//
//  Created by houwen.wang on 16/6/6.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UIButton+Category.h"

@interface UIButton ()

@property (assign, nonatomic) BOOL alreadySetTitleRect;     // 是否已设置过这个属性
@property (assign, nonatomic) BOOL alreadySetImageRect;     // 是否已设置过这个属性

@end

@implementation UIButton (Category)

+ (void) load {
    [self exchangeImplementations:@selector(titleRectForContentRect:) otherMethod:@selector(hw_titleRectForContentRect:) isInstance:YES];
    [self exchangeImplementations:@selector(imageRectForContentRect:) otherMethod:@selector(hw_imageRectForContentRect:) isInstance:YES];
}

- (CGRect) hw_titleRectForContentRect:(CGRect)contentRect {
    if (!self.alreadySetTitleRect) {
        return [self hw_titleRectForContentRect:contentRect];
    }
    return self.titleRect;
}

- (CGRect)hw_imageRectForContentRect:(CGRect)contentRect {
    if (!self.alreadySetImageRect) {
        return [self hw_imageRectForContentRect:contentRect];
    }
    return self.imageRect;
}

- (NSString *)linkURL {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLinkURL:(NSString *)linkURL {
    objc_setAssociatedObject(self, @selector(linkURL), linkURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)alreadySetTitleRect {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setAlreadySetTitleRect:(BOOL)alreadySetTitleRect {
    objc_setAssociatedObject(self, @selector(alreadySetTitleRect), @(alreadySetTitleRect), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)alreadySetImageRect {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setAlreadySetImageRect:(BOOL)alreadySetImageRect {
    objc_setAssociatedObject(self, @selector(alreadySetImageRect), @(alreadySetImageRect), OBJC_ASSOCIATION_ASSIGN);
}

- (CGRect) titleRect {
    return [objc_getAssociatedObject(self, _cmd) CGRectValue];
}

- (void) setTitleRect:(CGRect)titleRect {
    self.alreadySetTitleRect = YES;
    objc_setAssociatedObject(self, @selector(titleRect), [NSValue valueWithCGRect:titleRect], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsLayout];
    [self setNeedsUpdateConstraints]; // iOS 8 以前必须加上这句
}

- (CGRect) imageRect {
    return [objc_getAssociatedObject(self, _cmd) CGRectValue];
}

- (void) setImageRect:(CGRect)imageRect {
    self.alreadySetImageRect = YES;
    objc_setAssociatedObject(self, @selector(imageRect), [NSValue valueWithCGRect:imageRect], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsLayout];
    [self setNeedsUpdateConstraints]; // iOS 8 以前必须加上这句
}

@end

@implementation UIButton (Utils)

#pragma mark - 最常用的

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:[self handlerColor:textColor]
                     statesImage:nil
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                         frame:(CGRect)frame {
    
    return [self buttonWithFrame:frame
                            type:type
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:[self handlerColor:textColor]
                     statesImage:nil
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:[self handlerColor:textColor]
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
                         frame:(CGRect)frame {
    
    return [self buttonWithFrame:frame
                            type:type
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:[self handlerColor:textColor]
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:[self handlerColor:textColor]
                     statesImage:nil
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                         frame:(CGRect)frame {
    
    return [self buttonWithFrame:frame
                            type:UIButtonTypeCustom
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:[self handlerColor:textColor]
                     statesImage:nil
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:[self handlerColor:textColor]
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
                         frame:(CGRect)frame {
    
    return [self buttonWithFrame:frame
                            type:UIButtonTypeCustom
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:[self handlerColor:textColor]
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

#pragma mark - text

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:statesTextColor
                     statesImage:nil
           statesBackgroundImage:statesBackgroundImage
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:statesTextColor
                     statesImage:nil
           statesBackgroundImage:nil
           statesBackgroundColor:statesBackgroundColor];
}

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:statesBackgroundImage
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:statesBackgroundColor];
}

#pragma mark - type / text

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:statesTextColor
                     statesImage:nil
           statesBackgroundImage:statesBackgroundImage
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:statesTextColor
                     statesImage:nil
           statesBackgroundImage:nil
           statesBackgroundColor:statesBackgroundColor];
}

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:statesBackgroundImage
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:[self handlerText:text]
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:statesBackgroundColor];
}

#pragma mark - statesText

+ (instancetype)buttonWithStatesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                                font:(UIFont *)font
                     statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
               statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:statesText
                 statesTextColor:statesTextColor
                     statesImage:nil
           statesBackgroundImage:statesBackgroundImage
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithStatesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                                font:(UIFont *)font
                     statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
               statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:statesText
                 statesTextColor:statesTextColor
                     statesImage:nil
           statesBackgroundImage:nil
           statesBackgroundColor:statesBackgroundColor];
}

+ (instancetype)buttonWithStatesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                                font:(UIFont *)font
                     statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                         statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:statesText
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithStatesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                                font:(UIFont *)font
                     statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                         statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
               statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:statesText
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:statesBackgroundImage
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithStatesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                                font:(UIFont *)font
                     statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                         statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
               statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor {
    
    return [self buttonWithFrame:CGRectZero
                            type:UIButtonTypeCustom
                            font:font
                      statesText:statesText
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:statesBackgroundColor];
}

#pragma mark - type / statesText

+ (instancetype)buttonWithType:(UIButtonType)type
                    statesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:statesText
                 statesTextColor:statesTextColor
                     statesImage:nil
           statesBackgroundImage:statesBackgroundImage
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithType:(UIButtonType)type
                    statesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:statesText
                 statesTextColor:statesTextColor
                     statesImage:nil
           statesBackgroundImage:nil
           statesBackgroundColor:statesBackgroundColor];
}

+ (instancetype)buttonWithType:(UIButtonType)type
                    statesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:statesText
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithType:(UIButtonType)type
                    statesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:statesText
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:statesBackgroundImage
           statesBackgroundColor:nil];
}

+ (instancetype)buttonWithType:(UIButtonType)type
                    statesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor {
    
    return [self buttonWithFrame:CGRectZero
                            type:type
                            font:font
                      statesText:statesText
                 statesTextColor:statesTextColor
                     statesImage:statesImage
           statesBackgroundImage:nil
           statesBackgroundColor:statesBackgroundColor];
}

#pragma mark - private

+ (instancetype)buttonWithFrame:(CGRect)frame
                           type:(UIButtonType)type
                           font:(UIFont *)font
                     statesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                    statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
          statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage
          statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor {
    
    UIButton *btn = [[self class] buttonWithType:type];
    btn.frame = frame;
    btn.titleLabel.font = font;
    
    for (NSNumber *state in statesText.allKeys) {
        [btn setTitle:statesText[state] forState:state.integerValue];
    }
    
    for (NSNumber *state in statesTextColor.allKeys) {
        [btn setTitleColor:statesTextColor[state] forState:state.integerValue];
    }
    
    for (NSNumber *state in statesImage.allKeys) {
        [btn setImage:statesImage[state] forState:state.integerValue];
    }
    
    for (NSNumber *state in statesBackgroundColor.allKeys) {
        [btn setBackgroundImage:[UIImage imageWithColor:statesBackgroundColor[state]] forState:state.integerValue];
    }
    
    for (NSNumber *state in statesBackgroundImage.allKeys) {
        [btn setBackgroundImage:statesBackgroundImage[state] forState:state.integerValue];
    }
    
    return btn;
}

+ (NSDictionary <NSNumber *, NSString *>*)handlerText:(NSString *)text {
    NSString *newText = text ? text : @"";
    return @{@(UIControlStateNormal) : newText};
}

+ (NSDictionary <NSNumber *, UIColor *>*)handlerColor:(UIColor *)color {
    UIColor *newColor = color ? color : [UIColor blackColor];
    return @{@(UIControlStateNormal) : newColor};
}

@end

