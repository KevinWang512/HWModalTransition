//
//  UIColor+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/11/29.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

// e.g. black - 0x000000, white - 0xffffff
+ (UIColor *)colorWithHex:(NSInteger)hex;
+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

// e.g. black - #000000, white - #ffffff
+ (UIColor *)colorWithHexString:(NSString *)hex;
+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha;

@end
