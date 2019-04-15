//
//  DZModifyWithdrawPassVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/15.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZModifyWithdrawPassVC.h"
#import "DZInputNewWithdrawPassVC.h"

#import <JKCountDownButton/JKCountDownButton.h>

#import "GetVerifyAPI.h"
#import "CheckSmsCodeAPI.h"

@interface DZModifyWithdrawPassVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation DZModifyWithdrawPassVC

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
- (IBAction)countdownButtonClick:(JKCountDownButton *)sender {
    if (!self.phoneTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    GetVerifyAPI *getApi;
    if (self.isPayPass) {
        getApi = [[GetVerifyAPI alloc] initWithPhone:self.phoneTextField.text type:6];
    }else{
        getApi = [[GetVerifyAPI alloc] initWithPhone:self.phoneTextField.text type:5];
    }
    
    [SVProgressHUD showWithStatus:@"发送中"];
    [getApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *    model = request.responseJSONObject;
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"已发送，请注意查收"];
            sender.enabled = NO;
            sender.backgroundColor = HEXCOLOR(0xcdcdcd);
            //button type要 设置成custom 否则会闪动
            [sender startCountDownWithSecond:60];
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                countDownButton.backgroundColor = HEXCOLOR(0xff7722);
                return @"获取验证码";
                
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:model.info?:@"网络不给力"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (IBAction)nextButtonClick {
    if (!self.phoneTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (!self.codeTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    
    CheckSmsCodeAPI *api = [[CheckSmsCodeAPI alloc] initWithMobile:self.phoneTextField.text code:self.codeTextField.text];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            DZInputNewWithdrawPassVC *vc = [DZInputNewWithdrawPassVC new];
            vc.isPayPass = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
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
