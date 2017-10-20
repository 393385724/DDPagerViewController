//
//  DDPageViewController.m
//  DDPage
//
//  Created by 李林刚 on 2017/10/13.
//  Copyright © 2017年 huami. All rights reserved.
//
//see more http://www.cocoachina.com/industry/20140523/8528.html

#import "DDPageViewController.h"
#import "DDPageChildViewControllerProtocol.h"
#import "UIScrollView+DDPage.h"

/**
 页面滑动方向
 
 - DDPageViewControllerNavigationDirectionLeft: right-to-left
 - DDPageViewControllerNavigationDirectionRight: left-to-right
 */
typedef NS_ENUM(NSUInteger, DDPageViewControllerNavigationDirection) {
    DDPageViewControllerNavigationDirectionLeft,
    DDPageViewControllerNavigationDirectionRight,
};

@interface DDPageViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic, readwrite) IBOutlet UIScrollView *myScrollView;

@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIViewController *> *viewControllerCacheDict;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *childContentHeightDict;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *childContentOffsetYDict;

@property (nonatomic, assign) BOOL firstWillLayoutSubViews;
@property (nonatomic, assign) BOOL firstWillAppear;

@property (nonatomic, assign) NSInteger lastSelectedIndex;
@property (nonatomic, assign, readwrite) NSInteger currentSelectedIndex;

@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, assign) NSInteger tmpWillSelectedIndex;
@property (nonatomic, assign) BOOL shouldRecoverChildVerticalOffset;

@end

@implementation DDPageViewController

- (void)dealloc {
    self.delegate = nil;
    self.dataSource = nil;
    self.myScrollView.delegate = nil;
    [self p_removeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.firstWillLayoutSubViews = YES;
    
    if ([self.dataSource respondsToSelector:@selector(initViewControllerIndexInPageViewController:)]) {
        self.currentSelectedIndex = [self.dataSource initViewControllerIndexInPageViewController:self];
        self.lastSelectedIndex = self.currentSelectedIndex;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.firstWillAppear) {
        UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(screenEdgePanGestureRecognizerInPageViewController:)]) {
            screenEdgePanGestureRecognizer = [self.dataSource screenEdgePanGestureRecognizerInPageViewController:self];
        }
        if (!screenEdgePanGestureRecognizer) {
            if (self.navigationController.view.gestureRecognizers.count > 0){
                for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers){
                    if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
                        screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                        break;
                    }
                }
            }
        }
        if (screenEdgePanGestureRecognizer) {
            [self.myScrollView.panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];
        }
        [self p_updateScrollViewLayoutIfNeed];
        self.firstWillAppear = NO;
    }
    self.shouldRecoverChildVerticalOffset = YES;
    [[self p_viewControllerAtIndex:self.currentSelectedIndex] beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self p_viewControllerAtIndex:self.currentSelectedIndex] endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self p_viewControllerAtIndex:self.currentSelectedIndex] beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[self p_viewControllerAtIndex:self.currentSelectedIndex] endAppearanceTransition];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self p_updateScrollViewLayoutIfNeed];
    if (self.firstWillLayoutSubViews) {
        [self p_updateScrollViewDisplayIndexIfNeed];
        self.firstWillLayoutSubViews = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.viewControllerCacheDict removeAllObjects];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    //返回NO，是为了更好的手动管理appearance callbacks
    return NO;
}
#pragma mark - Public Methods

- (UIViewController *)currentViewController {
    return [self p_viewControllerAtIndex:self.currentSelectedIndex];
}

- (NSInteger)indexOfViewController:(UIViewController *)viewController {
    for (NSNumber *key in self.viewControllerCacheDict) {
        if (viewController == self.viewControllerCacheDict[key]) {
            return [key integerValue];
        }
    }
    return  -1;
}


- (void)reloadPage {
    [self p_reset];
    UIViewController *currentViewController = [self p_viewControllerAtIndex:self.currentSelectedIndex];
    [self p_addVisibleViewContorller:currentViewController];
    [self p_updateScrollViewLayoutIfNeed];
    [self switchToIndex:self.currentSelectedIndex animated:YES];
}

