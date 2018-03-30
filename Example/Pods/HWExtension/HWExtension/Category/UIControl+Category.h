//
//  UIControl+Category.h
//  HWExtension
//
//  Created by wanghouwen on 2018/1/7.
//  Copyright © 2018年 wanghouwen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HWUIControlEventsHandler)(__kindof UIControl *sender);

@interface UIControl (Block)

// handler 接收 events
- (void)addEventsHandlerForControlEvents:(UIControlEvents)events handler:(HWUIControlEventsHandler)handler;

// handler 不接收指定的events, 如果 handler == nil, 所有已添加的handler将不接收指定的events
- (void)removeEventsForHandler:(HWUIControlEventsHandler)handler events:(UIControlEvents)events;

@end
