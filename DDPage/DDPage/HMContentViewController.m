//
//  HMContentViewController.m
//  DDPage
//
//  Created by 李林刚 on 2017/10/16.
//  Copyright © 2017年 huami. All rights reserved.
//

#import "HMContentViewController.h"
#import "HMTableViewController.h"

@interface HMContentViewController ()

@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@end

@implementation HMContentViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _bounces = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (UIView *)preferCoverView {
    return self.coverView;
}

- (UIView *)pageSegmentView {
    return _segmentView;
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
//    viewController.labelText = [@(index) stringValue];
    NSInteger page = (index%10);
    if (page == 0) {
        viewController.view.backgroundColor = [UIColor redColor];
    }
    if (page == 1) {
        viewController.view.backgroundColor = [UIColor yellowColor];
    }
    if (page == 2) {
        viewController.view.backgroundColor = [UIColor greenColor];
    }
    if (page == 3) {
        viewController.view.backgroundColor = [UIColor blueColor];
    }
    if (page == 4) {
        viewController.view.backgroundColor = [UIColor grayColor];
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
