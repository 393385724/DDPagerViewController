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

/**
 总共支持的子页面

 @param pageViewController DDPageViewController
 @return NSInteger
 */
- (NSInteger)numberOfViewControllersInPageViewController:(DDPageViewController *)pageViewController;

/**
 根据指定的index创建一个子ViewController

 @param pageViewController DDPageViewController
 @param index 当前的index
 @return UIViewController
 */
- (UIViewController *)ddPageViewController:(DDPageViewController*)pageViewController
                     viewControllerAtIndex:(NSInteger)index;

@optional

/**
 返回默认初始化显示的页面，不设置则是第0个

 @param pageViewController DDPageViewController
 @return NSInteger
 */
- (NSInteger)initViewControllerIndexInPageViewController:(DDPageViewController *)pageViewController;

/**
 pageView顶部的偏移，无特殊需求不必实现

 @param pageViewController DDPageViewController
 @param index NSInteger
 @return NSInteger
 */
- (NSInteger)ddPageViewController:(DDPageViewController*)pageViewController
             pageTopOffsetAtIndex:(NSInteger)index;

@end

@protocol DDPageViewControllerDelegate <NSObject>

@optional

/**
 将要切换页面toViewController在调用ViewWillApear之前

 @param pageViewController DDPageViewController
 @param fromViewController 当前显示的页面
 @param toViewController 将要显示的页面
 */
- (void)ddPageViewController:(DDPageViewController*)pageViewController
willTransitionFromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController;

/**
 页面已经切换toViewController在调用ViewDidApear之前

 @param pageViewController DDPageViewController
 @param fromViewController 将要消失的页面
 @param toViewController 当前显示的页面
 */
- (void)ddPageViewController:(DDPageViewController*)pageViewController
didTransitionFromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController;

/**
 水平方向上页面的偏移

 @param pageViewController DDPageViewController
 @param scrollView UIScrollView
 */
- (void)ddPageViewController:(DDPageViewController*)pageViewController
      didChangeContentOffset:(UIScrollView *)scrollView;

/**
 垂直方向上页面的偏移

 @param pageViewController DDPageViewController
 @param offsetY 垂直偏移量
 */
- (void)ddPageViewController:(DDPageViewController*)pageViewController
childDidChangeContentOffsetY:(CGFloat)offsetY;

@end
