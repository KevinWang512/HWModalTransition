//
//  UIGraphics+Extension.m
//  HWExtension
//
//  Created by houwen.wang on 2016/11/29.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UIGraphics+Extension.h"

UIKIT_EXTERN UIImage * _Nullable beginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale, void(^_Nullable rendering)(CGContextRef __nonnull ctx)) {
    
    // begin
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (ctx == nil) {
        UIGraphicsEndImageContext();
        return nil;
    }
    
    // push
    CGContextSaveGState(ctx);
    
//    CGContextTranslateCTM(ctx, 0.0f, size.height);
//    CGContextScaleCTM(ctx, 1.0, -1.0);
    if (rendering) {
        rendering(ctx);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // pop
    CGContextRestoreGState(ctx);
    
    // end
    UIGraphicsEndImageContext();
    return image;
}