- (void)switchToIndex:(NSUInteger)index animated:(BOOL)animated {
    if (![self p_validIndex:index]) {
        return;
    }
    if (CGRectGetWidth(self.myScrollView.frame) <= 0 ||
        self.myScrollView.contentSize.width <= 0) {
        NSLog(@"[WARN] need set frame && contentSize");
        return;
    }
    if (self.currentSelectedIndex == index) {
        NSLog(@"[WARN] switchToIndex:%lu same to current index:%ld",(unsigned long)index,(long)self.currentSelectedIndex);
        return;
    }
    self.shouldRecoverChildVerticalOffset = NO;

    NSInteger oldSelectIndex = self.lastSelectedIndex;
    self.lastSelectedIndex = self.currentSelectedIndex;
    self.currentSelectedIndex = index;
    
    UIViewController *fromViewController = [self p_viewControllerAtIndex:self.lastSelectedIndex];
    UIViewController *toViewController = [self p_viewControllerAtIndex:self.currentSelectedIndex];
    
    [self p_addVisibleViewContorller:toViewController];
    
    [self p_willTransitionFromViewController:fromViewController toViewController:toViewController];

    [self switchBegainFrom:self.lastSelectedIndex toIndex:self.currentSelectedIndex animated:animated];
    
    if (animated && self.currentSelectedIndex != self.lastSelectedIndex) {
        
        DDPageViewControllerNavigationDirection direction = (self.lastSelectedIndex < self.currentSelectedIndex) ? DDPageViewControllerNavigationDirectionRight : DDPageViewControllerNavigationDirectionLeft;
        
        CGSize pageSize = self.myScrollView.frame.size;
        UIView *lastView = fromViewController.view;
        UIView *currentView = toViewController.view;
        
        UIViewController *oldViewController = [self p_viewControllerAtIndex:oldSelectIndex];
        UIView *oldView = oldViewController.view;
        NSInteger backgroundIndex = [self.myScrollView ddPage_calculateIndexWithOffsetX:self.myScrollView.contentOffset.x pageWidth:self.myScrollView.frame.size.width];
        UIView *backgroundView = nil;
        if (oldView.layer.animationKeys.count > 0 && lastView.layer.animationKeys.count > 0) {
            //这里考虑的是第一次动画还没结束，就开始第二次动画，需要把当前的处的位置的view给隐藏掉，避免出现一闪而过的情形。
            UIView *tmpView = [self p_viewControllerAtIndex:backgroundIndex].view;
            if (tmpView != currentView && tmpView != lastView) {
                backgroundView = tmpView;
                backgroundView.hidden = YES;
            }
        }
        //这里考虑的是第一次动画还没结束，就开始第二次动画，需要把之前的动画给结束掉，oldselectindex 就是第一个动画选择的index
        [self.myScrollView.layer removeAllAnimations];
        [oldView.layer removeAllAnimations];
        [lastView.layer removeAllAnimations];
        [currentView.layer removeAllAnimations];
        
        //这里需要还原第一次切换的view的位置
        [self p_moveBackToOriginPositionIfNeeded:oldView index:oldSelectIndex];
        
        //下面就是lastview 切换到currentview的代码，direction则是切换的方向，这里把lastview和currentview 起始放到了相邻位置在动画结束的时候，还原位置。
        [self.myScrollView bringSubviewToFront:lastView];
        [self.myScrollView bringSubviewToFront:currentView];
        lastView.hidden = NO;
        currentView.hidden = NO;
        
        CGPoint lastViewStartOrigin = lastView.frame.origin;
        CGPoint currentViewStartOrigin = lastViewStartOrigin;
        CGFloat offset = direction == DDPageViewControllerNavigationDirectionRight ? self.myScrollView.frame.size.width : -self.myScrollView.frame.size.width;
        currentViewStartOrigin.x += offset;
        
        CGPoint lastViewAnimationOrgin = lastViewStartOrigin;
        lastViewAnimationOrgin.x -= offset;
        CGPoint currentViewAnimationOrgin = lastViewStartOrigin;
        CGPoint lastViewEndOrigin = lastViewStartOrigin;
        CGPoint currentViewEndOrgin =  currentView.frame.origin;
        
        lastView.frame = CGRectMake(lastViewStartOrigin.x, lastViewStartOrigin.y, pageSize.width, pageSize.height);
        
        currentView.frame = CGRectMake(currentViewStartOrigin.x, currentViewStartOrigin.y, pageSize.width, pageSize.height);
        
        CGFloat duration = 0.25;
        [UIView animateWithDuration:duration animations:^{
            lastView.frame = CGRectMake(lastViewAnimationOrgin.x, lastViewAnimationOrgin.y, pageSize.width, pageSize.height);
            currentView.frame = CGRectMake(currentViewAnimationOrgin.x, currentViewAnimationOrgin.y, pageSize.width, pageSize.height);
        }  completion:^(BOOL finished) {
            if (finished) {
                CGSize pageSize = self.myScrollView.frame.size;
                lastView.frame = CGRectMake(lastViewEndOrigin.x, lastViewEndOrigin.y, pageSize.width, pageSize.height);
                currentView.frame = CGRectMake(currentViewEndOrgin.x, currentViewEndOrgin.y, pageSize.width, pageSize.height);
                backgroundView.hidden = NO;
                [self p_moveBackToOriginPositionIfNeeded:currentView index:self.currentSelectedIndex];
                [self p_moveBackToOriginPositionIfNeeded:lastView index:self.lastSelectedIndex];
                [self switchEndFromIndex:self.lastSelectedIndex toIndex:self.currentSelectedIndex];
            }
        }];
    } else {
        [self switchEndFromIndex:self.lastSelectedIndex toIndex:self.currentSelectedIndex];
    }
}

