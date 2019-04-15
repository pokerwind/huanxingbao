//
//  DZSetPassVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/15.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSetPassVC.h"

@interface DZSetPassVC ()

@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;

@end

@implementation DZSetPassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
}

- (IBAction)registerButtonAction {
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
    if (!self.nickTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入昵称"];
        return;
    }
    NSString * parent_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"parent_id"];
    NSDictionary *params = @{@"mobile":self.mobile, @"password":self.passTextField.text, @"nickname":self.nickTextField.text};
    if (parent_id != 0 && parent_id.length != 0) {
        params = @{@"mobile":self.mobile, @"password":self.passTextField.text, @"nickname":self.nickTextField.text,
                   @"parent_id":parent_id
                   };
    }else {
        params = @{@"mobile":self.mobile, @"password":self.passTextField.text, @"nickname":self.nickTextField.text};
    }
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/PublicApi/register" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功，请登录"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}
@end
