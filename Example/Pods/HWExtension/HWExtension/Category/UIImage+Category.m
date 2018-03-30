//
//  UIImage+Category.m
//  HWExtension
//
//  Created by houwen.wang on 16/5/24.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

+ (void)load {
    Method sysMethod = class_getClassMethod([self class], @selector(imageNamed:));
    Method customMethod = class_getClassMethod([self class], @selector(hw_imageNamed:));
    method_exchangeImplementations(sysMethod, customMethod);
}

+ (UIImage *)hw_imageNamed:(NSString *)name {
    UIImage *image = [UIImage hw_imageNamed:name];
    if (!image) {
        NSLog(@"%@ image load failed", name);
    }
    return image;
}

// 修改图片大小
- (UIImage *)reSizeToSize:(CGSize)reSize {
    __weak typeof(self) ws = self;
    return beginImageContextWithOptions(CGSizeMake(reSize.width, reSize.height), NO, 0.0f, ^(CGContextRef ctx) {
        __strong typeof(ws) ss = ws;
        [ss drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    });
}

// 修改图片方向
- (UIImage *)fixedOrientationImage {
    
    if (self.imageOrientation == UIImageOrientationUp || self == nil) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             self.size.width,
                                             self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage),
                                             0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    if (ctx == NULL) return nil;
    
    CGContextConcatCTM(ctx, transform);
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

@end

@interface HWGIFItem ()
@property (nonatomic, strong) NSDictionary *gifDictionary;    //
@property (nonatomic, strong) UIImage *image;                 //
@property (nonatomic, assign) CGFloat delayTime;              //

+ (instancetype)itemWithDictionary:(NSDictionary *)dic image:(UIImage *)image delayTime:(CGFloat)delayTime;

@end

@implementation HWGIFItem

+ (instancetype)itemWithDictionary:(NSDictionary *)dic image:(UIImage *)image delayTime:(CGFloat)delayTime {
    HWGIFItem *item = [[self alloc] init];
    item.gifDictionary = dic;
    item.image = image;
    item.delayTime = delayTime;
    return item;
}

@end

@implementation UIImage (GIF)

//  解析gif数据
+ (NSArray <HWGIFItem *>*)gitItemsWithGIFData:(NSData *)data {

    if (data == nil) {
        return @[];
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray <HWGIFItem *>*items = [NSMutableArray arrayWithCapacity:count];
    
    for (size_t i = 0; i < count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage *image      = [UIImage imageWithCGImage:imageRef];
        
        //获取图片信息
        NSDictionary *info    = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        NSDictionary *gifDict = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        if (gifDict) {
            CGFloat delayTime = [[gifDict objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
            [items addObject:[HWGIFItem itemWithDictionary:gifDict image:image delayTime:delayTime]];
        }
        CGImageRelease(imageRef);
    }
    free(source);
    return items;
}

//  遍历gif图片
+ (void)enumerateGifItemsWithGIFData:(NSData *)data usingBlock:(void (^)(HWGIFItem *item, NSUInteger index, NSUInteger cout, BOOL *stop))block {
    NSArray <HWGIFItem *>*items = [self gitItemsWithGIFData:data];
    BOOL stop = NO;
    for (HWGIFItem *item in items) {
        block(item, [items indexOfObject:item], items.count, &stop);
        if (stop) break;
    }
}

@end

@implementation UIImage (UIColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    return beginImageContextWithOptions(rect.size, NO, 0.0f, ^(CGContextRef ctx) {
        CGContextSetFillColorWithColor(ctx, [color CGColor]);
        CGContextFillRect(ctx, rect);
    });
}

@end

@implementation UIImage (Graphics)

- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius {
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    __weak typeof(self) ws = self;
    
    return beginImageContextWithOptions(rect.size, NO, 0.0f, ^(CGContextRef ctx) {
        
        __strong typeof(ws) ss = ws;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        CGContextAddPath(ctx, path.CGPath);
        CGContextClip(ctx);
        CGContextDrawImage(ctx, rect, ss.CGImage);
    });
}

+ (UIImage *)imageWithSpacingFromImages:(NSArray <UIImage *>*)images spacing:(CGFloat)spacing {
    
    if (images == nil || images.count == 0) return nil;
    
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    for (UIImage *im in images) {
        width += im.size.width;
        height = MAX(height, im.size.height);
    }
    CGRect rect = CGRectMake(0, 0, width + spacing * (images.count - 1), height);
    return beginImageContextWithOptions(rect.size, NO, 0.0f, ^(CGContextRef ctx) {
        CGFloat left = 0.0f;
        for (UIImage *im in images) {
            CGContextDrawImage(ctx, CGRectMake(left, 0.0f, im.size.width, im.size.height), im.CGImage);
            left += im.size.width + spacing;
        }
    });
}

+ (UIImage *)imageOverlyingFromImages:(NSArray <NSDictionary <NSNumber *, UIImage *>*>*)attributedImages {
    
    if (attributedImages == nil || attributedImages.count == 0) return nil;
    
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    for (NSDictionary <NSNumber *, UIImage *>*attributedIm in attributedImages) {
        UIImage *im = attributedIm.allValues.firstObject;
        width = MAX(width, im.size.width);
        height = MAX(height, im.size.height);
    }
    CGRect rect = CGRectMake(0, 0, width, height);
    
    return beginImageContextWithOptions(rect.size, NO, 0.0f, ^(CGContextRef ctx) {
        for (NSDictionary <NSNumber *, UIImage *>*attributedIm in attributedImages) {
            UIImage *im = attributedIm.allValues.firstObject;
            CGFloat alpha = attributedIm.allKeys.firstObject.floatValue;
            CGContextSetAlpha(ctx, alpha);
            CGContextDrawImage(ctx, rect, im.CGImage);
        }
    });
}

@end
