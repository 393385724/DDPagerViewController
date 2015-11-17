//
//  DDTabBar.m
//  DDPagerControllerDemo
//
//  Created by lilingang on 15/11/16.
//  Copyright © 2015年 LiLingang. All rights reserved.
//

#import "DDTabBar.h"
#import "DDTabBarButton.h"

@interface DDTabBar ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *underlineView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray *tabBarItems;
@property (nonatomic, assign) DDTabBarDisplayOption displayOption;

@end

@implementation DDTabBar

#pragma mark Life cycle
- (instancetype)initWithFrame:(CGRect)frame tabBarItems:(NSArray *)tabBarItems{
    return [self initWithFrame:frame tabBarItems:tabBarItems showInBottom:YES displayOption:DDTabBarDisplayNone];
}

- (instancetype)initWithFrame:(CGRect)frame
                  tabBarItems:(NSArray *)tabBarItems
                 showInBottom:(BOOL)showInBottom
                displayOption:(DDTabBarDisplayOption)displayOption{
    self = [super initWithFrame:frame];
    if (self) {
        self.underLineColor = [UIColor redColor];
        self.underLineHeight = 2.0;
        self.underLineBottomOffset = 0.0;
        self.displayOption = displayOption;
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        CGFloat contentViewTopOffset = showInBottom ? 0 : 20;
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewTopOffset, CGRectGetWidth(frame), CGRectGetHeight(frame) - contentViewTopOffset)];
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.contentView];
        
        self.currentIndex = -1;
        
        [self reloadWithTabBarItems:tabBarItems];
        [self setCurrentIndex:0 animated:NO];
    }
    return self;
}


- (void)reloadWithTabBarItems:(NSArray *)tabBarItems{
    if ([tabBarItems count] == 0) {
        return;
    }
    if (self.tabBarItems != tabBarItems) {
        self.tabBarItems = tabBarItems;
    }
    //clear UI
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[DDTabBarButton class]]) {
            [view removeFromSuperview];
        }
    }
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    CGFloat height = CGRectGetHeight(self.contentView.frame);
    //create  BarButtons
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = roundf(width / [tabBarItems count]);
    CGFloat h = height;
    
    DDTabBarButton *tabBarButton = nil;
    int index = 0;
    for (DDTabBarItem *tabBarItem in tabBarItems) {
        tabBarButton = [[DDTabBarButton alloc] initWithFrame:CGRectMake(x, y, w, h) tabBarItem:tabBarItem];
        tabBarButton.tag = index;
        [tabBarButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        
        if (tabBarItem.shouldLongPressEvent) {
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
            [tabBarButton addGestureRecognizer:longPressGestureRecognizer];
        }
        x += w;
        [self.contentView addSubview:tabBarButton];
        index++;
    }
}

#pragma mark Logic

- (DDTabBarButton *)tabBarButtonForIndex:(NSInteger)index {
    DDTabBarItem *item = [self tabBarItemForIndex:index];
    if (!item) {
        return nil;
    }
    DDTabBarButton *tabBarButton = nil;
    for (DDTabBarButton *button in self.contentView.subviews) {
        if ([button isKindOfClass:[DDTabBarButton class]] && button.tabBarItem == item) {
            tabBarButton = button;
            break;
        }
    }
    return tabBarButton;
}

- (DDTabBarItem *)tabBarItemForIndex:(NSInteger)index{
    if (index < 0 || index >= [self.tabBarItems count]) {
        return nil;
    }
    return [self.tabBarItems objectAtIndex:index];
}

#pragma mark Buttons

- (void)buttonPressed:(DDTabBarButton *)button{
    if (self.currentIndex == button.tag) {
        if ([self.delegate respondsToSelector:@selector(tabBar:didPressedSameTab:)]) {
            [self.delegate tabBar:self didPressedSameTab:button.tag];
        }
    } else {
        [self setCurrentIndex:button.tag animated:YES];
        if ([self.delegate respondsToSelector:@selector(tabBar:didPressedOtherTab:)]) {
            [self.delegate tabBar:self didPressedOtherTab:button.tag];
        }
    }
}

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan && [self.delegate respondsToSelector:@selector(tabBar:didLongPressedTag:)]) {
        UIView *button = gesture.view;
        [self.delegate tabBar:self didLongPressedTag:button.tag];
    }
}


#pragma mark - Getter and Setter

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated{
    if (_currentIndex != currentIndex) {
        DDTabBarButton *oldTabBarButton = [self tabBarButtonForIndex:self.currentIndex];
        oldTabBarButton.selected = NO;
        DDTabBarButton *newTabBarButton = [self tabBarButtonForIndex:currentIndex];
        newTabBarButton.selected = YES;
        if (self.displayOption & DDTabBarDisplaySelectedUnderline) {
            //underline
            CGFloat underlineLeft = CGRectGetMinX(newTabBarButton.frame);
            CGFloat underlineWidth = CGRectGetWidth(newTabBarButton.frame);
            if (!self.underlineView) {
                CGFloat underlineTop = CGRectGetHeight(self.contentView.frame) - self.underLineHeight - self.underLineBottomOffset;
                self.underlineView = [[UIView alloc] initWithFrame:CGRectMake(underlineLeft, underlineTop, underlineWidth, self.underLineHeight)];
                self.underlineView.backgroundColor = self.underLineColor;
                [self.contentView addSubview:self.underlineView];
            }
            CGFloat animationDuration = 0;
            if (self.displayOption & DDTabBarDisplaySelectedAnimated && animated) {
                animationDuration = 0.25;
            }
            [UIView animateWithDuration:animationDuration
                                  delay:0.0f
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 CGRect frame = self.underlineView.frame;
                                 frame.origin.x = underlineLeft;
                                 frame.size.width = underlineWidth;
                                 self.underlineView.frame = frame;
                             } completion:^(BOOL finished) {
                             }];
        }
        _currentIndex = currentIndex;
    }
}

- (void)setBackGroundImage:(UIImage *)backGroundImage{
    _backGroundImage = backGroundImage;
    self.backgroundImageView.image = backGroundImage;
}


@end
