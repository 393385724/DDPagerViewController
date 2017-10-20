//
//  HMMainViewController.m
//  DDPage
//
//  Created by 李林刚 on 2017/10/13.
//  Copyright © 2017年 huami. All rights reserved.
//

#import "HMMainViewController.h"
#import "HMContentViewController.h"
#import "HMCustomNavViewController.h"

@interface HMMainViewController ()

@end

@implementation HMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)buttonAction:(id)sender {
    HMContentViewController *viewController = [[HMContentViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (IBAction)customNavButtonAction:(id)sender {
    HMCustomNavViewController *viewController = [[HMCustomNavViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
