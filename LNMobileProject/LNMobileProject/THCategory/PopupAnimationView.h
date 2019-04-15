//
//  ChangePasswordView.h
//  FenMiao
//
//  Created by 童浩 on 2017/9/14.
//  Copyright © 2017年 童小浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupAnimationView : UIView
@property (nonatomic,copy)void (^clickRootViewBlock)(void); //点击view回调
@property (nonatomic,copy)void (^clickViewBlock)(void); //点击view回调
@property (nonatomic,strong)UIView *rootView; //弹出view
+ (UIViewController*)topViewController;
- (void)showView; //出现
- (void)showViewRootView:(UIView *)rootView;
- (void)disappearViewBlock:(void(^)(void))block; //消失
@end
