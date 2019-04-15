//
//  DZDZInputNewWithdrawPassVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/15.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZInputNewWithdrawPassVC.h"

@interface DZInputNewWithdrawPassVC ()

@property (weak, nonatomic) IBOutlet UITextField *oldTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *comfirmTextField;

@end

@implementation DZInputNewWithdrawPassVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isPayPass) {
        self.title = @"修改支付密码";
    }else{
        self.title = @"修改提现密码";
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)submitButtonClick {
    if (!self.oldTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入旧密码~"];
        return;
    }
    if (!self.passTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码~"];
        return;
    }
    if (!self.comfirmTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请再次输入新密码~"];
        return;
    }
    
    if (self.isPayPass) {
        NSDictionary *params = @{@"old_password":self.oldTextField.text, @"new_password":self.passTextField.text, @"confirm_password":self.comfirmTextField.text};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/editPayPassword" parameters:params method:LCRequestMethodPost];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }else{
        NSDictionary *params = @{@"oldPassword":self.oldTextField.text, @"newPassword":self.passTextField.text, @"confirmPassword":self.comfirmTextField.text};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/editWithdrawPassword" parameters:params];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
}

#pragma mark - ---- 代理相关 ----

#pragma mark - ---- 私有方法 ----

#pragma mark - --- getters 和 setters ----

@end
