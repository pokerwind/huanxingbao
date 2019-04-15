//
//  DZPaySuccessVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/8.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZPaySuccessVC.h"

@interface DZPaySuccessVC ()

@end

@implementation DZPaySuccessVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付成功";
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [array removeObjectAtIndex:array.count - 2];
    self.navigationController.viewControllers = array;
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)submitButtonAction {
    if (self.needSwitch) {
        [self showTabWithIndex:4 needSwitch:YES showLogin:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ---- 代理相关 ----

#pragma mark - ---- 私有方法 ----

#pragma mark - --- getters 和 setters ----

@end
