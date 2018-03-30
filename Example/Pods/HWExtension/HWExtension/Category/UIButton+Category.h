//
//  UIButton+Category.h
//  HWExtension
//
//  Created by houwen.wang on 16/6/6.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "NSObject+Category.h"
#import "UIImage+Category.h"

@interface UIButton (Category)

// 使用系统的 titleEdgeInsets、imageEdgeInsets 计算太繁琐，可用以下两个属性设置
@property (nonatomic, assign) CGRect titleRect;  // titleLabel 的位置 （相对于self坐标系）
@property (nonatomic, assign) CGRect imageRect;  // image 的位置（相对于self坐标系）

// 跳转的URL,按钮点击时并不会open url，调用者在按钮回调中可获取到按钮的lingURL属性，调用者自己处理点事件
@property (nonatomic, copy) NSString *linkURL;

@end

@interface UIButton (Utils)

/**
 *  textColor == nil 时, 颜色为 blackColor, type 默认为 UIButtonTypeCustom
 */

#pragma mark - 最常用的

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor;

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                         frame:(CGRect)frame;

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage;

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
                         frame:(CGRect)frame;

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor;

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                         frame:(CGRect)frame;

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage;

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
                         frame:(CGRect)frame;

#pragma mark - text

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage;

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor;

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage;

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage;

+ (instancetype)buttonWithText:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor;

#pragma mark - type / text

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage;

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor;

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage;

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage;

+ (instancetype)buttonWithType:(UIButtonType)type
                          text:(NSString *)text
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor;

#pragma mark - statesText

+ (instancetype)buttonWithStatesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                                font:(UIFont *)font
                     statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
               statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage;

+ (instancetype)buttonWithStatesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                                font:(UIFont *)font
                     statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
               statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor;

+ (instancetype)buttonWithStatesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                                font:(UIFont *)font
                     statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                         statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage;

+ (instancetype)buttonWithStatesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                                font:(UIFont *)font
                     statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                         statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
               statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage;

+ (instancetype)buttonWithStatesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                                font:(UIFont *)font
                     statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                         statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
               statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor;

#pragma mark - type / statesText

+ (instancetype)buttonWithType:(UIButtonType)type
                    statesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage;

+ (instancetype)buttonWithType:(UIButtonType)type
                    statesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor;

+ (instancetype)buttonWithType:(UIButtonType)type
                    statesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage;

+ (instancetype)buttonWithType:(UIButtonType)type
                    statesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundImage:(NSDictionary <NSNumber *, UIImage *>*)statesBackgroundImage;

+ (instancetype)buttonWithType:(UIButtonType)type
                    statesText:(NSDictionary <NSNumber *, NSString *>*)statesText
                          font:(UIFont *)font
               statesTextColor:(NSDictionary <NSNumber *, UIColor *>*)statesTextColor
                   statesImage:(NSDictionary <NSNumber *, UIImage *>*)statesImage
         statesBackgroundColor:(NSDictionary <NSNumber *, UIColor *>*)statesBackgroundColor;

@end

