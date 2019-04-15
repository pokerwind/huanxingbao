//
//  DZResetPassVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/12.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZResetPassVC.h"

@interface DZResetPassVC ()

@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@end

@implementation DZResetPassVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor ];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)submitButtonClick {
    if (!self.passTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    if (!self.confirmTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码"];
        return;
    }
    if (![self.passTextField.text isEqualToString:self.confirmTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }
    NSDictionary *params = @{@"mobile":self.mobile, @"password":self.passTextField.text};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/PublicApi/findpwdSave" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"重置成功，请登录"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 代理相关 ----

#pragma mark - ---- 私有方法 ----

#pragma mark - --- getters 和 setters ----

@end
