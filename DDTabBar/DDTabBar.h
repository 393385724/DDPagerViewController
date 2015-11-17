//
//  DDTabBar.h
//  DDPagerControllerDemo
//
//  Created by lilingang on 15/11/16.
//  Copyright © 2015年 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDTabBarItem.h"
@class DDTabBar;

typedef NS_OPTIONS(NSUInteger, DDTabBarDisplayOption) {
    DDTabBarDisplayNone                      = 1 << 1, // default
    DDTabBarDisplaySelectedUnderline         = 1 << 2, //**下划线标记选中*/
    DDTabBarDisplaySelectedAnimated          = 1 << 3,
};

@protocol DDTabBarDelegate <NSObject>

@optional
- (void)tabBar:(DDTabBar *)caller didPressedOtherTab:(NSUInteger)tag;
- (void)tabBar:(DDTabBar *)caller didPressedSameTab:(NSUInteger)tag;
- (void)tabBar:(DDTabBar *)caller didLongPressedTag:(NSUInteger)tag;

@end


@interface DDTabBar : UIView

@property (nonatomic, weak) id<DDTabBarDelegate> delegate;
/**@brief  设置背景图*/
@property (nonatomic, strong) UIImage *backGroundImage;

/**@brief  underline 距离顶部的offset, default 0 */
@property (nonatomic, assign) CGFloat underLineBottomOffset;
/**@brief  underline 高度 default 2.0*/
@property (nonatomic, assign) CGFloat underLineHeight;
/**@brief  underline 颜色 default redcolor*/
@property (nonatomic, strong) UIColor *underLineColor;

- (instancetype)initWithFrame:(CGRect)frame
                  tabBarItems:(NSArray *)tabBarItems;

- (instancetype)initWithFrame:(CGRect)frame
                  tabBarItems:(NSArray *)tabBarItems
                 showInBottom:(BOOL)showInBottom
                displayOption:(DDTabBarDisplayOption)displayOption;

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated;

@end
