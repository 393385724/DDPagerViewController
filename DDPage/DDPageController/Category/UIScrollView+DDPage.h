//
//  UIScrollView+DDPage.h
//  DDPage
//
//  Created by 李林刚 on 2017/10/13.
//  Copyright © 2017年 huami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (DDPage)

@property (nonatomic, assign) NSInteger ddPageIndex;

- (CGRect)ddPage_calculateVisibleViewControllerFrameWithIndex:(NSInteger)index;

- (void)ddPage_updateScrollViewContentWith:(CGFloat)width;

- (NSInteger)ddPage_calculateIndexWithOffsetX:(CGFloat)offsetX pageWidth:(CGFloat)pageWidth;

- (CGPoint)ddPage_calculateOffsetWithIndex:(NSInteger)index width:(CGFloat)width maxWidth:(CGFloat)maxWidth;

@end