#pragma mark - Switch animation

- (void)switchBegainFrom:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated{
    UIViewController *fromViewController = [self p_viewControllerAtIndex:fromIndex];
    UIViewController *toViewController = [self p_viewControllerAtIndex:toIndex];
    [toViewController beginAppearanceTransition:YES animated:animated];
    if (fromIndex != toIndex && fromViewController) {
        [fromViewController beginAppearanceTransition:NO animated:animated];
    }
}

- (void)switchEndFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    [self.myScrollView setContentOffset:[self.myScrollView ddPage_calculateOffsetWithIndex:toIndex width:self.myScrollView.frame.size.width maxWidth:self.myScrollView.contentSize.width] animated:NO];
    UIViewController *fromViewController = [self p_viewControllerAtIndex:fromIndex];
    UIViewController *toViewController = [self p_viewControllerAtIndex:toIndex];
    [toViewController endAppearanceTransition];
    if (fromIndex != toIndex && fromViewController) {
        [fromViewController endAppearanceTransition];
    }
    [self p_didTransitionFromViewController:fromViewController toViewController:toViewController];
}

#pragma mark - Private Methods

- (void)p_reset {
    [self.viewControllerCacheDict removeAllObjects];
    [self p_removeObserver];
    for (UIViewController *viewController in self.childViewControllers) {
        [self p_removeChildViewController:viewController];
    }
}

- (BOOL)p_validIndex:(NSInteger)index {
    if (index < 0 || index >= [self p_numberOfViewControllers]) {
        NSLog(@"[ERROR] invalid index:%ld in bounds[0 ... %ld]",(long)index,(long)[self p_numberOfViewControllers]);
        return NO;
    } else {
        return YES;
    }
}

- (NSInteger)p_numberOfViewControllers {
    return [self.dataSource numberOfViewControllersInPageViewController:self];
}

- (UIViewController *)p_viewControllerAtIndex:(NSInteger)index{
    if ([self.viewControllerCacheDict objectForKey:@(index)]) {
        return self.viewControllerCacheDict[@(index)];
    } else {
        UIViewController *viewController = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(ddPageViewController:viewControllerAtIndex:)]) {
            viewController = [self.dataSource ddPageViewController:self viewControllerAtIndex:index];
        }
        if (viewController && [viewController conformsToProtocol:@protocol(DDPageChildViewControllerProtocol)]) {
            [self p_bindViewController:(UIViewController<DDPageChildViewControllerProtocol> *)viewController withIndex:index];
        }
        if (viewController) {
            [self.viewControllerCacheDict setObject:viewController forKey:@(index)];
            [self p_addVisibleViewContorller:viewController];
        }
        return viewController;
    }
}

