//
//  DZCheckNewMobileVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/12.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCheckNewMobileVC.h"

#import <JKCountDownButton/JKCountDownButton.h>

#import "GetVerifyAPI.h"

@interface DZCheckNewMobileVC ()

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation DZCheckNewMobileVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证新号码";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)countdownButtonClick:(JKCountDownButton *)sender {
    if (!self.mobileTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    GetVerifyAPI *getApi = [[GetVerifyAPI alloc] initWithPhone:self.mobileTextField.text type:1];
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

- (IBAction)submitButtonClick {
    if (!self.mobileTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (!self.codeTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    
    NSDictionary *params = @{@"mobile":self.mobileTextField.text, @"sms_code":self.codeTextField.text};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/saveNewMobile" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
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
