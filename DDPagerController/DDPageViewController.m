//
//  DDPageViewController.m
//  DDPagerControllerDemo
//
//  Created by lilingang on 15/11/17.
//  Copyright (c) 2015年 LeeLingang. All rights reserved.
//

#import "DDPageViewController.h"

@interface DDPageViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation DDPageViewController


#pragma mark -
#pragma mark Accessor

-(void)setBounces:(BOOL)bounces{
    self.scrollView.bounces = bounces;
}

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIView *view in self.view.subviews ) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            self.scrollView = (UIScrollView *)view;
        }
    }
}

@end
