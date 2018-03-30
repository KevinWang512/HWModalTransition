//
//  UIViewController+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/11/17.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "NSObject+Category.h"

NS_ASSUME_NONNULL_BEGIN

// 用于 pop 返回时 identifier 的前缀
extern const NSString *HWPopBackIdentifierPrefix;

@interface UIViewController (Category)

// 标识符
@property (nonatomic, copy) NSString *identifier;  //

// 是否处于navigationController栈中
@property (nonatomic, assign, readonly) BOOL includedInNavigationController;  //

// 是否是navigationController的RootViewController
@property (nonatomic, assign, readonly) BOOL isNavigationRootViewController;  //

// navigationController栈深度
@property (nonatomic, assign, readonly) NSUInteger navigationControllerStackLength;  //

@end

NS_ASSUME_NONNULL_END
