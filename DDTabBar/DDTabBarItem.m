//
//  DDTabBarItem.m
//  DDPagerControllerDemo
//
//  Created by lilingang on 15/11/16.
//  Copyright © 2015年 LiLingang. All rights reserved.
//

#import "DDTabBarItem.h"

@interface DDTabBarItem ()

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *imageNormalName;
@property (nonatomic, copy)   NSString *imageSelectedName;

@end

@implementation DDTabBarItem

- (instancetype)initWithTitle:(NSString *)title{
    return [self initWithTitle:title imageNormalName:nil imageSelectedName:nil];
}

- (instancetype)initWithTitle:(NSString *)title
              imageNormalName:(NSString *)imageNormalName
            imageSelectedName:(NSString *)imageSelectedName{
    self = [super init];
    if (self) {
        self.title = title;
        self.imageNormalName = imageNormalName;
        self.imageSelectedName = imageSelectedName;
        self.edgeInsets = UIEdgeInsetsZero;
        self.imageAndLabelSpace = 5.0;
    }
    return self;
}
@end
