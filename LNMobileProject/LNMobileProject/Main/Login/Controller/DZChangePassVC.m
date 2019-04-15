//
//  DZChangePassVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/24.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZChangePassVC.h"

@interface DZChangePassVC ()

@property (weak, nonatomic) IBOutlet UITextField *oldTextField;
@property (weak, nonatomic) IBOutlet UITextField *currentTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@end

@implementation DZChangePassVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)submitButtonAction {
    if (!self.oldTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入旧密码~"];
        return;
    }
    if (!self.currentTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码~"];
        return;
    }
    if (!self.confirmTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请再次输入新密码~"];
        return;
    }
    
    NSDictionary *params = @{@"oldPassword":self.oldTextField.text, @"newPassword":self.currentTextField.text, @"confirmPassword":self.confirmTextField.text};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/editPassword" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [[DPMobileApplication sharedInstance] logout];
            if ([DPMobileApplication sharedInstance].isSellerMode) {
                [self showTabWithIndex:0 needSwitch:YES showLogin:YES];
                [SVProgressHUD showInfoWithStatus:@"密码修改成功，请重新登录"];
            }else{
                [self showTabWithIndex:0 needSwitch:NO showLogin:YES];
                [SVProgressHUD showInfoWithStatus:@"密码修改成功，请重新登录"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 代理相关 ----

#pragma mark - ---- 私有方法 ----

#pragma mark - --- getters 和 setters ----

@end
