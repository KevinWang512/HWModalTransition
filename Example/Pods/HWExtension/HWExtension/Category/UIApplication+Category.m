//
//  UIApplication+Category.m
//  HWExtension_Example
//
//  Created by wanghouwen on 2018/3/5.
//  Copyright © 2018年 wanghouwen. All rights reserved.
//

#import "UIApplication+Category.h"

@implementation UIApplication (OpenURL)

- (void)hw_openURL:(NSURL * _Nullable)url options:(NSDictionary<NSString *, id> *_Nullable)options completionHandler:(void (^ _Nullable)(BOOL success))completion {
    
    if ([self respondsToSelector:@selector(openURL:options:completionHandler:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
        [self openURL:url options:options completionHandler:completion];
#pragma clang pop
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self openURL:url];
#pragma clang pop
    }
}

@end
