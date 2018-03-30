//
//  UIBarButtonItem+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/10/17.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UIBarButtonItem+Category.h"

@interface UIBarButtonItem ()

@property (nonatomic, copy) void (^actionHandler)(UIBarButtonItem *item, UIButton *customView);    //

@end

@implementation UIBarButtonItem (Category)

#pragma mark - 类方法

// image
+ (instancetype)barButtonItemWithImageName:(NSString *)imageName actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler {
    
    return [[self alloc] initWithImageName:imageName actionHandler:actionHandler];
}

+ (instancetype)barButtonItemWithTitle:(NSString *)title actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler {
    
    return [self barButtonItemWithTitle:title statesColor:nil actionHandler:actionHandler];
}

+ (instancetype)barButtonItemWithTitle:(NSString *)title statesColor:(NSDictionary <NSNumber *, UIColor *>*)statesColor actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler {
    
    return [[self alloc] initWithTitle:title statesColor:statesColor actionHandler:actionHandler];
}

#pragma mark - 实例方法

- (instancetype)initWithImageName:(NSString *)imageName actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler {
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:image forState:UIControlStateNormal];
    
    btn.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self = [self initWithCustomView:btn];
    self.actionHandler = actionHandler;
    return self;
}

- (instancetype)initWithTitle:(NSString *)title actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler {
    return [self initWithTitle:title statesColor:nil actionHandler:actionHandler];
}

- (instancetype)initWithTitle:(NSString *)title statesColor:(NSDictionary <NSNumber *, UIColor *>*)statesColor actionHandler:(void (^)(UIBarButtonItem *item, UIButton *customView))actionHandler {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    
    // 默认白色
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    // 用户自定义颜色
    for (NSNumber *key in statesColor.allKeys) {
        [btn setTitleColor:statesColor[key] forState:key.integerValue];
    }
    
    [btn sizeToFit];
    [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self = [self initWithCustomView:btn]) {
        self.actionHandler = actionHandler;
    }
    
    return self;
}

#pragma mark - private methods

- (void)setActionHandler:(void (^)(UIBarButtonItem *))actionHandler {
    objc_setAssociatedObject(self, @selector(actionHandler), actionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIBarButtonItem *))actionHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)itemClicked:(UIBarButtonItem *)sender {
    if (self.actionHandler) {
        self.actionHandler(self, self.customView);
    }
}

@end

