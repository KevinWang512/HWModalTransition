//
//  UITableViewCell+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/6/7.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UITableViewCell (Utils)

@property (nonatomic, strong) id userInfo;  //

+ (instancetype)defaultStyleCellWithReuseIdentifier:(NSString *)reuseIdentifier;

+ (instancetype)value1StyleCellWithReuseIdentifier:(NSString *)reuseIdentifier;

+ (instancetype)value2StyleCellWithReuseIdentifier:(NSString *)reuseIdentifier;

+ (instancetype)subtitleStyleCellWithReuseIdentifier:(NSString *)reuseIdentifier;

- (UIView *)separatorView; // cell自带的分割线

@end
