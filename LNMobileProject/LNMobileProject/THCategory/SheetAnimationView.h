//
//  SheetAnimationView.h
//  GuanTang
//
//  Created by 童浩 on 2018/8/20.
//  Copyright © 2018年 童小浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheetAnimationView : UIView
@property (nonatomic,copy)void (^clickRootViewBlock)(void); //点击view回调
@property (nonatomic,copy)void (^clickViewBlock)(void); //点击view回调
@property (nonatomic,strong)UIView *rootView; //弹出view
- (void)setZhifuRootView:(UIView *)rootView;
- (void)showView; //出现
- (void)showViewRootView:(UIView *)rootView;
- (void)disappearViewBlock:(void(^)(void))block; //消失
@end
