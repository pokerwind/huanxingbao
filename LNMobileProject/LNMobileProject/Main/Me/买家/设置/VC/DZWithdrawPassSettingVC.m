//
//  DZWithdrawPassSettingVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZWithdrawPassSettingVC.h"

#import "DZAuthenticationVC.h"

@interface DZWithdrawPassSettingVC ()

@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@end

@implementation DZWithdrawPassSettingVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置提现密码";
    self.navigationItem.rightBarButtonItem = self.rightItem;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)rightItemAction{
    if (self.passTextField.text.length != 6) {
        [SVProgressHUD showErrorWithStatus:@"请输入六位提现密码"];
        return;
    }
    if (![self.confirmTextField.text isEqualToString:self.passTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return;
    }
    
    NSDictionary *params = @{@"withdraw_password":self.passTextField.text, @"confirm_withdraw_password":self.confirmTextField.text};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/setWithdrawPassword" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.navigationController pushViewController:[DZAuthenticationVC new] animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        _rightItem.tintColor = HEXCOLOR(0x33a3f9);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}

@end
