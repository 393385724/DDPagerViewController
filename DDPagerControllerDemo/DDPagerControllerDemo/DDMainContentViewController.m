//
//  DDMainContentViewController.m
//  DDPagerControllerDemo
//
//  Created by lilingang on 15/11/17.
//  Copyright © 2015年 LiLingang. All rights reserved.
//

#import "DDMainContentViewController.h"

#import "DDViewController1.h"
#import "DDViewController2.h"
#import "DDViewController3.h"

#import "DDTabBar.h"

@interface DDMainContentViewController ()<DDTabBarDelegate>

@property (nonatomic, strong) DDTabBar *tabBar;

@end

@implementation DDMainContentViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        DDViewController1 *viewController1 = [[DDViewController1 alloc] init];
        DDViewController2 *viewController2 = [[DDViewController2 alloc] init];
        DDViewController3 *viewController3 = [[DDViewController3 alloc] init];
        _viewControllers = @[viewController1,viewController2,viewController3];
        _scrollEnable = YES;
        _bounces = YES;
        _containerEdgeInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DDTabBarItem *barItem1 = [[DDTabBarItem alloc] initWithTitle:@"bar1"];
    barItem1.backgroundNormalColor = [UIColor blueColor];
    barItem1.backgroundSelectedColor = [UIColor blackColor];
    barItem1.titleNormalColor = [UIColor redColor];
    barItem1.titleSelectedColor = [UIColor whiteColor];
    DDTabBarItem *barItem2 = [[DDTabBarItem alloc] initWithTitle:@"bar2"];
    barItem2.backgroundNormalColor = [UIColor blueColor];
    barItem2.backgroundSelectedColor = [UIColor blackColor];
    barItem2.titleNormalColor = [UIColor redColor];
    barItem2.titleSelectedColor = [UIColor whiteColor];
    barItem2.shouldLongPressEvent = YES;
    DDTabBarItem *barItem3 = [[DDTabBarItem alloc] initWithTitle:@"bar3"];
    barItem3.backgroundNormalColor = [UIColor blueColor];
    barItem3.backgroundSelectedColor = [UIColor blackColor];
    barItem3.titleNormalColor = [UIColor redColor];
    barItem3.titleSelectedColor = [UIColor whiteColor];
    self.tabBar = [[DDTabBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64) tabBarItems:@[barItem1,barItem2,barItem3] showInBottom:NO displayOption:DDTabBarDisplaySelectedAnimated|DDTabBarDisplaySelectedUnderline];
    self.tabBar.backgroundColor = [UIColor redColor];
    self.tabBar.delegate = self;
    [self.view addSubview:self.tabBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewControllerWillLoad:(UIViewController *)viewController{
    
}

- (void)viewControllersDidTransitToIndex:(NSUInteger)index{
    [self.tabBar setCurrentIndex:index animated:NO];
}

#pragma mark -

- (void)tabBar:(DDTabBar *)caller didPressedOtherTab:(NSUInteger)tag{
    NSLog(@"didPressedOtherTab:%lu",(unsigned long)tag);
    [self switchToIndex:tag animated:YES];
}
- (void)tabBar:(DDTabBar *)caller didPressedSameTab:(NSUInteger)tag{
    NSLog(@"didPressedSameTab:%lu",(unsigned long)tag);
}
- (void)tabBar:(DDTabBar *)caller didLongPressedTag:(NSUInteger)tag{
    NSLog(@"didLongPressedTag:%lu",(unsigned long)tag);
}
@end
