//
//  HWRootViewController.m
//  HWModalTransition_Example
//
//  Created by wanghouwen on 2018/3/29.
//  Copyright © 2018年 wanghouwen. All rights reserved.
//

#import "HWRootViewController.h"
#import "HWSideViewController.h"
#import "HWViewController1.h"
#import "HWViewController2.h"
#import "HWViewController3.h"
#import "HWViewController4.h"

@interface HWRootViewController ()

@end

@implementation HWRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    if (!self.viewControllers.count) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        NSArray <Class>*clss = @[[HWViewController1 class],
                                 [HWViewController2 class],
                                 [HWViewController3 class],
                                 [HWViewController4 class]];
        
        NSArray <NSString *>*titles = @[@"VC1", @"VC2", @"VC3", @"VC4"];
        
        NSMutableArray <UINavigationController *>*vcs = [NSMutableArray array];
        
        for (Class cls in clss) {
            NSUInteger index = [clss indexOfObject:cls];
            
            UIViewController *vc = [[cls alloc] init];
            vc.title = titles[index];
            
            [vcs addObject:[[UINavigationController alloc] initWithRootViewController:vc]];
        }
        
        [self setViewControllers:vcs animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
