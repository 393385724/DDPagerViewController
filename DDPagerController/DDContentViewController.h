//
//  DDContentViewController.h
//  DDPagerControllerDemo
//
//  Created by lilingang on 15/11/17.
//  Copyright (c) 2015年 LeeLingang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDContentViewController : UIViewController{
    /**@brief  包含需要管理的viewControllers*/
    NSArray *_viewControllers;
    /**@brief  容器的显示区域 */
    UIEdgeInsets _containerEdgeInset;
    /**@brief  是否可以按页滚动 默认YES*/
    BOOL _scrollEnable;
    /**@brief  是否有bounces效果 默认YES*/
    BOOL _bounces;
}

/**@brief  当前显示的ViewController*/
@property (nonatomic, readonly) UIViewController *currentChildViewController;

/**
 *  @brief  切换显示的页面
 *
 *  @param index    content中viewController的index
 *  @param animated 是否需要动画
 */
- (void)switchToIndex:(NSUInteger)index animated:(BOOL)animated;

/** ChildViewController life cycle */
- (void)viewControllersDidTransitToIndex:(NSUInteger)index;
- (void)viewControllerWillLoad:(UIViewController *)viewController;

@end
