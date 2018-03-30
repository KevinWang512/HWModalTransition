//
//  UIApplication+Category.h
//  HWExtension_Example
//
//  Created by wanghouwen on 2018/3/5.
//  Copyright © 2018年 wanghouwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (OpenURL)

- (void)hw_openURL:(NSURL * _Nullable)url options:(NSDictionary<NSString *, id> *_Nullable)options completionHandler:(void (^ _Nullable)(BOOL success))completion;

@end
