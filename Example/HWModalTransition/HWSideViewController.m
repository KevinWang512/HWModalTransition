//
//  HWSideViewController.m
//  HWModalTransition_Example
//
//  Created by wanghouwen on 2018/3/29.
//  Copyright © 2018年 wanghouwen. All rights reserved.
//

#import "HWSideViewController.h"
#import "UIView+Utils.h"
#import "UIGestureRecognizer+Category.h"

@interface HWSideViewController ()

@end

@implementation HWSideViewController

- (instancetype)init {
    if (self=[super init]) {
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat sideWidth = ceilf(screenSize.width * 0.8);
        
        HWTransitionAnimator *present = [HWTransitionAnimator animatorWithDuration:0.15 animate:^(HWModalTransitioningContext *context, HWCompleteBlock complete) {
            
            context.containerView.backgroundColor = [UIColor clearColor];
            
            // 点击手势
            [context.containerView addGestureRecognizer:[UITapGestureRecognizer gestureRecognizerWithHandler:^(__kindof UIGestureRecognizer *ges) {
                
                CGPoint point = [ges locationInView:ges.view];
                if (!CGRectContainsPoint(context.toVC.view.frame, point)) {
                    [context.presentedVC dismissViewControllerAnimated:YES completion:nil];
                }
            }]];
            
            // 拖动手势
            __block CGPoint startPoint = CGPointZero;
            __weak typeof(self) ws = self;
            [context.containerView addGestureRecognizer:[UIPanGestureRecognizer gestureRecognizerWithHandler:^(__kindof UIGestureRecognizer *ges) {
                
                __strong typeof(ws) ss = ws;
                
                CGPoint endPoint = [ges locationInView:ges.view];
                
                if (ges.state == UIGestureRecognizerStateBegan) {
                    
                    startPoint = [ges locationInView:ges.view];
                    
                } else if (ges.state == UIGestureRecognizerStateChanged) {
                    
                    CGFloat offsetX = endPoint.x - startPoint.x;
                    
                    if (offsetX < 0 && !CGRectContainsPoint(context.toVC.view.frame, startPoint)) {
                        CGFloat percent = ABS(offsetX * 0.4f / sideWidth);
                        [ss.modalTransition updateTransitionWithPercentComplete:percent
                                                                   forOperation:HWModalTransitionOperationDismiss
                                                                         status:HWTransitionStatusContinue];
                    }
                    
                } else if (ges.state == UIGestureRecognizerStateEnded |
                           ges.state == UIGestureRecognizerStateCancelled) {
                    
                    if (ss.modalTransition.percentComplete >= 0.08f) {
                        [ss.modalTransition updateTransitionWithPercentComplete:1.0
                                                                   forOperation:HWModalTransitionOperationDismiss
                                                                         status:HWTransitionStatusFinish];
                    } else {
                        [ss.modalTransition updateTransitionWithPercentComplete:1.0
                                                                   forOperation:HWModalTransitionOperationDismiss
                                                                         status:HWTransitionStatusCancel];
                    }
                }
            }]];
            
            context.toVC.view.frame = CGRectMake(-sideWidth, 0, sideWidth, screenSize.height);
            [UIView animateWithDuration:0.15 delay:0.0 usingSpringWithDamping:5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                context.toVC.view.left = 0.0f;
                context.fromVC.view.left = context.toVC.view.right;
                
            } completion:^(BOOL finished) {
                complete();
            }];
        }];
        
        HWTransitionAnimator *dismiss = [HWTransitionAnimator animatorWithDuration:0.15 animate:^(HWModalTransitioningContext *context, HWCompleteBlock complete) {
            
            [UIView animateWithDuration:0.15 delay:0.0 usingSpringWithDamping:5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                context.fromVC.view.left = -sideWidth;
                context.toVC.view.left = context.fromVC.view.right;;
                
            } completion:^(BOOL finished) {
                complete();
            }];
        }];
        
        self.modalTransition = [HWModalTransition transitionWithPresentAnimator:present
                                                                dismissAnimator:dismiss];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)dealloc{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
