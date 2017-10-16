//
//  DDContentViewController.m
//  DDPage
//
//  Created by 李林刚 on 2017/10/13.
//  Copyright © 2017年 huami. All rights reserved.
//

#import "DDContentViewController.h"
#import "DDPageViewController.h"

@interface DDContentViewController ()<DDPageViewControllerDelegate,DDPageViewControllerDataSource>

@property (nonatomic, strong) DDPageViewController *pageViewController;

@end

@implementation DDContentViewController

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

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}

#pragma mark - Public Methods

- (UIViewController *)currentChildViewController {
    return [self.pageViewController currentViewController];
}

- (UIView *)pagebarView {
    return nil;
}

- (void)switchToIndex:(NSUInteger)index animated:(BOOL)animated {
    [self.pageViewController switchToIndex:index animated:animated];
}

#pragma mark - DDPageViewControllerDataSource

- (NSInteger)numberOfViewControllersInPageViewController:(DDPageViewController *)pageViewController {
    NSAssert(NO, @"sub class must implementation");
    return 0;
}

- (UIViewController *)ddPageViewController:(DDPageViewController *)pageViewController viewControllerAtIndex:(NSInteger)index {
    NSAssert(NO, @"sub class must implementation");
    return 0;
}

- (NSInteger)initViewControllerIndexInPageViewController:(DDPageViewController *)pageViewController {
    return self.firstReloadIndex;
}

#pragma mark - DDPageViewControllerDelegate

- (void)ddPageViewController:(DDPageViewController*)pageViewController
willTransitionFromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController {
    
}

- (void)ddPageViewController:(DDPageViewController*)pageViewController
didTransitionFromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController {
    
}

- (void)ddPageViewController:(DDPageViewController*)pageViewController
      childDidChangeContentOffset:(UIScrollView *)scrollView {
    NSLog(@"scrollView offsetX:%f offsetY:%f ",scrollView.contentOffset.x,scrollView.contentOffset.y);
    CGFloat top = 64 - scrollView.contentOffset.y;
    self.pageSegmentView.frame = CGRectMake(self.pageSegmentView.frame.origin.x, top, self.pageSegmentView.frame.size.width, self.pageSegmentView.frame.size.height);
}

- (BOOL)shouldRememberPageOffsetInPageViewController:(DDPageViewController *)pageViewController {
    return YES;
}

@end
