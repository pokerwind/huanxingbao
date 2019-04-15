//
//  DZAddCardVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZAddCardVC.h"

@interface DZAddCardVC ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *subBankNameTextField;

@end

@implementation DZAddCardVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)submitButtonAction {
    if (!self.nameTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入持卡人姓名"];
        return;
    }
    if (!self.numberTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入卡号"];
        return;
    }
    if (!self.bankNameTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行名称"];
        return;
    }
    if (!self.subBankNameTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入开户行"];
        return;
    }
    NSDictionary *params = @{@"bank_name":self.bankNameTextField.text, @"bank_num":self.numberTextField.text, @"cardholder":self.nameTextField.text, @"bank_branch":self.subBankNameTextField.text};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/addUserBankCard" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didAddCard)]) {
                [self.delegate didAddCard];
            }
            [self.navigationController popViewControllerAnimated:YES];
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
