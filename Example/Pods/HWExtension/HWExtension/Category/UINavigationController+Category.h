//
//  UINavigationController+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/11/17.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Category.h"

typedef NS_ENUM(NSUInteger, HWPopSearchDirection) {
    HWPopSearchDirectionPositive,   // 正向
    HWPopSearchDirectionNegative,   // 逆向
};

@interface UINavigationController (Category)

@property (nonatomic, assign, readonly) NSUInteger stackLength;  // 管理视图控制器的栈长度

// pop 到指定 identifier 的视图控制器
// return : poped ViewControllers
- (NSArray<UIViewController *> *)popToViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated;

// pop 到堆栈的第几个控制器
// index：下标，从0开始
// direction：方向, 从self.viewControllers[0] -> self.viewControllers[stackLength - 1] 为正向
// animated:是否使用动画效果
// return : poped ViewControllers
- (NSArray<UIViewController *> *)popToViewControllerAtStackIndex:(NSUInteger)index
                                                       direction:(HWPopSearchDirection)direction
                                                        animated:(BOOL)animated;

@end
