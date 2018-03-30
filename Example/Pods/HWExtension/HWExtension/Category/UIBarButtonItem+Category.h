//
//  UIBarButtonItem+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/10/17.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIBarButtonItem (Category)

#pragma mark - 类方法

+ (instancetype)barButtonItemWithImageName:(NSString *)imageName actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler;

+ (instancetype)barButtonItemWithTitle:(NSString *)title actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler;

+ (instancetype)barButtonItemWithTitle:(NSString *)title statesColor:(NSDictionary <NSNumber *, UIColor *>*)statesColor actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler;

#pragma mark - 实例方法

- (instancetype)initWithImageName:(NSString *)imageName actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler;

- (instancetype)initWithTitle:(NSString *)title actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler;

- (instancetype)initWithTitle:(NSString *)title statesColor:(NSDictionary <NSNumber *, UIColor *>*)statesColor actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler;

@end

