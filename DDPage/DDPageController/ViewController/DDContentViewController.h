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
    
    //默认垂直方向，偏移补偿，默认0
    CGFloat _defaultTopOffsetCompensation;
}

@property (nonatomic, strong) NSMutableArray *topViews;

/**
 不设置，默认0
 */
@property (nonatomic, assign) NSInteger firstReloadIndex;

/**
 当前显示的ViewController

 @return UIViewController
 */
- (UIViewController *)currentChildViewController;

- (UIView *)preferCoverView;

/**
 页面选项, 默认nil

 @return UIView
 */
- (UIView *)pageSegmentView;

/**
 *  @brief  切换显示的页面
 *
 *  @param index    content中viewController的index
 *  @param animated 是否需要动画
 */
- (void)switchToIndex:(NSUInteger)index animated:(BOOL)animated;

@end
