//
//  UIGraphics+Extension.h
//  HWExtension
//
//  Created by houwen.wang on 2016/11/29.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN UIImage * _Nullable beginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale, void(^_Nullable rendering)(CGContextRef __nonnull ctx));

NS_ASSUME_NONNULL_END
