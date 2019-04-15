//
//  SheetAnimationView.m
//  GuanTang
//
//  Created by 童浩 on 2018/8/20.
//  Copyright © 2018年 童小浩. All rights reserved.
//

#import "SheetAnimationView.h"
#import "PopupAnimationView.h"
@interface SheetAnimationView()
@property (nonatomic,strong)UIView *beijingView;

@end
@implementation SheetAnimationView

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
//    _rootView.layer.masksToBounds = YES;
//    _rootView.layer.cornerRadius = 10;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(breakVCAction)];
    [_rootView addGestureRecognizer:tapGesture];
    _rootView.frame = CGRectMake(rootView.frame.origin.x, k_mainSize.height, rootView.frame.size.width, rootView.frame.size.height);
    [self addSubview:_rootView];
}
- (void)setZhifuRootView:(UIView *)rootView {
    _rootView = rootView;
    _rootView.frame = CGRectMake(rootView.frame.origin.x, k_mainSize.height, rootView.frame.size.width, rootView.frame.size.height);
    [self addSubview:_rootView];
}
- (void)showViewRootView:(UIView *)rootView {
    [rootView addSubview:self];
    [UIView animateWithDuration:.4 animations:^{
        self.beijingView.alpha = 0.4;
        self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, k_mainSize.height - self.rootView.frame.size.height, self.rootView.frame.size.width, self.rootView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)showView {
    UIView *window = kKeyWindow;
    [window addSubview:self];
    //#warning ~~~~~
    [UIView animateWithDuration:.4 animations:^{
        self.beijingView.alpha = 0.4;
        self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, k_mainSize.height - self.rootView.frame.size.height, self.rootView.frame.size.width, self.rootView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)disappearViewBlock:(void(^)(void))block {
    self.beijingView.alpha = 0.4;
    [UIView animateWithDuration:0.4 animations:^{
        self.beijingView.alpha = 0;
        self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, k_mainSize.height, self.rootView.frame.size.width, self.rootView.frame.size.height);
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
