//
//  UITableView+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/12/19.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UITableView+Category.h"

@implementation UITableView (Utils)

+ (instancetype)plainStyleTableViewWithFrame:(CGRect)frame delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource {
    return [self tableViewWithFrame:frame style:UITableViewStylePlain delegate:delegate dataSource:dataSource];
}

+ (instancetype)groupedStyleTableViewWithFrame:(CGRect)frame delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource {
    return [self tableViewWithFrame:frame style:UITableViewStyleGrouped delegate:delegate dataSource:dataSource];
}

+ (instancetype)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource {
    UITableView *t = [[UITableView alloc] initWithFrame:frame style:style];
    t.delegate = delegate;
    t.dataSource = dataSource;
    return t;
}

/**
 *  @brief 获取重用cell
 *  @param identifier     重用id
 *  @param indexPath      for indexPath
 *  @param nilBlock       未从重用队列中获取到时调用
 *  @param initBlock      初始化block，最多只调用一次
 *  @return cell
 **/
- (nonnull __kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(nullable NSString *)identifier
                                                              indexPath:(NSIndexPath *)indexPath
                                                               nilBlock:(nonnull DequeueCellNilBlock)nilBlock
                                                              initBlock:(nullable CellInitBlock)initBlock {
    
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil && nilBlock) {
        cell = nilBlock(indexPath);
        if (cell && [cell isKindOfClass:[UITableViewCell class]]) {
            [cell setValue:identifier forKey:@"reuseIdentifier"];
        }
    }
    
    if (cell && initBlock) {
        BOOL didInitialize = [objc_getAssociatedObject(cell, _cmd) boolValue];
        if (!didInitialize) {
            initBlock(cell, indexPath);
            objc_setAssociatedObject(cell, _cmd, @(YES), OBJC_ASSOCIATION_ASSIGN);
        }
    }
    
    return cell;
}

/**
 *  @brief 获取重用headerFooter
 *  @param identifier           重用id
 *  @param section              for section
 *  @param nilBlock             未从重用队列中获取到时调用
 *  @param initBlock            初始化block，最多只调用一次
 *  @return headerFooter
 **/
- (nonnull __kindof UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithIdentifier:(nullable NSString *)identifier
                                                                                        section:(NSInteger)section
                                                                                       nilBlock:(nonnull DequeueHeaderFooterNilBlock)nilBlock
                                                                                      initBlock:(nullable HeaderFooterInitBlock)initBlock {
    
    UITableViewHeaderFooterView *headerFooter = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (headerFooter == nil && initBlock) {
        headerFooter = nilBlock(section);
        if (headerFooter && [headerFooter isKindOfClass:[UITableViewHeaderFooterView class]]) {
            [headerFooter setValue:identifier forKey:@"reuseIdentifier"];
        }
    }
    
    if (headerFooter && initBlock) {
        BOOL didInitialize = [objc_getAssociatedObject(headerFooter, _cmd) boolValue];
        if (!didInitialize) {
            initBlock(headerFooter, section);
            objc_setAssociatedObject(headerFooter, _cmd, @(YES), OBJC_ASSOCIATION_ASSIGN);
        }
    }
    
    return headerFooter;
}

@end

@implementation UITableView (ContentSize)

- (void)hw_updateContentSize {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL s = NSSelectorFromString(@"_updateContentSize");
    if ([self respondsToSelector:s]) {
        [self performSelector:s];
    }
#pragma clang diagnostic pop
}

@end

@implementation UITableView (Scroll)

- (void)scrollToTopWithAnimated:(BOOL)animated {
    [self setContentOffset:CGPointMake(self.contentOffset.x, 0.0f - self.contentInset.top) animated:animated];
}

- (void)scrollToBottomWithAnimated:(BOOL)animated {
    CGFloat height = self.contentSize.height + self.contentInset.bottom;
    if (height > self.frame.size.height) {
        [self setContentOffset:CGPointMake(self.contentOffset.x, height - self.frame.size.height) animated:animated];
    }
}

@end

