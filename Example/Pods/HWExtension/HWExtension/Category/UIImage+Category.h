//
//  UIImage+Categorys.h
//  HWExtension
//
//  Created by houwen.wang on 16/5/24.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIGraphics+Extension.h"

@class HWGIFItem;

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)

// 修改图片大小
- (UIImage *)reSizeToSize:(CGSize)reSize;

// 修改图片方向
- (UIImage *)fixedOrientationImage;

@end

@interface UIImage (GIF)

//  解析gif数据
+ (NSArray <HWGIFItem *>*)gitItemsWithGIFData:(NSData *)data;

//  遍历gif图片
+ (void)enumerateGifItemsWithGIFData:(NSData *)data usingBlock:(void (^)(HWGIFItem *item, NSUInteger index, NSUInteger cout, BOOL *stop))block;

@end

@interface UIImage (UIColor)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

@interface UIImage (Graphics)

- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)imageWithSpacingFromImages:(NSArray <UIImage *>*)images spacing:(CGFloat)spacing;
+ (UIImage *)imageOverlyingFromImages:(NSArray <NSDictionary <NSNumber *, UIImage *>*>*)attributedImages;

@end

@interface HWGIFItem : NSObject

@property (nonatomic, strong, readonly) NSDictionary *gifDictionary;    //
@property (nonatomic, strong, readonly) UIImage *image;                 //
@property (nonatomic, assign, readonly) CGFloat delayTime;              //

@end

NS_ASSUME_NONNULL_END

