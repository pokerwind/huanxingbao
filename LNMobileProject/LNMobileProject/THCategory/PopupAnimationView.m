//
//  ChangePasswordView.m
//  FenMiao
//
//  Created by 童浩 on 2017/9/14.
//  Copyright © 2017年 童小浩. All rights reserved.
//

#import "PopupAnimationView.h"

@interface PopupAnimationView ()
@property (nonatomic,strong)UIView *beijingView;
@end

@implementation PopupAnimationView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, k_mainSize.width, k_mainSize.height);
        self.backgroundColor = [UIColor clearColor];
        self.beijingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, k_mainSize.width, k_mainSize.height)];
        self.beijingView.backgroundColor = [UIColor blackColor];
        self.beijingView.alpha = 0.0;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickViewAction)];
        [self.beijingView addGestureRecognizer:tapGesture];
        [self addSubview:self.beijingView];
    }
    return self;
}
- (void)setRootView:(UIView *)rootView {
    _rootView = rootView;
    _rootView.layer.masksToBounds = YES;
    _rootView.layer.cornerRadius = 10;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(breakVCAction)];
    [_rootView addGestureRecognizer:tapGesture];
    _rootView.center = CGPointMake(k_mainSize.width / 2.0, k_mainSize.height / 2.0);
    [self addSubview:_rootView];
}
- (void)showViewRootView:(UIView *)rootView {
    [rootView addSubview:self];
    self.rootView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:.4 animations:^{
        self.beijingView.alpha = 0.4;
        self.rootView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
+ (UIViewController*)topViewController {
    return [PopupAnimationView topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
//获取当前屏幕显示的viewcontroller
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [PopupAnimationView topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [PopupAnimationView topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [PopupAnimationView topViewControllerWithRootViewController:presentedViewController];
    }
    else {
        return rootViewController;
    }
}
- (void)showView {
    UIView *window = [PopupAnimationView topViewController].view;
    [window addSubview:self];
//#warning ~~~~~
    self.rootView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:.4 animations:^{
        self.beijingView.alpha = 0.4;
        self.rootView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)disappearViewBlock:(void(^)(void))block {
    self.beijingView.alpha = 0.4;
    self.rootView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.4 animations:^{
        self.beijingView.alpha = 0;
        self.rootView.transform = CGAffineTransformMakeScale(.8, .8);
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
//        self.rootView = nil;
        [self removeFromSuperview];
    }];
}
- (void)breakVCAction {
    if (self.clickRootViewBlock) {
        self.clickRootViewBlock();
    }
}
- (void)clickViewAction {
    if (self.clickViewBlock) {
        self.clickViewBlock();
    }
}

@end
