//
//  DZCheckPassVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/12.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCheckPassVC.h"
#import "DZCheckNewMobileVC.h"

@interface DZCheckPassVC ()

@property (weak, nonatomic) IBOutlet UITextField *passTextField;

@end

@implementation DZCheckPassVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"输入登录密码";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)nextButtonClick {
    if (!self.passTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入登录密码"];
        return;
    }
    
    NSDictionary *params = @{@"password":self.passTextField.text};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/checkPassword" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            DZCheckNewMobileVC *vc = [DZCheckNewMobileVC new];
            [self.navigationController pushViewController:vc animated:YES];
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
