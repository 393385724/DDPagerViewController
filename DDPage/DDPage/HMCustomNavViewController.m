//
//  HMCustomNavViewController.m
//  DDPage
//
//  Created by 李林刚 on 2017/10/20.
//  Copyright © 2017年 huami. All rights reserved.
//

#import "HMCustomNavViewController.h"
#import "HMTableViewController.h"

@interface HMCustomNavViewController ()

@end

@implementation HMCustomNavViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _bounces = YES;
        _containerEdgeInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (CGFloat)pageTopSafeArea {
    return -20;
}

- (IBAction)buttonAction:(UIButton *)sender {
    [self switchToIndex:sender.tag animated:YES];
}

- (NSInteger)numberOfViewControllersInPageViewController:(DDPageViewController *)pageViewController {
    return 30;
}

- (UIViewController *)ddPageViewController:(DDPageViewController*)pageViewController
                     viewControllerAtIndex:(NSInteger)index {
    HMTableViewController *viewController = [[HMTableViewController alloc] init];
    viewController.number = 30;
    NSInteger page = (index%10);
    if (page == 0) {
        viewController.view.backgroundColor = [UIColor redColor];
        viewController.number = 60;
    }
    if (page == 1) {
        viewController.view.backgroundColor = [UIColor yellowColor];
        viewController.number = 4;
    }
    if (page == 2) {
        viewController.view.backgroundColor = [UIColor greenColor];
        viewController.number = 100;
    }
    if (page == 3) {
        viewController.view.backgroundColor = [UIColor blueColor];
        viewController.number = 10;
    }
    if (page == 4) {
        viewController.view.backgroundColor = [UIColor grayColor];
        viewController.number = 15;
    }
    if (page == 5) {
        viewController.view.backgroundColor = [UIColor lightGrayColor];
    }
    if (page == 6) {
        viewController.view.backgroundColor = [UIColor cyanColor];
    }
    if (page == 7) {
        viewController.view.backgroundColor = [UIColor brownColor];
    }
    if (page == 8) {
        viewController.view.backgroundColor = [UIColor purpleColor];
    }
    if (page == 9) {
        viewController.view.backgroundColor = [UIColor orangeColor];
    }
    return viewController;
}


@end
