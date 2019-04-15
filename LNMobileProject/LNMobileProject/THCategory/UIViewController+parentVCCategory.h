//
//  UIViewController+parentVCCategory.h
//  TadpoleYun
//
//  Created by iOSMac on 2018/5/16.
//  Copyright © 2018年 iOSMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (parentVCCategory)
@property (nonatomic,assign)BOOL isPresent;
@property (assign, nonatomic) CGFloat navBarBgAlpha;
////提示有按钮
//- (void)alertAlertTypes:(NSString *)string AndButtonTitleArray:(NSArray *)buttonArray andBlock:(void (^)(NSInteger index))block;
////推出提示
//- (void)alertActionSheetTypeButtonTitleArray:(NSArray *)buttonArray andBlock:(void (^)(NSInteger index))block;
//置为透明
- (void)presentBackgroundTransparency:(UIViewController *)viewControllerToPresent andAnimated:(BOOL)animated andCompletion:(void (^)(void))completion;
////调用登录页面返回是否登录成功
//- (void)persentlogInActionCompletion:(void (^)(BOOL isLongInSuccessful))completion;

@end
