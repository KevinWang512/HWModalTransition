//
//  HWModalTransition.h
//  HWExtension
//
//  Created by houwen.wang on 2016/10/21.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//
//  可交互模态转场

#import <Foundation/Foundation.h>

@class HWModalTransitioningContext, HWModalTransition;

typedef NS_ENUM(NSInteger, HWModalTransitionOperation) {
    HWModalTransitionOperationPresent,
    HWModalTransitionOperationDismiss,
};

typedef NS_ENUM(NSInteger, HWTransitionStatus) {
    HWTransitionStatusContinue,
    HWTransitionStatusFinish,
    HWTransitionStatusCancel,
};

typedef void(^HWCompleteBlock)(void);
typedef void(^HWTransitionAnimatorBlock)(HWModalTransitioningContext *context, HWCompleteBlock complete);

/**
 *  UIViewController 实现自定义模态转场效果，需以下2个步骤
 *  1、vc.modalPresentationStyle = UIModalPresentationCustom
 *  2、vc.transitioningDelegate = protocol.modalTransition
 *
 *  以上步骤须在[vc presentViewController:animated:completion:]之前已完成
 */
@protocol HWModalTransitionDelegate <NSObject>

@property (nonatomic, strong) HWModalTransition *modalTransition;

@end

@interface HWModalTransitioningContext : NSObject

@property (nonatomic, weak, readonly) UIView *containerView;              //
@property (nonatomic, weak, readonly) UIViewController *fromVC;           //
@property (nonatomic, weak, readonly) UIViewController *toVC;             //

@property (nonatomic, weak, readonly) UIViewController *presentedVC;      //
@property (nonatomic, weak, readonly) UIViewController *presentingVC;     //
@property (nonatomic, weak, readonly) UIViewController *sourceVC;         //

@end

@interface HWTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, readonly) NSTimeInterval duration;    //
@property (nonatomic, copy) HWTransitionAnimatorBlock animate;      // custom your animations

+ (instancetype)animatorWithDuration:(NSTimeInterval)duration animate:(HWTransitionAnimatorBlock)animate;

@end

@interface HWModalTransition : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign, readonly) CGFloat percentComplete;    //

// animator
@property (nonatomic, strong, readonly) HWTransitionAnimator *presentAnimator;  // present
@property (nonatomic, strong, readonly) HWTransitionAnimator *dismissAnimator;  // dismiss

+ (instancetype)transitionWithPresentAnimator:(HWTransitionAnimator *)presentAnimator
                              dismissAnimator:(HWTransitionAnimator *)dismissAnimator;

- (void)updateTransitionWithPercentComplete:(CGFloat)percent
                               forOperation:(HWModalTransitionOperation)operation
                                     status:(HWTransitionStatus)status;

@end
