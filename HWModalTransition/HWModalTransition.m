//
//  HWModalTransition.m
//  HWExtension
//
//  Created by houwen.wang on 2016/10/21.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "HWModalTransition.h"

typedef void(^HWAnimationStartBlock)(id <UIViewControllerContextTransitioning>context);

@interface HWModalTransitioningContext ()

@property (nonatomic, weak) UIView *containerView;            //
@property (nonatomic, weak) UIViewController *fromVC;         //
@property (nonatomic, weak) UIViewController *toVC;           //

@property (nonatomic, weak) UIViewController *presentedVC;    //
@property (nonatomic, weak) UIViewController *presentingVC;   //
@property (nonatomic, weak) UIViewController *sourceVC;       //

@end

@implementation HWModalTransitioningContext
@end

@interface HWTransitionAnimator ()

@property (nonatomic, assign) NSTimeInterval duration;              //
@property (nonatomic, copy) HWAnimationStartBlock animationStart;   //

@end

@implementation HWTransitionAnimator

+ (instancetype)animatorWithDuration:(NSTimeInterval)duration animate:(HWTransitionAnimatorBlock)animate
{
    HWTransitionAnimator *animator = [[self alloc] init];
    animator.duration = duration;
    animator.animate = animate;
    return animator;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.animationStart)
    {
        self.animationStart(transitionContext);
    }
}

@end

@interface HWModalTransition ()

@property (nonatomic, weak) UIViewController *presentedVC;    //
@property (nonatomic, weak) UIViewController *presentingVC;   //
@property (nonatomic, weak) UIViewController *sourceVC;       //

// animator
@property (nonatomic, strong) HWTransitionAnimator *presentAnimator;  // present
@property (nonatomic, strong) HWTransitionAnimator *dismissAnimator;  // dismiss

// interactive
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;  //                                    //

@end

@implementation HWModalTransition

+ (instancetype)transitionWithPresentAnimator:(HWTransitionAnimator *)presentAnimator
                              dismissAnimator:(HWTransitionAnimator *)dismissAnimator
{
    HWModalTransition *transition = [[self alloc] init];
    transition.presentAnimator = presentAnimator;
    transition.dismissAnimator = dismissAnimator;
    return transition;
}

- (void)updateTransitionWithPercentComplete:(CGFloat)percent
                               forOperation:(HWModalTransitionOperation)operation
                                     status:(HWTransitionStatus)status
{
    
    if (self.interactiveTransition == nil)
    {
        self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        
        if (operation == HWModalTransitionOperationPresent)
        {
            [self.sourceVC presentViewController:self.presentedVC animated:YES completion:nil];
        } else
        {
            [self.presentedVC dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    if (status == HWTransitionStatusContinue)
    {
        [self.interactiveTransition updateInteractiveTransition:percent];
    } else
    {
        if (status == HWTransitionStatusCancel)
        {
            [self.interactiveTransition cancelInteractiveTransition];
        } else
        {
            [self.interactiveTransition finishInteractiveTransition];
        }
        self.interactiveTransition = nil;
    }
}

- (void)setPresentAnimator:(HWTransitionAnimator *)presentAnimator
{
    if (_presentAnimator != presentAnimator)
    {
        _presentAnimator = presentAnimator;
        
        if (presentAnimator && presentAnimator.animate)
        {
            __weak typeof(self) ws = self;
            presentAnimator.animationStart = ^(id<UIViewControllerContextTransitioning> context)
            {
                __strong typeof(ws) ss = ws;
                [ss startAnimationForTransitioningContext:context operation:HWModalTransitionOperationPresent];
            };
        }
    }
}

- (void)setDismissAnimator:(HWTransitionAnimator *)dismissAnimator
{
    if (_dismissAnimator != dismissAnimator)
    {
        _dismissAnimator = dismissAnimator;
        
        if (dismissAnimator && dismissAnimator.animate)
        {
            __weak typeof(self) ws = self;
            dismissAnimator.animationStart = ^(id<UIViewControllerContextTransitioning> context)
            {
                __strong typeof(ws) ss = ws;
                [ss startAnimationForTransitioningContext:context operation:HWModalTransitionOperationDismiss];
            };
        }
    }
}

- (CGFloat)percentComplete
{
    if (self.interactiveTransition)
    {
        return self.interactiveTransition.percentComplete;
    }
    return 0.0f;
}

#pragma mark - UIViewControllerTransitioningDelegate

#pragma mark - animator

// presented
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                           presentingController:(UIViewController *)presenting
                                                                               sourceController:(UIViewController *)source
{
    self.presentedVC = presented;
    self.presentingVC = presenting;
    self.sourceVC = source;
    return self.presentAnimator;
}

// dismissed
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimator;
}

#pragma mark - interaction

// presentation
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveTransition;
}

// dismissal
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveTransition;
}

#pragma mark - private

- (void)startAnimationForTransitioningContext:(id<UIViewControllerContextTransitioning>)context operation:(HWModalTransitionOperation)operation
{
    
    UIView *containerView = context.containerView;
    UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    HWModalTransitioningContext *context_t = [[HWModalTransitioningContext alloc] init];
    
    context_t.containerView = containerView;
    context_t.fromVC = fromVC;
    context_t.toVC = toVC;
    
    context_t.presentingVC = self.presentingVC;
    context_t.presentedVC = self.presentedVC;
    context_t.sourceVC = self.sourceVC;
    
    if (operation == HWModalTransitionOperationPresent)
    {
        [containerView addSubview:toVC.view];
        containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        
        self.presentAnimator.animate(context_t,
                                     ^(void)
                                     {
                                         [context completeTransition:!context.transitionWasCancelled];
                                     });
        
    } else if (operation == HWModalTransitionOperationDismiss)
    {
        self.dismissAnimator.animate(context_t,
                                     ^(void)
                                     {
                                         [context completeTransition:!context.transitionWasCancelled];
                                         
                                     });
    }
}

@end

