//
//  UINavigationController+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/11/17.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UINavigationController+Category.h"

#if DEBUG
    #define AddMemoryMonitorForViewController(vc, isPop)    \
    {  \
        __weak typeof(vc) weakVC = vc;  \
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
            if (weakVC) \
            {   \
                NSLog(@"\n************************************************************************\n   \
                \n             %@ 内存未被释放！！！                                                     \
                \n             INFO : it did %@ but after 2s later it still hasn't been released \n   \
                \n************************************************************************\n          \
                ",NSStringFromClass([weakVC class]),isPop ? @"poped" : @"dismissed" );\
            }\
        });\
    }
#else
    #define AddMemoryMonitorForViewController(vc, isPop) {NSLog(@"%@,%@", vc, @(isPop));}
#endif

@implementation UINavigationController (Category)

+ (void) load {
    [self exchangeImplementations:@selector(popViewControllerAnimated:) otherMethod:@selector(hw_popViewControllerAnimated:) isInstance:YES];
    [self exchangeImplementations:@selector(popToViewController:animated:) otherMethod:@selector(hw_popToViewController:animated:) isInstance:YES];
    [self exchangeImplementations:@selector(popToRootViewControllerAnimated:) otherMethod:@selector(hw_popToRootViewControllerAnimated:) isInstance:YES];
}

- (UIViewController *)hw_popViewControllerAnimated:(BOOL)animated {
    UIViewController *popped = [self hw_popViewControllerAnimated:animated];
    AddMemoryMonitorForViewController(popped, YES);
    return popped;
}

- (NSArray<UIViewController *> *)hw_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *popedControllers = [self hw_popToViewController:viewController animated:YES];
    for (UIViewController *popped in popedControllers) {
        AddMemoryMonitorForViewController(popped, YES);
    }
    return popedControllers;
}

- (NSArray<UIViewController *> *)hw_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *popedControllers = [self hw_popToRootViewControllerAnimated:animated];
    for (UIViewController *popped in popedControllers) {
        AddMemoryMonitorForViewController(popped, YES);
    }
    return popedControllers;
}

// 管理视图控制器的栈长度
- (NSUInteger)stackLength {
    return self.viewControllers.count;
}

// pop 到指定 identifier 的视图控制器
// return : poped ViewControllers
- (NSArray<UIViewController *> *)popToViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated {
    for (UIViewController *vc in self.viewControllers) {
        if ([vc.restorationIdentifier isEqualToString:identifier]) {
            return [self popToViewController:vc animated:animated];
        }
    }
    return nil;
}

// pop 到堆栈的第几个控制器
// index : 下标，从0开始
// direction :方向,从self.viewControllers[0] -> self.viewControllers[stackLength - 1] 为正向
// animated : 是否使用动画效果
// return : poped ViewControllers
- (NSArray<UIViewController *> *)popToViewControllerAtStackIndex:(NSUInteger)index
                                                       direction:(HWPopSearchDirection)direction
                                                        animated:(BOOL)animated {
    if (self.stackLength >= index) {
        if (direction == HWPopSearchDirectionPositive) {
            return [self popToViewController:self.viewControllers[index] animated:animated];
        } else {
            return [self popToViewController:self.viewControllers[self.stackLength - index - 1] animated:animated];
        }
    } else {
        return nil;
    }
}

@end
