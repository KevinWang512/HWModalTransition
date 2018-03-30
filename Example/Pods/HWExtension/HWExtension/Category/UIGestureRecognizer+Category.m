//
//  UIGestureRecognizer+Category.m
//  HWExtension_Example
//
//  Created by wanghouwen on 2018/2/8.
//  Copyright © 2018年 wanghouwen. All rights reserved.
//

#import "UIGestureRecognizer+Category.h"
#import <objc/runtime.h>

@class HWUIGestureRecognizerTarget;

typedef void(^TargetDidHandleBlock)(HWUIGestureRecognizerTarget *target, __kindof UIGestureRecognizer *ges);

@interface HWUIGestureRecognizerTarget : NSObject
@property (nonatomic, copy) TargetDidHandleBlock handleBlock;      //
@end

@implementation HWUIGestureRecognizerTarget

+ (instancetype)targetWithsHandler:(TargetDidHandleBlock)handler {
    HWUIGestureRecognizerTarget *t = [[HWUIGestureRecognizerTarget alloc] init];
    t.handleBlock = handler;
    return t;
}

- (void)actionHandler:(UIGestureRecognizer *)ges {
    if (self.handleBlock) {
        self.handleBlock(self, ges);
    }
}

- (void)dealloc {
}

@end

@implementation UIGestureRecognizer (Block)

const void * _Nonnull HWUIGestureRecognizerHandlersKey = &HWUIGestureRecognizerHandlersKey;

+ (instancetype)gestureRecognizerWithHandler:(HWUIGestureRecognizerHandler)handler {
    UIGestureRecognizer *ges = [[[self class] alloc] init];
    [ges addGestureRecognizerHandler:handler];
    return ges;
}

- (void)addGestureRecognizerHandler:(HWUIGestureRecognizerHandler)handler {
    
    @synchronized (self) {
        
        if (handler) {
            
            NSMutableDictionary <HWUIGestureRecognizerHandler, HWUIGestureRecognizerTarget *>*handlers = objc_getAssociatedObject(self, HWUIGestureRecognizerHandlersKey);
            
            if (handlers == nil) {
                handlers = [NSMutableDictionary dictionary];
                objc_setAssociatedObject(self, HWUIGestureRecognizerHandlersKey, handlers, OBJC_ASSOCIATION_RETAIN);
            }
            
            HWUIGestureRecognizerTarget *target = handlers[(id)handler];
            if (target == nil) {
                target = [HWUIGestureRecognizerTarget targetWithsHandler:^(HWUIGestureRecognizerTarget *target, __kindof UIGestureRecognizer *ges) {
                    
                    NSDictionary <HWUIGestureRecognizerHandler, HWUIGestureRecognizerTarget *>*handlers_t = objc_getAssociatedObject(ges, HWUIGestureRecognizerHandlersKey);
                    
                    [handlers_t enumerateKeysAndObjectsUsingBlock:^(HWUIGestureRecognizerHandler  _Nonnull key, HWUIGestureRecognizerTarget * _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([obj isEqual:target]) {
                            key(ges);
                            *stop = YES;
                        }
                    }];
                }];
                handlers[(id)handler] = target;
            }
            [self addTarget:target action:@selector(actionHandler:)];
        }
    }
}

// 移除handler, 如果 handler == nil, 所有已添加的handler将被移除
- (void)removeGestureRecognizerHandler:(HWUIGestureRecognizerHandler)handler {
    
    @synchronized (self) {
        
        NSMutableDictionary <HWUIGestureRecognizerHandler, HWUIGestureRecognizerTarget *>*handlers = objc_getAssociatedObject(self, HWUIGestureRecognizerHandlersKey);
        
        if (handlers && handlers.count) {
            if (handler) {
                HWUIGestureRecognizerTarget *target = handlers[(id)handler];
                if (target) {
                    [self removeTarget:target action:@selector(actionHandler:)];
                    [handlers removeObjectForKey:handler];
                }
            } else {
                __weak typeof(self) ws = self;
                [handlers enumerateKeysAndObjectsUsingBlock:^(HWUIGestureRecognizerHandler  _Nonnull key, HWUIGestureRecognizerTarget * _Nonnull obj, BOOL * _Nonnull stop) {
                    __strong typeof(ws) ss = ws;
                    [ss removeTarget:obj action:@selector(actionHandler:)];
                }];
                [handlers removeAllObjects];
            }
        }
    }
}

@end
