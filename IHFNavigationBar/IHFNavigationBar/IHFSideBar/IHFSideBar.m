//
//  IHFSideBar.m
//  IHFSideBar
//
//  Created by chenjiasong on 16/8/17.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import "IHFSideBar.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface IHFSideBar ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic ,strong) UIViewController *parentController;
@property BOOL isCurrentPanGestureTarget;
@property CGPoint panStartPoint;

@property (assign,nonatomic) BOOL showSpringAnimation;
@property (assign,nonatomic) BOOL dismissSpringAnimation;

@end

@implementation IHFSideBar

#pragma mark - system init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSideBar];
    }
    return self;
}

- (instancetype)initWithIsShowFromRight:(BOOL)showFromRight {
    self = [super init];
    if (self) {
        _showFromRight = showFromRight;
        [self initSideBar];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom method
- (void)initSideBar {
    
    _hasShown = NO;
    self.isCurrentPanGestureTarget = NO;
    self.animationDuration = 0.4f;

    [self initBackgroundView];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)initBackgroundView {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        //  To show Translucent view !
        CGRect translucentFrame =
        CGRectMake(self.showFromRight ? self.view.bounds.size.width : -self.sideBarWidth, 0, self.sideBarWidth, self.view.bounds.size.height);
        
        self.backgroundView = [[UIView alloc] initWithFrame:translucentFrame];
        self.backgroundView.frame = translucentFrame;
        self.backgroundView.contentMode = _showFromRight ? UIViewContentModeTopRight : UIViewContentModeTopLeft;
        self.backgroundView.clipsToBounds = YES;
        self.backgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];

        [self.view.layer insertSublayer:self.backgroundView.layer atIndex:0];
    }
}

#pragma mark - Layout
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if ([self isViewLoaded] && self.view.window != nil) {
        [self layoutSubviews];
    }
}

- (void)layoutSubviews {
    CGFloat x = self.showFromRight ? self.parentViewController.view.bounds.size.width - self.sideBarWidth : 0;
    
    if (self.contentView != nil) {
        self.contentView.frame = CGRectMake(x, 0, self.sideBarWidth, self.parentViewController.view.bounds.size.height);
    }
}

#pragma mark - appearance

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundView.backgroundColor = backgroundColor;
}

#pragma mark - Show
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated {
    
    _parentController = controller;
    _showSpringAnimation = animated;
    
    if ([self.delegate respondsToSelector:@selector(sideBar:willAppear:)]) {
        [self.delegate sideBar:self willAppear:animated];
    }
    
    [self addToParentViewController:controller callingAppearanceMethods:YES];
    
    CGFloat parentWidth = self.view.bounds.size.width;
    CGRect sideBarFrame = self.view.bounds;
    
    sideBarFrame.origin.x = self.showFromRight ? parentWidth - self.sideBarWidth : 0;
    sideBarFrame.size.width = self.sideBarWidth;
    
    // First have it frame
    if (self.contentView != nil) {
        self.contentView.frame = sideBarFrame;
    }
    self.backgroundView.frame = sideBarFrame;

    CGFloat toValue = self.showFromRight ? -self.sideBarWidth : self.sideBarWidth;
    
    [self animateToValue:toValue forView:self.parentController.view duration:self.animationDuration];
    
    if (animated) {
        [self showSpringAnimationForView:self.view toValue:-toValue duration:self.animationDuration];
    }else{
        [self animateToValue:-toValue forView:self.view duration:self.animationDuration];
    }
}

- (void)showAnimated:(BOOL)animated {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController != nil) {
        controller = controller.presentedViewController;
    }
    [self showInViewController:controller animated:animated];
}

- (void)show {
    [self showAnimated:YES];
}

#pragma mark - Dismiss
- (void)dismiss {
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    
    if ([self.delegate respondsToSelector:@selector(sideBar:willDisappear:)]) {
        [self.delegate sideBar:self willDisappear:animated];
    }
    
    _dismissSpringAnimation = animated;
    
    if (animated) {
        [self showSpringAnimationForView:self.parentController.view toValue:0 duration:self.animationDuration];
    } else {
        [self animateToValue:0 forView:self.parentController.view duration:self.animationDuration];
    }
}

#pragma mark - Gesture Handler
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    if (!CGRectContainsPoint(self.backgroundView.frame, location)) {
        [self dismissAnimated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != gestureRecognizer.view) { // If the gesture is in
        return NO;
    }
    return YES;
}

