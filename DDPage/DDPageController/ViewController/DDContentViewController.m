//
//  DDContentViewController.m
//  DDPage
//
//  Created by 李林刚 on 2017/10/13.
//  Copyright © 2017年 huami. All rights reserved.
//

#import "DDContentViewController.h"
#import "DDPageViewController.h"
#import "DDPageChildViewControllerProtocol.h"
#import "DDPageViewControllerProtocol.h"

@interface DDContentViewController ()<DDPageViewControllerDelegate,DDPageViewControllerDataSource>

@property (nonatomic, strong, readwrite) DDPageViewController *pageViewController;

@end

@implementation DDContentViewController

- (void)dealloc {
    self.pageViewController.delegate = nil;
    self.pageViewController.dataSource = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _containerEdgeInset = UIEdgeInsetsZero;
        _scrollEnable = YES;
        _bounces = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageViewController = [[DDPageViewController alloc] init];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self addChildViewController:self.pageViewController];
    [self.view insertSubview:self.pageViewController.view atIndex:0];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.pageViewController.myScrollView.scrollEnabled = _scrollEnable;
    self.pageViewController.myScrollView.bounces = _bounces;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.pageViewController beginAppearanceTransition:YES animated:animated];
    [self p_changeStatusBarAndNavigationBarStatusWithViewController:self.currentChildViewController animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pageViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.pageViewController beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.pageViewController endAppearanceTransition];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!UIEdgeInsetsEqualToEdgeInsets(_containerEdgeInset, UIEdgeInsetsZero)) {
        self.pageViewController.view.frame = CGRectMake(_containerEdgeInset.left, _containerEdgeInset.top, CGRectGetWidth(self.view.bounds) - _containerEdgeInset.left - _containerEdgeInset.right, CGRectGetHeight(self.view.bounds) - _containerEdgeInset.top - _containerEdgeInset.bottom);
    } else {
        self.pageViewController.view.frame = self.view.bounds;
    }
}

#pragma mark - Navigation & Status Bar

- (BOOL)prefersStatusBarHidden{
    return [self.currentChildViewController prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return [self.currentChildViewController preferredStatusBarStyle];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}

#pragma mark - Rotate

- (BOOL)shouldAutorotate{
    return self.currentChildViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.currentChildViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.currentChildViewController.preferredInterfaceOrientationForPresentation;
}

#pragma mark - Public Methods

- (UIViewController *)currentChildViewController {
    return [self.pageViewController currentViewController];
}

- (void)switchToIndex:(NSUInteger)index animated:(BOOL)animated {
    [self.pageViewController switchToIndex:index animated:animated];
}

- (NSInteger)numberOfChildViewControllers {
    NSAssert(NO, @"sub class must implementation");
    return 0;
}

- (UIViewController *)childViewControllerAtIndex:(NSInteger)index {
    NSAssert(NO, @"sub class must implementation");
    return nil;
}

- (void)willTransitionFromViewController:(UIViewController *)fromViewController
                        toViewController:(UIViewController *)toViewController {
    
}

- (void)didTransitionFromViewController:(UIViewController *)fromViewController
                       toViewController:(UIViewController *)toViewController {
    
}

- (void)childDidChangeVerticalContentOffsetY:(CGFloat)offsetY {
    
}

#pragma mark - Private Methods

- (void)p_changeStatusBarAndNavigationBarStatusWithViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //控制StatusBar的状态
    UIStatusBarStyle barStyle = [self preferredStatusBarStyle];
    [self.navigationController.navigationBar setBarStyle:barStyle == UIStatusBarStyleDefault ? UIBarStyleDefault : UIBarStyleBlack];
    [self setNeedsStatusBarAppearanceUpdate];
    
    //控制NavigationBar隐藏显示
    [self.navigationController setNavigationBarHidden:viewController.navigationController.isNavigationBarHidden animated:animated];
    [self.navigationItem setHidesBackButton:viewController.navigationItem.hidesBackButton animated:animated];
    
    //控制navigationItem
    if (!viewController.navigationController.navigationBarHidden) {
        if (viewController.navigationItem.leftBarButtonItems) {
            self.navigationItem.leftBarButtonItems = viewController.navigationItem.leftBarButtonItems;
        } else {
            self.navigationItem.leftBarButtonItems = nil;
            if (viewController.navigationItem.leftBarButtonItem) {
                self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem;
            } else {
                self.navigationItem.leftBarButtonItem = nil;
            }
        }
        
        if (viewController.navigationItem.rightBarButtonItems) {
            self.navigationItem.rightBarButtonItems = viewController.navigationItem.rightBarButtonItems;
        } else {
            self.navigationItem.rightBarButtonItems = nil;
            if (viewController.navigationItem.rightBarButtonItem) {
                self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem;
            } else {
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
    }
}

#pragma mark - DDPageViewControllerDataSource

- (NSInteger)numberOfViewControllersInPageViewController:(DDPageViewController *)pageViewController {
    return [self numberOfChildViewControllers];
}

- (UIViewController *)ddPageViewController:(DDPageViewController *)pageViewController viewControllerAtIndex:(NSInteger)index {
    return [self childViewControllerAtIndex:index];
}

- (NSInteger)initViewControllerIndexInPageViewController:(DDPageViewController *)pageViewController {
    return self.firstReloadIndex;
}

#pragma mark - DDPageViewControllerDelegate

- (void)ddPageViewController:(DDPageViewController*)pageViewController
willTransitionFromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController {
    [self willTransitionFromViewController:fromViewController toViewController:toViewController];
}

- (void)ddPageViewController:(DDPageViewController*)pageViewController
didTransitionFromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController {
    [self p_changeStatusBarAndNavigationBarStatusWithViewController:toViewController animated:YES];
    [self didTransitionFromViewController:fromViewController toViewController:toViewController];
}

@end
