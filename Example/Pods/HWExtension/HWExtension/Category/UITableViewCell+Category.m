//
//  UITableViewCell+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/6/7.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UITableViewCell+Category.h"

@implementation UITableViewCell (Utils)

- (id)userInfo {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUserInfo:(id)userInfo {
    objc_setAssociatedObject(self, @selector(userInfo), userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (instancetype)defaultStyleCellWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

+ (instancetype)value1StyleCellWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

+ (instancetype)value2StyleCellWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [[self alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}

+ (instancetype)subtitleStyleCellWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

- (UIView *)separatorView {
    for (UIView *v in self.subviews) {
        if ([NSStringFromClass([v class]) isEqualToString:@"_UITableViewCellSeparatorView"]) {
            return v;
        }
    }
    return nil;
}

@end
