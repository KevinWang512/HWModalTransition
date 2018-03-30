//
//  UITableView+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/12/19.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

typedef __kindof UITableViewCell * _Nonnull (^DequeueCellNilBlock)(NSIndexPath *indexPath);
typedef void(^CellInitBlock)(__kindof UITableViewCell * _Nonnull cell, NSIndexPath *indexPath);

typedef __kindof UITableViewHeaderFooterView * _Nonnull (^DequeueHeaderFooterNilBlock)(NSInteger section);
typedef void(^HeaderFooterInitBlock)(__kindof UITableViewHeaderFooterView * _Nonnull headerFooter, NSInteger section);

@interface UITableView (Utils)

+ (instancetype)plainStyleTableViewWithFrame:(CGRect)frame delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource;

+ (instancetype)groupedStyleTableViewWithFrame:(CGRect)frame delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource;

+ (instancetype)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource;

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
                                                              initBlock:(nullable CellInitBlock)initBlock;

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
                                                                                      initBlock:(nullable HeaderFooterInitBlock)initBlock;
@end

@interface UITableView (ContentSize)

// 调用 UITableView 的私有方法更新 contentSize
- (void)hw_updateContentSize;

@end

@interface UITableView (Scroll)

- (void)scrollToTopWithAnimated:(BOOL)animated;
- (void)scrollToBottomWithAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

