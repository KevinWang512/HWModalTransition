//
//  UIColor+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/11/29.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UIColor+Category.h"
#import "UIGraphics+Extension.h"

@implementation UIColor (Category)

+ (UIColor *)colorWithHex:(NSInteger)hex {
    return [UIColor colorWithHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hex {
    return [UIColor colorWithHexString:hex alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha {
    
    __block UIColor *color = [UIColor clearColor];
    
    if (hex && hex.length) {
        
        NSString *htmlStr = [NSString stringWithFormat:@"<font color=\"%@\">t</font>", hex];
        
        NSDictionary *option = @{NSDocumentTypeDocumentOption : NSHTMLTextDocumentType,
                                 NSCharacterEncodingDocumentOption : @(NSUTF8StringEncoding)};
        
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:option
                                                           documentAttributes:nil
                                                                        error:NULL];
        
        [attStr enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, 1) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            if (value && [value isKindOfClass:[UIColor class]]) {
                color = value;
            }
            *stop = YES;
        }];
    }
    return color;
}

@end
