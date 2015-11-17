//
//  DDTabBarButton.h
//  DDPagerControllerDemo
//
//  Created by lilingang on 15/11/16.
//  Copyright © 2015年 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDTabBarItem;

@interface DDTabBarButton : UIButton

@property (nonatomic, readonly) DDTabBarItem *tabBarItem;

- (instancetype)initWithFrame:(CGRect)frame
                   tabBarItem:(DDTabBarItem *)tabBarItem;

@end
