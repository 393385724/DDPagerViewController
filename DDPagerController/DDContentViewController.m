//
//  DDContentViewController.m
//  DDPagerControllerDemo
//
//  Created by lilingang on 15/11/17.
//  Copyright (c) 2015年 LeeLingang. All rights reserved.
//

#import "DDContentViewController.h"
#import "DDPageViewController.h"

@interface DDContentViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) DDPageViewController *pageViewController;

@property (nonatomic, assign) NSUInteger currentViewControllerIndex;

// bugfix, quickly switch to a white screen
@property (nonatomic, strong) NSDate *lastChangeDate;

@end

@implementation DDContentViewController

#pragma mark -
#pragma mark Accessor

-(UIViewController *)currentChildViewController{
    if (self.currentViewControllerIndex >= [_viewControllers count]) {
        NSLog(@"currentViewControllerIndex >= [self.viewControllers count]");
        return nil;
    }
    UIViewController *childViewController = [_viewControllers objectAtIndex:self.currentViewControllerIndex];
    if ([childViewController isKindOfClass:[UIViewController class]]) {
        return [(DDContentViewController *)childViewController currentChildViewController];
    } else {
        return childViewController;
    }
}

#pragma mark -
#pragma mark  life Cycle

- (instancetype)init{
    self = [super init];
    if (self) {
        _scrollEnable = YES;
        _bounces = YES;
        _currentViewControllerIndex = 0;
        _containerEdgeInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageViewController = [[DDPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    self.pageViewController.view.frame = CGRectMake(_containerEdgeInset.left, _containerEdgeInset.top, CGRectGetWidth([UIScreen mainScreen].bounds) - _containerEdgeInset.left - _containerEdgeInset.right, CGRectGetHeight([UIScreen mainScreen].bounds) - _containerEdgeInset.top - _containerEdgeInset.bottom);
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.pageViewController.bounces = _scrollEnable&&_bounces;
    [self switchToIndex:self.currentViewControllerIndex animated:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)switchToIndex:(NSUInteger)index animated:(BOOL)animated{
    if (index >= [_viewControllers count]) {
        NSLog(@"index >= [viewControllers count]");
        return;
    }
    NSTimeInterval changedTimeInterval = [[NSDate date] timeIntervalSinceDate:self.lastChangeDate];
    if (changedTimeInterval < 0.15) {
        //存在一个BUG 当快速切换动画方向不同的时候会有一个Crash 所以加了一个保护太快就不要动画
        //SourceCache/UIKit/UIKit-3318.16.21/_UIQueuingScrollView.m:499
        //Terminating app due to uncaught exception 'NSInternalInconsistencyException',
        //reason: 'Duplicate states in queue'
        animated = NO;
    }
    self.lastChangeDate = [NSDate date];
    
    UIViewController *viewController = _viewControllers[index];
    [self viewControllerWillLoad:viewController];
    UIPageViewControllerNavigationDirection direction = self.currentViewControllerIndex > index ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    [self.pageViewController setViewControllers:@[viewController] direction:direction animated:animated completion:nil];
    self.currentViewControllerIndex = index;
}


#pragma mark -
#pragma mark Template View Controller Transition

- (void)viewControllersDidTransitToIndex:(NSUInteger)index{
    
}

- (void)viewControllerWillLoad:(UIViewController *)viewController{
    
}


#pragma mark -
#pragma mark UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (_scrollEnable) {
        NSInteger index = [_viewControllers indexOfObject:viewController];
        index --;
        if (index < 0 || index == NSNotFound) {
            return nil;
        }
        [self viewControllerWillLoad:_viewControllers[index]];
        return _viewControllers[index];
    } else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (_scrollEnable) {
        NSInteger index = [_viewControllers indexOfObject:viewController];
        index ++;
        if (index > [_viewControllers count] - 1) {
            return nil;
        }
        [self viewControllerWillLoad:_viewControllers[index]];
        return _viewControllers[index];
    } else {
        return nil;
    }
}

#pragma mark -
#pragma mark  UIPageViewControllerDelegate

//- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
//    NSInteger index = [_viewControllers indexOfObject:[pendingViewControllers firstObject]];
//    [self viewControllersWillTransitToIndex:index];
//}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    self.currentViewControllerIndex = [_viewControllers indexOfObject:[pageViewController.viewControllers firstObject]];
    [self viewControllersDidTransitToIndex:self.currentViewControllerIndex];
}

@end
