//
//  NSMutableString+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/3/27.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "NSMutableString+Category.h"

@implementation NSMutableString (Category)

- (void)add:(NSString *)str {
    [self appendString:str ? str : @"" ];
}

// 替换一组string
- (void)replaceOccurrencesOfStrings:(NSArray <NSString *>*)targets withStings:(NSString *)string {
    if (targets && targets.count && string && string.length) {
        for (NSString *target in targets) {
            [self replaceOccurrencesOfString:target withString:string options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
        }
    }
}

@end
