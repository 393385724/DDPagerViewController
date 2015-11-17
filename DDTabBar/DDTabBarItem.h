//
//  DDTabBarItem.h
//  DDPagerControllerDemo
//
//  Created by lilingang on 15/11/16.
//  Copyright © 2015年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DDTabBarItem : NSObject

/**@brief  是否显示Separator, 默认NO*/
@property (nonatomic, assign) BOOL shouldShowSeparator;
@property (nonatomic, strong) UIImage *separatorImage;

/**@brief  是否支持长按*/
@property (nonatomic, assign) BOOL shouldLongPressEvent;
/**@brief  设置显示范围 default zero*/
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
/**@brief  有且仅当图片和文字都有的情况下生效 default 5.0*/
@property (nonatomic, assign) CGFloat imageAndLabelSpace;

@property (nonatomic, strong) UIColor *backgroundNormalColor;
@property (nonatomic, strong) UIColor *backgroundSelectedColor;
@property (nonatomic, strong) UIImage *backgroundNormalImage;
@property (nonatomic, strong) UIImage *backgroundSelectedImage;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, copy, readonly)   NSString *title;
@property (nonatomic, copy, readonly)   NSString *imageNormalName;
@property (nonatomic, copy, readonly)   NSString *imageSelectedName;


- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title
              imageNormalName:(NSString *)imageNormalName
            imageSelectedName:(NSString *)imageSelectedName;

@end
