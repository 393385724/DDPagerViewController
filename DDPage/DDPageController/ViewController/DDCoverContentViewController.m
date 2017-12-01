//
//  DDCoverContentViewController.m
//  DDPage
//
//  Created by 李林刚 on 2017/11/8.
//  Copyright © 2017年 huami. All rights reserved.
//

#import "DDCoverContentViewController.h"
#import "DDPageViewController.h"
#import "DDPageChildViewControllerProtocol.h"
#import "DDPageViewControllerProtocol.h"

@interface DDCoverContentViewController ()

@end

@implementation DDCoverContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Public Methods

- (UIView *)pageHeadView {
    return nil;
}

- (UIView *)pageBarView {
    return nil;
}

- (CGFloat)pageTopSafeArea {
    return 0;
}

#pragma mark - Private Methods

- (NSInteger)p_systemNavigationBarHeight {
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    if (!self.navigationController.isNavigationBarHidden) {
        return CGRectGetHeight(navigationBarFrame) + [self pageTopSafeArea];
    } else {
        return [self pageTopSafeArea];
    }
}

- (CGFloat)p_systemDefultTopOffset {
    return [self p_systemNavigationBarHeight];
}

- (CGFloat)p_pageHeadMinTopOffset {
    if (!self.pageBarView) {
        return - CGRectGetHeight(self.pageHeadView.frame);
    } else {
        return - (CGRectGetHeight(self.pageHeadView.frame) - [self p_systemDefultTopOffset]);
    }
}

- (CGFloat)p_pageBarMinTopOffset {
    return [self p_systemDefultTopOffset];
}

- (CGFloat)p_childScorllViewDefaultTop {
    CGFloat defaultTopOffset = [self p_systemNavigationBarHeight];
    if (self.pageHeadView) {
        defaultTopOffset += CGRectGetHeight(self.pageHeadView.frame);
    }
    if (self.pageBarView) {
        defaultTopOffset += CGRectGetHeight(self.pageBarView.frame);
    }
    return defaultTopOffset;
}

//用于纠正childview 切换，scrollView offset不同问题
- (void)p_changeSubViewController:(UIViewController *)toViewController isDelay:(BOOL)isDelay{
    if (!toViewController || [self numberOfViewControllersInPageViewController:self.pageViewController] <= 1) {
        return;
    }
    if (![toViewController conformsToProtocol:@protocol(DDPageChildViewControllerProtocol)]) {
        return;
    }
    NSInteger newIndex = [self.pageViewController indexOfViewController:toViewController];
    if (newIndex < 0) {
        return;
    }
    if (self.pageBarView) {
        UIScrollView *toscrollView = [(UIViewController <DDPageChildViewControllerProtocol> *)toViewController preferScrollView];
        CGFloat pageBarViewTop = CGRectGetMinY(self.pageBarView.frame);
        CGFloat pageViewTop = [self p_pageBarMinTopOffset] + CGRectGetHeight(self.pageBarView.frame);
        CGFloat scrollOffset = [self p_pageBarMinTopOffset] - pageBarViewTop - pageViewTop;
        CGFloat offset = toscrollView.contentOffset.y + pageViewTop;
        CGFloat top = [self p_pageBarMinTopOffset] - (offset);
        if (top != pageBarViewTop) {
            toscrollView.contentOffset =  CGPointMake(0, scrollOffset);
        }
    }
}

- (void)p_changeStatusBarAndNavigationBarStatusWithViewController:(UIViewController *)viewController animated:(BOOL)animated {
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
    
    //控制StatusBar的状态
    UIStatusBarStyle barStyle = [self preferredStatusBarStyle];
    [self.navigationController.navigationBar setBarStyle:barStyle == UIStatusBarStyleDefault ? UIBarStyleDefault : UIBarStyleBlack];
    [self setNeedsStatusBarAppearanceUpdate];
    
    //控制NavigationBar隐藏显示
    [self.navigationController setNavigationBarHidden:viewController.navigationController.isNavigationBarHidden animated:YES];
    [self.navigationItem setHidesBackButton:viewController.navigationItem.hidesBackButton animated:animated];
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

- (NSInteger)ddPageViewController:(DDPageViewController *)pageViewController pageTopOffsetAtIndex:(NSInteger)index {
    return [self p_childScorllViewDefaultTop];
}

#pragma mark - DDPageViewControllerDelegate

- (void)ddPageViewController:(DDPageViewController*)pageViewController
willTransitionFromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController {
    [self p_changeSubViewController:toViewController isDelay:NO];
    [self willTransitionFromViewController:fromViewController toViewController:toViewController];
}

- (void)ddPageViewController:(DDPageViewController*)pageViewController
didTransitionFromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController {
    [self p_changeStatusBarAndNavigationBarStatusWithViewController:toViewController animated:YES];
    [self didTransitionFromViewController:fromViewController toViewController:toViewController];
}

- (void)ddPageViewController:(DDPageViewController*)pageViewController
childDidChangeContentOffsetY:(CGFloat)offsetY {
    [self childDidChangeVerticalContentOffsetY:offsetY];
    if (self.pageHeadView) {
        CGFloat pageSegmentTop = offsetY;
        CGFloat thresholdOffset = -CGRectGetHeight(self.pageHeadView.frame) - [self p_pageHeadMinTopOffset];
        if (self.pageBarView) {
            thresholdOffset -= CGRectGetHeight(self.pageBarView.frame);
        }
        if (offsetY >= thresholdOffset) {
            pageSegmentTop = [self p_pageHeadMinTopOffset];
        } else {
            if (self.navigationController.isNavigationBarHidden) {
                pageSegmentTop = [self p_systemNavigationBarHeight] - (offsetY + [self p_childScorllViewDefaultTop]);
            } else {
                pageSegmentTop = [self p_systemDefultTopOffset] - (offsetY + [self p_childScorllViewDefaultTop]);
            }
        }
        CGRect frame = self.pageHeadView.frame;
        frame.origin.y = pageSegmentTop;
        self.pageHeadView.frame = frame;
    }
    if (self.pageBarView) {
        CGFloat pageSegmentTop = offsetY;
        if (offsetY >= -[self p_pageBarMinTopOffset] - CGRectGetHeight(self.pageBarView.frame)) {
            pageSegmentTop = [self p_pageBarMinTopOffset];
        } else {
            pageSegmentTop = - offsetY - CGRectGetHeight(self.pageBarView.frame);
        }
        CGRect frame = self.pageBarView.frame;
        frame.origin.y = pageSegmentTop;
        self.pageBarView.frame = frame;
    }
}

@end
