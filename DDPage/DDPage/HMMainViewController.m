//
//  HMMainViewController.m
//  DDPage
//
//  Created by 李林刚 on 2017/10/13.
//  Copyright © 2017年 huami. All rights reserved.
//

#import "HMMainViewController.h"
#import "HMContentViewController.h"

@interface HMMainViewController ()

@end

@implementation HMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)buttonAction:(id)sender {
    HMContentViewController *viewController = [[HMContentViewController alloc] init];
    viewController.firstReloadIndex = 4;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
