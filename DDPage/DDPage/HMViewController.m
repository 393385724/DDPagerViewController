//
//  HMViewController.m
//  DDPage
//
//  Created by 李林刚 on 2017/10/15.
//  Copyright © 2017年 huami. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation HMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = self.labelText;
    NSLog(@"%@ viewDidLoad[%@]",NSStringFromClass([self class]),self.label.text);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@ viewWillAppear[%@]",NSStringFromClass([self class]),self.label.text);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@ viewDidAppear[%@]",NSStringFromClass([self class]),self.label.text);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@ viewWillDisappear[%@]",NSStringFromClass([self class]),self.label.text);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@ viewDidDisappear[%@]",NSStringFromClass([self class]),self.label.text);
}

@end