- (void)p_addVisibleViewContorllerWithIndex:(NSInteger)index{
    if (index < 0 || index > [self p_numberOfViewControllers]) {
        NSLog(@"[ERROR] invalid index:%ld add max index:%ld",(long)index,(long)[self p_numberOfViewControllers]);
        return;
    }
    UIViewController *viewController = [self p_viewControllerAtIndex:index];
    [self p_addVisibleViewContorller:viewController];
}

- (void)p_addVisibleViewContorller:(UIViewController *)viewController{
    if (!viewController) {
        NSLog(@"[ERROR] add childViewController is nil");
        return;
    }
    if (![self.childViewControllers containsObject:viewController]) {
        [self addChildViewController:viewController];
        if (![self.myScrollView.subviews containsObject:viewController.view]) {
            [self.myScrollView addSubview:viewController.view];
        }
        [self didMoveToParentViewController:viewController];
    }
    NSInteger index = [self.childViewControllers indexOfObject:viewController];
    CGRect childViewFrame = [self.myScrollView ddPage_calculateVisibleViewControllerFrameWithIndex:index];
    viewController.view.frame = childViewFrame;
}

- (void)p_removeChildViewController:(UIViewController *)controller{
    [controller willMoveToParentViewController:self];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

- (void)p_updateScrollViewDisplayIndexIfNeed{
    if (self.myScrollView.frame.size.width > 0)  {
        UIViewController *viewController = [self p_viewControllerAtIndex:self.currentSelectedIndex];
        [self p_addVisibleViewContorller:viewController];
        CGPoint newOffset = [self.myScrollView ddPage_calculateOffsetWithIndex:self.currentSelectedIndex width:self.myScrollView.frame.size.width maxWidth:self.myScrollView.contentSize.width];
        if (newOffset.x != self.myScrollView.contentOffset.x || newOffset.y != self.myScrollView.contentOffset.y) {
            self.myScrollView.contentOffset = newOffset;
        }
        viewController.view.frame = [self.myScrollView ddPage_calculateVisibleViewControllerFrameWithIndex:self.currentSelectedIndex];
    }
}

- (void)p_updateScrollViewLayoutIfNeed{
    if (self.myScrollView.frame.size.width > 0) {
        CGFloat width = [self p_numberOfViewControllers] * self.myScrollView.frame.size.width;
        [self.myScrollView ddPage_updateScrollViewContentWith:width];
    }
}

- (void)p_moveBackToOriginPositionIfNeeded:(UIView *)view index:(NSInteger)index{
    if (![self p_validIndex:index] ||
        !view) {
        return;
    }
    UIView *destView = view;
    CGPoint originPostion = [self.myScrollView ddPage_calculateOffsetWithIndex:index width:self.myScrollView.frame.size.width maxWidth:self.myScrollView.contentSize.width];
    if (destView.frame.origin.x != originPostion.x) {
        CGRect newFrame = destView.frame;
        newFrame.origin = originPostion;
        destView.frame = newFrame;
    }
}

- (void)p_willTransitionFromViewController:(UIViewController *)fromViewController
                          toViewController:(UIViewController *)toViewController {
    self.shouldRecoverChildVerticalOffset = YES;
    if ([self.delegate respondsToSelector:@selector(ddPageViewController:willTransitionFromViewController:toViewController:)]) {
        [self.delegate ddPageViewController:self willTransitionFromViewController:fromViewController toViewController:toViewController];
    }
}

- (void)p_didTransitionFromViewController:(UIViewController *)fromViewController
                         toViewController:(UIViewController *)toViewController {
    if ([fromViewController conformsToProtocol:@protocol(DDPageChildViewControllerProtocol) ]) {
        [(UIViewController <DDPageChildViewControllerProtocol>*)fromViewController preferScrollView].scrollsToTop = NO;
    }
    if ([toViewController conformsToProtocol:@protocol(DDPageChildViewControllerProtocol) ]) {
        [(UIViewController <DDPageChildViewControllerProtocol>*)toViewController preferScrollView].scrollsToTop = YES;
    }
    if ([self.delegate respondsToSelector:@selector(ddPageViewController:didTransitionFromViewController:toViewController:)]) {
        [self.delegate ddPageViewController:self didTransitionFromViewController:fromViewController toViewController:toViewController];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.myScrollView) {
        self.tmpWillSelectedIndex = self.currentSelectedIndex;
        self.lastContentOffset = scrollView.contentOffset;
        if (self.delegate && [self.delegate respondsToSelector:@selector(ddPageViewController:didChangeContentOffset:)]) {
            [self.delegate ddPageViewController:self didChangeContentOffset:scrollView];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.myScrollView) {
        if (!scrollView.isDragging) {
            return;
        }
        CGFloat currentOffsetX = scrollView.contentOffset.x;
        CGFloat width = scrollView.frame.size.width;
        
        NSInteger tmpLastWillSelectedIndex = [self p_validIndex:self.tmpWillSelectedIndex] ? self.tmpWillSelectedIndex : self.currentSelectedIndex;
        if (self.lastContentOffset.x < currentOffsetX){
            self.tmpWillSelectedIndex = ceil(currentOffsetX/width);
        } else {
            self.tmpWillSelectedIndex = floor(currentOffsetX/width);
        }
        if (![self p_validIndex:self.tmpWillSelectedIndex]) {
            return;
        }
        if (self.tmpWillSelectedIndex != tmpLastWillSelectedIndex && self.tmpWillSelectedIndex != self.currentSelectedIndex) {
            self.shouldRecoverChildVerticalOffset = NO;
            
            UIViewController *fromViewController = [self p_viewControllerAtIndex:self.currentSelectedIndex];
            UIViewController *toViewController = [self p_viewControllerAtIndex:self.tmpWillSelectedIndex];
            
            [self p_willTransitionFromViewController:fromViewController toViewController:toViewController];

            [toViewController beginAppearanceTransition:YES animated:YES];
            if (tmpLastWillSelectedIndex == self.currentSelectedIndex) {
                [fromViewController beginAppearanceTransition:NO animated:YES];
            } else {
                UIViewController *lastGuessViewController = [self p_viewControllerAtIndex:tmpLastWillSelectedIndex];
                [lastGuessViewController beginAppearanceTransition:NO animated:YES];
                [lastGuessViewController endAppearanceTransition];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(ddPageViewController:didChangeContentOffset:)]) {
            [self.delegate ddPageViewController:self didChangeContentOffset:scrollView];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.myScrollView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ddPageViewController:didChangeContentOffset:)]) {
            [self.delegate ddPageViewController:self didChangeContentOffset:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.myScrollView) {
        NSInteger oldIndex = self.currentSelectedIndex;
        NSInteger newIndex = [self.myScrollView ddPage_calculateIndexWithOffsetX:scrollView.contentOffset.x  pageWidth:scrollView.frame.size.width];
        self.currentSelectedIndex = newIndex;
        if (oldIndex == newIndex) {
            if ([self p_validIndex:self.tmpWillSelectedIndex]) {
                UIViewController *lastGuessViewController = [self p_viewControllerAtIndex:self.tmpWillSelectedIndex];
                UIViewController *oldViewController = [self p_viewControllerAtIndex:oldIndex];
                [oldViewController beginAppearanceTransition:YES animated:YES];
                [oldViewController endAppearanceTransition];
                [lastGuessViewController beginAppearanceTransition:NO animated:YES];
                [lastGuessViewController endAppearanceTransition];

                [self p_didTransitionFromViewController:oldViewController toViewController:lastGuessViewController];
            }
        } else {
            UIViewController *newViewController = [self p_viewControllerAtIndex:newIndex];
            UIViewController *oldViewController = [self p_viewControllerAtIndex:oldIndex];
            [newViewController endAppearanceTransition];
            [oldViewController endAppearanceTransition];
            
            [self p_didTransitionFromViewController:oldViewController toViewController:newViewController];
        }
        self.tmpWillSelectedIndex = self.currentSelectedIndex;
        self.lastContentOffset = scrollView.contentOffset;
        if (self.delegate && [self.delegate respondsToSelector:@selector(ddPageViewController:didChangeContentOffset:)]) {
            [self.delegate ddPageViewController:self didChangeContentOffset:scrollView];
        }
    }
}

#pragma mark - NSKeyValueObserverRegistration

- (void)p_removeObserver{
    for (UIViewController *viewController in self.viewControllerCacheDict.allValues) {
        if ([viewController conformsToProtocol:@protocol(DDPageChildViewControllerProtocol)]) {
            UIScrollView *scrollView = [(UIViewController<DDPageChildViewControllerProtocol> *)viewController preferScrollView];
            [scrollView removeObserver:self forKeyPath:@"contentOffset"];
            [scrollView removeObserver:self forKeyPath:@"contentSize"];
        }
    }
}

- (void)p_bindViewController:(UIViewController<DDPageChildViewControllerProtocol> *)viewController withIndex:(NSInteger)index{
    UIScrollView *scrollView = [viewController preferScrollView];
    scrollView.scrollsToTop = NO;
    scrollView.ddPageIndex = index;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    if ([self.dataSource respondsToSelector:@selector(ddPageViewController:pageTopOffsetAtIndex:)]) {
        UIEdgeInsets contentInset = scrollView.contentInset;
        CGFloat offsetY = [self.dataSource ddPageViewController:self pageTopOffsetAtIndex:index];
        scrollView.contentInset =  UIEdgeInsetsMake(offsetY, contentInset.left, contentInset.bottom, contentInset.right);
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
        }
#endif
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    UIScrollView *scrollView = object;
    NSInteger index = scrollView.ddPageIndex;

    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (scrollView.contentSize.height == 0) {
            return;
        }
        BOOL shouldScrollWithPageOffset = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(shouldScrollWithPageOffsetInPageViewController:)]) {
            shouldScrollWithPageOffset = [self.delegate shouldRecoverPageOffsetInPageViewController:self];
        }
        if (!shouldScrollWithPageOffset || !self.shouldRecoverChildVerticalOffset) {
            return;
        }
        NSLog(@"contentOffset:%f",scrollView.contentOffset.y);
        
        CGFloat currentContentOffsetY = scrollView.contentOffset.y;
        NSNumber *currentContentHeight = self.childContentHeightDict[@(index)];
        if (currentContentHeight && ceil([currentContentHeight floatValue]) == ceil(scrollView.contentSize.height)) {
            self.childContentOffsetYDict[@(index)] = @(currentContentOffsetY);
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(ddPageViewController:childDidChangeContentOffsetY:)]) {
            [self.delegate ddPageViewController:self childDidChangeContentOffsetY:currentContentOffsetY];
        }
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        if (scrollView.contentSize.height == 0) {
            return;
        }
        NSNumber *lastContentHeight = self.childContentHeightDict[@(index)];
        CGFloat currentContentHeigt = ceil(scrollView.contentSize.height);
        if (lastContentHeight && (ceil([lastContentHeight floatValue]) != ceil(currentContentHeigt))) {
            self.childContentHeightDict[@(index)] = @(currentContentHeigt);
            NSNumber *lastContentOffsetY = self.childContentOffsetYDict[@(index)];
            if (lastContentOffsetY) {
                scrollView.contentOffset = CGPointMake(0, [lastContentOffsetY floatValue]);
            }
        } else {
            self.childContentHeightDict[@(index)] = @(currentContentHeigt);
        }
    }
}

#pragma mark - Getter and Setter

- (NSMutableDictionary<NSNumber *,UIViewController *> *)viewControllerCacheDict {
    if (!_viewControllerCacheDict) {
        _viewControllerCacheDict = [[NSMutableDictionary alloc] init];
    }
    return _viewControllerCacheDict;
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)childContentHeightDict {
    if (!_childContentHeightDict) {
        _childContentHeightDict = [[NSMutableDictionary alloc] init];
    }
    return _childContentHeightDict;
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)childContentOffsetYDict {
    if (!_childContentOffsetYDict) {
        _childContentOffsetYDict = [[NSMutableDictionary alloc] init];
    }
    return _childContentOffsetYDict;
}

@end
