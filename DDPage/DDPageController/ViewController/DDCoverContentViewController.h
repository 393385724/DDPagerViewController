//
//  DDCoverContentViewController.h
//  DDPage
//
//  Created by 李林刚 on 2017/11/8.
//  Copyright © 2017年 huami. All rights reserved.
//

#import "DDContentViewController.h"

@interface DDCoverContentViewController : DDContentViewController

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
