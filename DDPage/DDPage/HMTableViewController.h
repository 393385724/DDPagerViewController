//
//  HMTableViewController.h
//  DDPage
//
//  Created by 李林刚 on 2017/10/16.
//  Copyright © 2017年 huami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageChildViewControllerProtocol.h"

@interface HMTableViewController : UIViewController<DDPageChildViewControllerProtocol>

@property (nonatomic, assign) NSInteger number;

@end
