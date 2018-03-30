//
//  UIGestureRecognizer+Category.h
//  HWExtension_Example
//
//  Created by wanghouwen on 2018/2/8.
//  Copyright © 2018年 wanghouwen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HWUIGestureRecognizerHandler)(__kindof UIGestureRecognizer *ges);

@interface UIGestureRecognizer (Block)

+ (instancetype)gestureRecognizerWithHandler:(HWUIGestureRecognizerHandler)handler;

- (void)addGestureRecognizerHandler:(HWUIGestureRecognizerHandler)handler;

// 移除handler, 如果 handler == nil, 所有已添加的handler将被移除
- (void)removeGestureRecognizerHandler:(HWUIGestureRecognizerHandler)handler;

@end
