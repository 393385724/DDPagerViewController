//
//  DDPageViewController.h
//  DDPage
//
//  Created by 李林刚 on 2017/10/13.
//  Copyright © 2017年 huami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageViewControllerProtocol.h"

@interface DDPageViewController : UIViewController

@property (nonatomic, weak) id<DDPageViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<DDPageViewControllerDelegate> delegate;

@property (weak, readonly) UIScrollView *myScrollView;
@property (readonly) NSInteger currentSelectedIndex;

- (UIViewController *)currentViewController;

- (NSInteger)indexOfViewController:(UIViewController *)viewController;

- (void)reloadPage;

- (void)switchToIndex:(NSUInteger)index animated:(BOOL)animated;

@end
