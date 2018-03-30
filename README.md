# HWModalTransition

[![CI Status](http://img.shields.io/travis/wanghouwen/HWModalTransition.svg?style=flat)](https://travis-ci.org/wanghouwen/HWModalTransition)
[![Version](https://img.shields.io/cocoapods/v/HWModalTransition.svg?style=flat)](http://cocoapods.org/pods/HWModalTransition)
[![License](https://img.shields.io/cocoapods/l/HWModalTransition.svg?style=flat)](http://cocoapods.org/pods/HWModalTransition)
[![Platform](https://img.shields.io/cocoapods/p/HWModalTransition.svg?style=flat)](http://cocoapods.org/pods/HWModalTransition)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 如何让一个UIViewController实现自定义转场效果

## Step 1
 vc.modalPresentationStyle = UIModalPresentationCustom
 
 ## Step 2
 vc.transitioningDelegate = HWModalTransition object
 
  ## Step 3
 
  实例化HWModalTransition object
  
  ``` objective-c
  // present转场对象
  present = [HWTransitionAnimator animatorWithDuration:0.15 animate:^(HWModalTransitioningContext *context, HWCompleteBlock complete) {
  
    // 可根据需求对某些view添加手势
    [context.containerView addGestureRecognizer:[UITapGestureRecognizer gestureRecognizerWithHandler:^(__kindof UIGestureRecognizer *ges) {
        [context.presentedVC dismissViewControllerAnimated:YES completion:nil];
        }]];
  
  
    // 自定义你的动画效果
    context.toVC.view.frame = CGRectMake(0, screenSize.height, screenSize.width, screenSize.height * 0.5f);
    [UIView animateWithDuration:0.15 delay:0.0 usingSpringWithDamping:10 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
      context.toVC.view.top = screenSize.height * 0.5f;
      
      } completion:^(BOOL finished) {
        complete(); // 动画结束一定要调用这个block块，否则转场未完成下一次无法继续转场
      }];
  }];
  
  // dismiss转场对象
  dismiss = [HWTransitionAnimator animatorWithDuration:0.15 animate:^(HWModalTransitioningContext *context, HWCompleteBlock complete) {
  
    // 自定义你的动画效果
    [UIView animateWithDuration:0.15 delay:0.0 usingSpringWithDamping:10 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
        context.fromVC.view.top = screenSize.height;
        
      } completion:^(BOOL finished) {
        complete(); // 动画结束一定要调用这个block块，否则转场未完成下一次无法继续转场
      }];
  }];
  
  HWModalTransition object = [HWModalTransition transitionWithPresentAnimator:present dismissAnimator:dismiss];

```

## 如何支持手势交互？

 在适合的view上添加手势， 手势处理方法中调用以下方法更新转场动画进度
 
   ``` objective-c
 - (void)updateTransitionWithPercentComplete:(CGFloat)percent forOperation:(HWModalTransitionOperation)operation
    status:(HWTransitionStatus)status;
 ```
 注意：
 1、对于一个已经处于percent状态的vc，手势交互时以上方法operation参数应该传HWModalTransitionOperationDismiss，因为你不可以再一次percent这个vc；
 dismiss 状态也一样
 2、以上方法如果status状态传 HWTransitionStatusFinish 或 HWTransitionStatusCancel 时，percent参数是会被忽略的
 
## Requirements

## Installation

HWModalTransition is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HWModalTransition'
```

## Author

wanghouwen, wanghouwen123@126.com

## License

HWModalTransition is available under the MIT license. See the LICENSE file for more info.
