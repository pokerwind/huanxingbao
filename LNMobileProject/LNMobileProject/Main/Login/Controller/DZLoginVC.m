//
//  DZLoginVC.m
//  ShopMobile
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniukejij. All rights reserved.
//

#import "DZLoginVC.h"
#import "DZRegisterVC.h"
#import "DZForgetPassVC.h"
#import "MainTabBarController.h"

#import "LoginAPI.h"
#import "DZLoginModel.h"
#import "DPMobileApplication.h"
#import <JPUSHService.h>

@interface DZLoginVC ()<UITextFieldDelegate>

@property (strong, nonatomic) UIBarButtonItem *leftItem;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

@end

@implementation DZLoginVC


#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"登录";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loginButton.layer.cornerRadius = 2;
    self.loginButton.layer.masksToBounds = YES;
    
    self.passTextField.delegate = self;
    
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        DZRegisterVC *vc = [[DZRegisterVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.forgetButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        DZForgetPassVC *vc = [[DZForgetPassVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSubViewsFrame];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- UITextFieldDelegate ----
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.passTextField) {
        [self loginButtonAction];
    }
    return YES;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)loginButtonAction {
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:.1 animations:^{
        self.tipView.alpha = 0;
    }];
    if (!self.phoneTextField.text.length) {
        [self showLoginError:@"手机号不正确"];
        return;
    }
    if (!self.passTextField.text.length) {
        [self showLoginError:@"请输入密码"];
        return;
    }
    
    LoginAPI *api = [[LoginAPI alloc] initWithUsername:self.phoneTextField.text password:self.passTextField.text];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZLoginModel *model = request.responseJSONObject;
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            DZUserModel *user = model.data;
            [[DPMobileApplication sharedInstance] setLoginUser:user];
            MainTabBarController *vc = [[MainTabBarController alloc] init];
            [UIApplication sharedApplication].delegate.window.rootViewController = vc;
            [JPUSHService setTags:[[NSSet alloc] initWithObjects:user.user_id, nil] alias:user.user_id fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"%@%@",iTags,iAlias);
            }];
            //登录完成，需要登录环信
            [[EMClient sharedClient] loginWithUsername:user.emchat_username
                                              password:user.emchat_password
                                            completion:^(NSString *aUsername, EMError *aError) {
                                                if (!aError) {
                                                    NSLog(@"登陆成功");
                                                } else {
                                                    NSLog(@"登陆失败");
                                                }
                                            }];
        } else {
            [self showLoginError:model.info?:@"登录失败"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [self showLoginError:error.domain];
    }];
}

- (void)leftItemAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ---- 私有方法 ----
- (void)showLoginError:(NSString *)error{
    self.tipLabel.text = error;
    [UIView animateWithDuration:.2 animations:^{
        self.tipView.alpha = 1;
    }];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{

}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)leftItem{
    if (!_leftItem) {
        _leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
        _leftItem.tintColor = HEXCOLOR(0xff7722);
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _leftItem;
}

- (void)dealloc{
    
}

@end
