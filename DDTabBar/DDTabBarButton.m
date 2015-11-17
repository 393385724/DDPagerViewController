//
//  DDTabBarButton.m
//  DDPagerControllerDemo
//
//  Created by lilingang on 15/11/16.
//  Copyright © 2015年 LiLingang. All rights reserved.
//

#import "DDTabBarButton.h"
#import "DDTabBarItem.h"

@interface DDTabBarButton ()

@property (nonatomic, strong) DDTabBarItem *tabBarItem;

@end

@implementation DDTabBarButton

- (id)initWithFrame:(CGRect)frame tabBarItem:(DDTabBarItem *)tabBarItem{
    self = [super initWithFrame:frame];
    if (self) {
        self.tabBarItem = tabBarItem;
        self.backgroundColor = tabBarItem.backgroundNormalColor;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
        self.titleLabel.font = self.tabBarItem.font;

        if (tabBarItem.backgroundNormalImage) {
            [self setBackgroundImage:tabBarItem.backgroundNormalImage forState:UIControlStateNormal];
        }
        if (tabBarItem.backgroundSelectedImage) {
            [self setBackgroundImage:tabBarItem.backgroundSelectedImage forState:UIControlStateSelected];
        }
        if (tabBarItem.imageNormalName) {
            [self setImage:[UIImage imageNamed:tabBarItem.imageNormalName] forState:UIControlStateNormal];
        }
        if (tabBarItem.imageSelectedName) {
            [self setImage:[UIImage imageNamed:tabBarItem.imageSelectedName] forState:UIControlStateSelected];
        }
        if (tabBarItem.titleNormalColor) {
            [self setTitleColor:tabBarItem.titleNormalColor forState:UIControlStateNormal];
        }
        if (tabBarItem.titleSelectedColor) {
            [self setTitleColor:tabBarItem.titleSelectedColor forState:UIControlStateSelected];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        if (self.tabBarItem.backgroundSelectedColor) {
            self.backgroundColor = self.tabBarItem.backgroundSelectedColor;
        }
    } else {
        if (self.tabBarItem.backgroundNormalColor) {
            self.backgroundColor = self.tabBarItem.backgroundNormalColor;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat topEdge = self.tabBarItem.edgeInsets.top;
    CGFloat bottomEdge = self.tabBarItem.edgeInsets.bottom;
    CGFloat leftEdge = self.tabBarItem.edgeInsets.left;
    CGFloat rightEdge = self.tabBarItem.edgeInsets.right;
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    if (self.tabBarItem.title && self.tabBarItem.imageNormalName) {
        
        CGRect frame = CGRectMake(leftEdge, topEdge, width - leftEdge - rightEdge, height - 20 - topEdge - bottomEdge);
        self.imageView.frame = frame;
        
        frame = CGRectMake(leftEdge, width - 20 + topEdge, width - leftEdge - rightEdge, 20 - topEdge - bottomEdge);
        self.titleLabel.frame = frame;
        
    } else if(self.tabBarItem.title){
        
        self.imageView.hidden = YES;
        CGRect frame = CGRectMake(leftEdge, topEdge, width, height);
        self.titleLabel.frame = frame;
        
    } else {
        self.titleLabel.hidden = YES;
        CGRect frame = CGRectMake(leftEdge, topEdge, width, height);
        self.imageView.frame = frame;
    }
}

@end
