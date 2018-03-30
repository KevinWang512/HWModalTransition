//
//  UIViewController+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/11/17.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UIViewController+Category.h"

const NSString *HWPopBackIdentifierPrefix = @"pop_back_identifier_from_";

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

@implementation UIViewController (Category)

+ (void) load {
    [self exchangeImplementations:@selector(dismissViewControllerAnimated:completion:)
                      otherMethod:@selector(hw_dismissViewControllerAnimated:completion:)
                       isInstance:YES];
}

- (void)hw_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self hw_dismissViewControllerAnimated:flag completion:completion];
    AddMemoryMonitorForViewController(self, NO);
}

// 是否处于navigationController栈中
- (BOOL) includedInNavigationController {
    return self.navigationController ? YES : NO;
}

// 是否是navigationController的RootViewController
- (BOOL) isNavigationRootViewController {
    if ([self includedInNavigationController]) {
        return [self.navigationController.viewControllers[0] isEqual:self] ? YES : NO;
    }
    return NO;
}

// navigationController栈深度
- (NSUInteger)navigationControllerStackLength {
    if ([self includedInNavigationController]) {
        return self.navigationController.viewControllers.count;
    }
    return 0;
}

- (NSString *)identifier {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, @selector(identifier), identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
