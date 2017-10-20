//
//  UIScrollView+DDPage.m
//  DDPage
//
//  Created by 李林刚 on 2017/10/13.
//  Copyright © 2017年 huami. All rights reserved.
//

#import "UIScrollView+DDPage.h"
#import <objc/runtime.h>

static const void *DDPageScrollViewPageIndexKey = &DDPageScrollViewPageIndexKey;

@implementation UIScrollView (DDPage)

- (CGRect)ddPage_calculateVisibleViewControllerFrameWithIndex:(NSInteger)index {
    CGFloat offsetX = 0.0;
    offsetX = index * self.frame.size.width;
    return CGRectMake(offsetX, 0, self.frame.size.width, self.frame.size.height);
}

- (void)ddPage_updateScrollViewContentWith:(CGFloat)width {
    if (width != self.contentSize.width && width > 0) {
        self.contentSize = CGSizeMake(width, self.contentSize.height);
    }
}

- (NSInteger)ddPage_calculateIndexWithOffsetX:(CGFloat)offsetX pageWidth:(CGFloat)pageWidth{
    NSInteger startIndex = (NSInteger)offsetX/pageWidth;
    if (startIndex < 0) {
        startIndex = 0;
    }
    return startIndex;
}

- (CGPoint)ddPage_calculateOffsetWithIndex:(NSInteger)index width:(CGFloat)width maxWidth:(CGFloat)maxWidth {
    CGFloat offsetX = ((index) * width);
    if (offsetX < 0 ){
        offsetX = 0;
    }
    if( maxWidth > 0.0 &&
       offsetX > maxWidth - width){
        offsetX = maxWidth - width;
    }
    return CGPointMake(offsetX, 0);
}

#pragma mark -  Getter and Setter

- (NSInteger)ddPageIndex {
    return [objc_getAssociatedObject(self, DDPageScrollViewPageIndexKey) integerValue];
}

- (void)setDdPageIndex:(NSInteger)ddPageIndex {
    objc_setAssociatedObject(self, DDPageScrollViewPageIndexKey, @(ddPageIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
