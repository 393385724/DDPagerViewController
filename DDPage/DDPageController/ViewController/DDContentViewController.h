//
//  DDContentViewController.h
//  DDPage
//
//  Created by 李林刚 on 2017/10/13.
//  Copyright © 2017年 huami. All rights reserved.
//
// 子类的ScrollView最好手动创建

#import <UIKit/UIKit.h>

@class DDPageViewController;

@interface DDContentViewController : UIViewController {
    //pageView显示区域大小，默认UIEdgeInsetsZero
    UIEdgeInsets _containerEdgeInset;
    //是否可以滚动, 默认YES
    BOOL _scrollEnable;
    //是否有bounces效果， 默认NO
    BOOL _bounces;
}

@property (readonly) DDPageViewController *pageViewController;

/**
 不设置，默认0
 */
@property (nonatomic, assign) NSInteger firstReloadIndex;

/**
 当前显示的ViewController

 @return UIViewController
 */
- (UIViewController *)currentChildViewController;

/**
 *  @brief  切换显示的页面
 *
 *  @param index    content中viewController的index
 *  @param animated 是否需要动画
 */
- (void)switchToIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 容器中一共包含的viewController数目，默认0

 @return NSInteger
 */
- (NSInteger)numberOfChildViewControllers;

/**
 根据制定的index生成需要展示的ViewController， 默认nil

 @param index Index
 @return UIViewController
 */
- (UIViewController *)childViewControllerAtIndex:(NSInteger)index;

/**
 页面将要切换toViewController在调用ViewDidApear之前
 
 @param fromViewController 将要消失的页面
 @param toViewController 当前显示的页面
 */
- (void)willTransitionFromViewController:(UIViewController *)fromViewController
                        toViewController:(UIViewController *)toViewController;

/**
 页面已经切换toViewController在调用ViewDidApear之前
 
 @param fromViewController 将要消失的页面
 @param toViewController 当前显示的页面
 */
- (void)didTransitionFromViewController:(UIViewController *)fromViewController
                       toViewController:(UIViewController *)toViewController;

/**
 垂直方向上页面的偏移
 
 @param offsetY 垂直偏移量
 */
- (void)childDidChangeVerticalContentOffsetY:(CGFloat)offsetY;

@end