- (void)setParentController:(UIViewController *)parentController {
    
    _parentController = parentController;
}

#pragma mark - Content View

- (void)setContentView:(UIView *)contentView{
    
    NSAssert(contentView, @"SideBar content can't be nil");
    
    if (!contentView) return;
    
    [_contentView removeFromSuperview];
    _contentView = contentView;
    
    self.sideBarWidth = contentView.bounds.size.width; // side bar width according to content view
    [self.view addSubview:_contentView];
}

#pragma mark - Helper
- (void)addToParentViewController:(UIViewController *)parentViewController callingAppearanceMethods:(BOOL)callAppearanceMethods {
    
    if (self.parentViewController != nil) {
        [self removeFromParentViewControllerCallingAppearanceMethods:callAppearanceMethods];
    }
    
    // Before add subview finish ,  it will call viewWillAppear.
    // after add subview finish ,  it will call viewDidAppear.
    
    // Under normal condisions , the appearance callbacks will be auto!
    // But it have limitations，it must be both new and old child ViewController switch , and both can not be nil . beacuse it to ensure that the new and old have the same parentViewController VC . And the parameters of the viewController can not is the container of the system, such as not UINavigationController or UITabbarController, etc.
    
    // So we manual to call viewWillAppear and viewDidAppear in the right time .
    // using [self beginAppearanceTransition:YES animated:NO] to call viewWillAppear .
    // using [self endAppearanceTransition] to call viewDidAppear.
    
    if (callAppearanceMethods) [self beginAppearanceTransition:YES animated:NO];
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:self]; // Notication
    if (callAppearanceMethods) [self endAppearanceTransition];
}

- (void)removeFromParentViewControllerCallingAppearanceMethods:(BOOL)callAppearanceMethods {
    
    if (callAppearanceMethods) [self beginAppearanceTransition:NO animated:NO];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

#pragma mark - animation

- (void)animateToValue:(CGFloat)value forView:(UIView *)view duration:(CFTimeInterval)duration {
    
    CABasicAnimation *anima = [CABasicAnimation animation];
    anima.delegate = self;
    anima.keyPath = @"transform";
    anima.duration = duration;
    anima.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(value, 0, 1)];
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    
    NSString *key = (value != 0) ? @"showSideBar" : @"dismissSideBar";

    [view.layer addAnimation:anima forKey:key];
}

- (void)dismissSpringAnimationForView:(UIView *)view toValue:(CGFloat)toValue duration:(CFTimeInterval)duration {
    
    CABasicAnimation *anima = [CABasicAnimation animation];
    anima.keyPath = @"transform";
    anima.duration = duration;
    anima.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(toValue, 0, 1)];
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:hideAnimation,anima, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationGroup.duration = duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    
    [view.layer addAnimation:animationGroup forKey:nil];
}


- (void)showSpringAnimationForView:(UIView *)view toValue:(CGFloat)toValue duration:(CFTimeInterval)duration {
    
    CABasicAnimation *anima = [CABasicAnimation animation];
    anima.keyPath = @"transform";
    anima.duration = duration;
    anima.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(toValue, 0, 1)];
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *springAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    springAnimation.duration = duration;
    springAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 1.0f)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                               [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    springAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    springAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.delegate = self;
    animationGroup.animations = [NSArray arrayWithObjects:springAnimation,anima, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationGroup.duration = duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;

    NSString *key = (toValue != 0) ? @"showSideBar" : @"dismissSideBar";
    
    [view.layer addAnimation:animationGroup forKey:key];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if(anim == [self.parentController.view.layer animationForKey:@"showSideBar"]) {
        _hasShown = YES;
        self.isCurrentPanGestureTarget = YES;
        if (flag && [self.delegate respondsToSelector:@selector(sideBar:didAppear:)]) {
            [self.delegate sideBar:self didAppear:_showSpringAnimation];
        }
        
    } else if(anim == [self.parentController.view.layer animationForKey:@"dismissSideBar"]) {
        [self removeFromParentViewControllerCallingAppearanceMethods:YES];
        _hasShown = NO;
        self.isCurrentPanGestureTarget = NO;
        if ([self.delegate respondsToSelector:@selector(sideBar:didDisappear:)]) {
            [self.delegate sideBar:self didDisappear:_dismissSpringAnimation];
        }
    }
}

@end
