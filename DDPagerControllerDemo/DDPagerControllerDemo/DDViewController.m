//
//  DDViewController.m
//  DDPagerControllerDemo
//
//  Created by lilingang on 15/11/17.
//  Copyright © 2015年 LiLingang. All rights reserved.
//

#import "DDViewController.h"
#import "DDMainContentViewController.h"

@interface DDViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation DDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@"row1"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDMainContentViewController *viewController = [[DDMainContentViewController alloc] init];
    viewController.barOnTop = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
