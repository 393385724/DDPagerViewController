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

- (UIView *)preferCoverView {
    return nil;
}

- (UIView *)pageSegmentView {
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

- (NSInteger)ddPageViewController:(DDPageViewController *)pageViewController pageTopOffsetAtIndex:(NSInteger)index {
    return 200 + 44;
}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizerInPageViewController:(DDPageViewController *)pageViewController {
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0){
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers){
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
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
      childDidChangeContentOffsetY:(CGFloat)offsetY
                   scrollTop:(BOOL)scrollTop {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CGFloat defaultTopOffset = _defaultTopOffsetCompensation;
    defaultTopOffset += ([UIApplication sharedApplication].statusBarHidden ? 0 : CGRectGetHeight(statusBarFrame));

    if (self.preferCoverView) {
        CGFloat coverViewHeight = CGRectGetHeight(self.preferCoverView.frame);
        CGFloat scrollViewDefaultOffsetY = defaultTopOffset + coverViewHeight - (self.navigationController.navigationBarHidden ? 0 : CGRectGetHeight(navigationBarFrame)) + 4;
        CGFloat coverViewTop = -offsetY - scrollViewDefaultOffsetY;
        
        CGRect frame = self.preferCoverView.frame;
        frame.origin.y = coverViewTop;
        self.preferCoverView.frame = frame;
    }
    
    if (self.pageSegmentView) {
        CGFloat pageSegmentHeight = CGRectGetHeight(self.pageSegmentView.frame);
        CGFloat scrollViewDefaultOffsetY = defaultTopOffset - pageSegmentHeight + (self.navigationController.navigationBarHidden ? 0 : CGRectGetHeight(navigationBarFrame));;
        CGFloat pageSegmentTop = offsetY;
        if (offsetY >= -pageSegmentHeight) {
            pageSegmentTop = defaultTopOffset;
        } else {
            pageSegmentTop = -offsetY + scrollViewDefaultOffsetY;
        }
        CGRect frame = self.pageSegmentView.frame;
        frame.origin.y = pageSegmentTop;
        self.pageSegmentView.frame = frame;
    }
}

- (BOOL)shouldRememberPageOffsetInPageViewController:(DDPageViewController *)pageViewController {
    return YES;
}

@end
