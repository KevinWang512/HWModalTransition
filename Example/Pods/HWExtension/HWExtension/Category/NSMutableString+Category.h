//
//  NSMutableString+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/3/27.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (Category)

- (void)add:(NSString *)str; // 追加

// 替换一组string
- (void)replaceOccurrencesOfStrings:(NSArray <NSString *>*)targets withStings:(NSString *)string;

@end
