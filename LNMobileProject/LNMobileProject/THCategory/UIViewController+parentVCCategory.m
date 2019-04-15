//
//  UIViewController+parentVCCategory.m
//  TadpoleYun
//
//  Created by iOSMac on 2018/5/16.
//  Copyright © 2018年 iOSMac. All rights reserved.
//

#import "UIViewController+parentVCCategory.h"
#import <objc/runtime.h>
#import "UINavigationController+THNVCategory.h"
//#import "THAlertActionView.h"

static const void *Th_isPresentkey = &Th_isPresentkey;
//定义常量 必须是C语言字符串
static char *CloudoxKey = "CloudoxKey";

@implementation UIViewController (parentVCCategory)
- (BOOL)isPresent{
    NSNumber *boNumber = objc_getAssociatedObject(self, Th_isPresentkey);
    return boNumber.boolValue;
}
- (void)setIsPresent:(BOOL)isPresent {
    NSNumber *boNumber = [NSNumber numberWithBool:isPresent];
    objc_setAssociatedObject(self, Th_isPresentkey, boNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setNavBarBgAlpha:(CGFloat)navBarBgAlpha {
    NSString *navStr = [NSString stringWithFormat:@"%lf",navBarBgAlpha];
    objc_setAssociatedObject(self, CloudoxKey, navStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    
}
- (CGFloat)navBarBgAlpha {
    NSString *navStr = objc_getAssociatedObject(self, CloudoxKey) ? : @"1.0";
    return navStr.doubleValue;
}

//- (void)alertAlertTypes:(NSString *)string AndButtonTitleArray:(NSArray *)buttonArray andBlock:(void (^)(NSInteger))block{
//    THAlertActionView *thaler = [[THAlertActionView alloc]initWithViewType:AlertTypes];
//    thaler.title = @"温馨提示";
//    thaler.message = string;
//    [thaler setButtonTitleArray:buttonArray andBlock:^(NSInteger index) {
//        if (block) {
//            block(index);
//        }
//    }];
//    [thaler show];
//}
//- (void)alertActionSheetTypeButtonTitleArray:(NSArray *)buttonArray andBlock:(void (^)(NSInteger index))block {
//    THAlertActionView *aler = [[THAlertActionView alloc]initWithViewType:ActionSheetType];
//    [aler setButtonTitleArray:buttonArray andBlock:^(NSInteger index) {
//        if (block) {
//            block(index);
//        }
//    }];
//    [aler show];
//}
- (void)presentBackgroundTransparency:(UIViewController *)viewControllerToPresent andAnimated:(BOOL)animated andCompletion:(void (^)(void))completion {
    viewControllerToPresent.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    viewControllerToPresent.providesPresentationContextTransitionStyle = YES;
    viewControllerToPresent.definesPresentationContext = YES;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [kKeyWindow.rootViewController presentViewController:viewControllerToPresent animated:animated completion:^{
        if (completion) {
            completion();
        }
    }];
}
//- (void)persentlogInActionCompletion:(void (^)(BOOL isLongInSuccessful))completion {
//    THLogInVC *login = [[THLogInVC alloc]init];
//    login.block = ^(BOOL isLongInSuccessfuls) {
//        if (completion) {
//            completion(isLongInSuccessfuls);
//        }
//    };
//    [self presentBackgroundTransparency:login.rootNC andAnimated:NO andCompletion:nil];
//}
@end
