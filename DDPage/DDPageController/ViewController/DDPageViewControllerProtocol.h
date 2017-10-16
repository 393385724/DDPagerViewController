//
//  DDPageViewControllerProtocol.h
//  DDPage
//
//  Created by 李林刚 on 2017/10/16.
//  Copyright © 2017年 huami. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDPageViewController;

@protocol DDPageViewControllerDataSource <NSObject>

@required

- (NSInteger)numberOfViewControllersInPageViewController:(DDPageViewController *)pageViewController;

- (UIViewController *)ddPageViewController:(DDPageViewController*)pageViewController
                     viewControllerAtIndex:(NSInteger)index;

@optional

- (NSInteger)initViewControllerIndexInPageViewController:(DDPageViewController *)pageViewController;

@end

@protocol DDPageViewControllerDelegate <NSObject>

@optional

- (void)ddPageViewController:(DDPageViewController*)pageViewController
willTransitionFromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController;

- (void)ddPageViewController:(DDPageViewController*)pageViewController
didTransitionFromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController;

- (void)ddPageViewController:(DDPageViewController*)pageViewController 
      didChangeContentOffset:(UIScrollView *)scrollView;

- (void)ddPageViewController:(DDPageViewController*)pageViewController
      childDidChangeContentOffset:(UIScrollView *)scrollView;

- (BOOL)shouldRememberPageOffsetInPageViewController:(DDPageViewController *)pageViewController;

@end
