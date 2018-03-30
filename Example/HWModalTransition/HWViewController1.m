//
//  HWViewController1.m
//  HWModalTransition
//
//  Created by wanghouwen on 03/29/2018.
//  Copyright (c) 2018 wanghouwen. All rights reserved.
//

#import "HWViewController1.h"
#import "HWCategorys.h"
#import "HWSideViewController.h"

@interface HWViewController1 ()
{
    HWSideViewController *_sideVC;
}

@end

@implementation HWViewController1

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _sideVC = [[HWSideViewController alloc] init];
    
    __weak typeof(self) ws = self;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"icon_userIcon" actionHandler:^(UIBarButtonItem *item, UIButton *customView) {
        __strong typeof(ws) ss = ws;
        [ss presentViewController:_sideVC animated:YES completion:nil];
    }];
    
    UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
    btn.imageRect = CGRectMake(0, 0, 44, 44);
    btn.imageView.layer.cornerRadius = 22;
    
    NSArray *titles = @[@"style1", @"style2"];
    CGFloat top = 200;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;;
    
    for (NSString *title in titles) {
        UIButton *btn = [UIButton buttonWithText:title font:[UIFont systemFontOfSize:20] textColor:[UIColor blueColor]];
        
        [btn addEventsHandlerForControlEvents:UIControlEventTouchUpInside handler:^(__kindof UIControl *sender) {
            
            NSString *title = [((UIButton *)sender) titleForState:UIControlStateNormal];
            
            HWModalTransitionViewController *vc = [[HWModalTransitionViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            [vc.view addGestureRecognizer:[UITapGestureRecognizer gestureRecognizerWithHandler:^(__kindof UIGestureRecognizer *ges) {
                [vc dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            HWTransitionAnimator *present = nil;
            HWTransitionAnimator *dismiss = nil;
            
            if ([title isEqualToString:@"style1"]) {

                present = [HWTransitionAnimator animatorWithDuration:0.15 animate:^(HWModalTransitioningContext *context, HWCompleteBlock complete) {
                    
                    [context.containerView addGestureRecognizer:[UITapGestureRecognizer gestureRecognizerWithHandler:^(__kindof UIGestureRecognizer *ges) {
                        [context.presentedVC dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    
                    context.toVC.view.frame = CGRectMake(0, screenSize.height, screenSize.width, screenSize.height * 0.5f);
                    [UIView animateWithDuration:0.15 delay:0.0 usingSpringWithDamping:10 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        context.toVC.view.top = screenSize.height * 0.5f;
                    } completion:^(BOOL finished) {
                        complete();
                    }];
                }];
                
                dismiss = [HWTransitionAnimator animatorWithDuration:0.15 animate:^(HWModalTransitioningContext *context, HWCompleteBlock complete) {
                    [UIView animateWithDuration:0.15 delay:0.0 usingSpringWithDamping:10 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        context.fromVC.view.top = screenSize.height;
                    } completion:^(BOOL finished) {
                        complete();
                    }];
                }];
                
            } else if ([title isEqualToString:@"style2"]) {
                
                present = [HWTransitionAnimator animatorWithDuration:0.15 animate:^(HWModalTransitioningContext *context, HWCompleteBlock complete) {
                    
                    [context.containerView addGestureRecognizer:[UITapGestureRecognizer gestureRecognizerWithHandler:^(__kindof UIGestureRecognizer *ges) {
                        [context.presentedVC dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    
                    context.toVC.view.frame = CGRectMake(15, screenSize.height, screenSize.width - 30, 200);
                    context.toVC.view.layer.cornerRadius = 8.0f;
                    [UIView animateWithDuration:0.15 delay:0.0 usingSpringWithDamping:10 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        context.toVC.view.top = screenSize.height * 0.3f;
                    } completion:^(BOOL finished) {
                        complete();
                    }];
                }];
                
                dismiss = [HWTransitionAnimator animatorWithDuration:0.15 animate:^(HWModalTransitioningContext *context, HWCompleteBlock complete) {
                    [UIView animateWithDuration:0.15 delay:0.0 usingSpringWithDamping:10 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        context.fromVC.view.top = screenSize.height;
                    } completion:^(BOOL finished) {
                        complete();
                    }];
                }];
                
            }
            
            vc.modalTransition = [HWModalTransition transitionWithPresentAnimator:present dismissAnimator:dismiss];
            [self presentViewController:vc animated:YES completion:nil];
        }];
        btn.size = btn.titleLabel.singleLineSize;
        btn.centerX = self.view.centerX;
        btn.top = top;
        top = btn.bottom + 20;
        [self.view addSubview:btn];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
