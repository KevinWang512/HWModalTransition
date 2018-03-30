//
//  UIImageView+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/11/10.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Aspect)

// 等比例缩放
- (CGSize)aspectScaleToFitSize:(CGSize)size;

@end

@interface UIImageView (Category)

// 等比例缩放
- (CGSize)aspectScaleToFitSize:(CGSize)size;

@end
