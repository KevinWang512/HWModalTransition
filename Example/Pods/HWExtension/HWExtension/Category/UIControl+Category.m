//
//  UIControl+Category.m
//  HWExtension
//
//  Created by wanghouwen on 2018/1/7.
//  Copyright © 2018年 wanghouwen. All rights reserved.
//

#import "UIControl+Category.h"
#import <objc/runtime.h>
#import "NSObject+Category.h"

@class HWUIControlActionTarget;

typedef void(^TargetDidHandleEventsBlock)(HWUIControlActionTarget *target, __kindof UIControl *sender);

@interface HWUIControlActionTarget : NSObject
@property (nonatomic, assign) UIControlEvents events;                          // handled events
@property (nonatomic, copy) TargetDidHandleEventsBlock handleEventsBlock;      //
@end

@implementation HWUIControlActionTarget

+ (instancetype)targetWithEventsHandler:(TargetDidHandleEventsBlock)handler {
    HWUIControlActionTarget *t = [[HWUIControlActionTarget alloc] init];
    t.handleEventsBlock = handler;
    return t;
}

- (void)actionHandler:(id)sender {
    if (self.handleEventsBlock) {
        self.handleEventsBlock(self, sender);
    }
}

- (void)dealloc {
}

@end

@implementation UIControl (Block)

const void * _Nonnull HWUIControlEventsHandlersKey = &HWUIControlEventsHandlersKey;

// handler 接收 events
- (void)addEventsHandlerForControlEvents:(UIControlEvents)events handler:(HWUIControlEventsHandler)handler {
    
    @synchronized (self) {
        
        if (handler) {
            
            NSMutableDictionary <HWUIControlEventsHandler, HWUIControlActionTarget *>*handlers = objc_getAssociatedObject(self, HWUIControlEventsHandlersKey);
            
            if (handlers == nil) {
                handlers = [NSMutableDictionary dictionary];
                objc_setAssociatedObject(self, HWUIControlEventsHandlersKey, handlers, OBJC_ASSOCIATION_RETAIN);
            }
            
            HWUIControlActionTarget *target = handlers[(id)handler];
            if (target == nil) {
                target = [HWUIControlActionTarget targetWithEventsHandler:^(HWUIControlActionTarget *target, __kindof UIControl *sender) {
                    
                    NSDictionary <HWUIControlEventsHandler, HWUIControlActionTarget *>*handlers_t = objc_getAssociatedObject(sender, HWUIControlEventsHandlersKey);
                    
                    [handlers_t enumerateKeysAndObjectsUsingBlock:^(HWUIControlEventsHandler _Nonnull key, HWUIControlActionTarget * _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([obj isEqual:target]) {
                            key(sender);
                            *stop = YES;
                        }
                    }];
                }];
                handlers[(id)handler] = target;
            }
            target.events = target.events | events;
            [self addTarget:target action:@selector(actionHandler:) forControlEvents:events];
        }
    }
}

// handler 不接收指定的events, 如果 handler == nil, 所有已添加的handler将不接收指定的events
- (void)removeEventsForHandler:(HWUIControlEventsHandler)handler events:(UIControlEvents)events {
    
    @synchronized (self) {
        
        NSMutableDictionary <HWUIControlEventsHandler, HWUIControlActionTarget *>*handlers = objc_getAssociatedObject(self, HWUIControlEventsHandlersKey);
        
        if (handlers && handlers.count) {
            if (handler) {
                HWUIControlActionTarget *target = handlers[(id)handler];
                if (target) {
                    target.events = (target.events & (~events));
                    [self removeTarget:target action:@selector(actionHandler:) forControlEvents:events];
                }
            } else {
                __weak typeof(self) ws = self;
                [handlers enumerateKeysAndObjectsUsingBlock:^(HWUIControlEventsHandler _Nonnull key, HWUIControlActionTarget * _Nonnull obj, BOOL * _Nonnull stop) {
                    __strong typeof(ws) ss = ws;
                    obj.events = (obj.events & (~events));
                    [ss removeTarget:obj action:@selector(actionHandler:) forControlEvents:events];
                }];
            }
            
            // remove none events target
            
            __block NSMutableArray <HWUIControlEventsHandler>*shouldRemovedHandlers = [NSMutableArray array];
            [handlers enumerateKeysAndObjectsUsingBlock:^(HWUIControlEventsHandler _Nonnull key, HWUIControlActionTarget * _Nonnull obj, BOOL * _Nonnull stop) {
                if (obj.events == 0) {
                    [shouldRemovedHandlers addObject:key];
                }
            }];
            [handlers removeObjectsForKeys:shouldRemovedHandlers];
        }
    }
}

@end
