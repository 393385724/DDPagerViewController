//
//  DDContentViewController.h
//  DDPage
//
//  Created by 李林刚 on 2017/10/13.
//  Copyright © 2017年 huami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageViewControllerProtocol.h"

@interface DDContentViewController : UIViewController {
    //pageView显示区域大小，默认UIEdgeInsetsZero
    UIEdgeInsets _containerEdgeInset;
    //是否可以滚动, 默认YES
    BOOL _scrollEnable;
    //是否有bounces效果， 默认NO
    BOOL _bounces;
}

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
 页面顶部安全区域，默认0，自定义页面需要使用该值

 @return CGFloat
 */
- (CGFloat)pageTopSafeArea;

/**
 跟随页面走的

 @return UIView
 */
- (UIView *)pageHeadView;

/**
 页面选项View,实现的话会类似于TableView的Header会悬浮, 默认nil
 
 @return UIView
 */
- (UIView *)pageBarView;

@end
