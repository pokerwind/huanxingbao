//
//  DZSettingVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/10.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSettingVC.h"
#import "DZWithdrawPassSettingVC.h"
#import "DZLoginVC.h"
#import "DZChangePassVC.h"
#import "DZFreightTemplateVC.h"
#import "DZCheckPassVC.h"
#import "DZModifyWithdrawPassVC.h"
#import "DZAboutVC.h"
#import "DZFeedbackVC.h"
#import "DZPayPassSettingVC.h"
#import "DZModifyWithdrawPassVC.h"

#import "DZSettingCell.h"
#import <LGAlertView.h>

#import "DPMobileApplication.h"

@interface DZSettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footer;

@property (nonatomic) NSInteger setPassType;//-1 未设置 0审核中 2审核未通过 4审核通过

@end

@implementation DZSettingVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [self.view addSubview:self.tableView];
    
    [self setSubViewsLayout];
    
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void) setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)logoutButtonAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[DPMobileApplication sharedInstance] logout];
        if ([DPMobileApplication sharedInstance].isSellerMode){
            [self showTabWithIndex:0 needSwitch:YES showLogin:YES];
        }else{
            [self showTabWithIndex:0 needSwitch:NO showLogin:YES];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if ([DPMobileApplication sharedInstance].isSellerMode) {
            switch (indexPath.row) {
                case 0:
                    {
                        DZCheckPassVC *vc = [DZCheckPassVC new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                case 1:
                    {
                        DZChangePassVC *vc = [DZChangePassVC new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                case 2:
                    {
                        DZFreightTemplateVC *vc = [DZFreightTemplateVC new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                default:
                    break;
            }
        }else {
            switch (indexPath.row) {
                case 0:
                {
                    DZCheckPassVC *vc = [DZCheckPassVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    DZChangePassVC *vc = [DZChangePassVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:{
                    NSLog(@">>>>>===%@",[DPMobileApplication sharedInstance].loginUser.pay_password);
                    if ([[DPMobileApplication sharedInstance].loginUser.pay_password isEqualToString:@"0"]||[DPMobileApplication sharedInstance].loginUser.pay_password.length == 0) {//未设置提现密码
                        DZPayPassSettingVC *vc = [DZPayPassSettingVC new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{//已设置提现密码
                        DZModifyWithdrawPassVC *vc = [DZModifyWithdrawPassVC new];
                        vc.isPayPass = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                    break;
                case 3:
                    {
                        DZFreightTemplateVC *vc = [DZFreightTemplateVC new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                default:
                    break;
            }
        }
        
    }else{
        switch (indexPath.row) {
            case 0:{
                [[SDImageCache sharedImageCache] clearDisk];
                [SVProgressHUD showSuccessWithStatus:@"清除成功"];
                [self.tableView reloadData];
                break;
            }
//            case 1:{
//                DZFeedbackVC *vc = [DZFeedbackVC new];
//                [self.navigationController pushViewController:vc animated:YES];
//                break;
//            }
            case 1:{
                DZAboutVC *vc = [DZAboutVC new];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if ([DPMobileApplication sharedInstance].isSellerMode) {
            return 4 - 1;
        }else{  
            return 3;
        }
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:[DZSettingCell cellIdentifier] forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if ([DPMobileApplication sharedInstance].isSellerMode) {
            switch (indexPath.row) {
                case 0:
                    [cell fillTitle:@"修改手机" detailTitle:@""];
                    break;
                case 1:
                    [cell fillTitle:@"修改密码" detailTitle:@""];
                    break;
                case 2:
                    [cell fillTitle:@"运费模板" detailTitle:@""];
                    break;
                default:
                    break;
            }
        }else {
            switch (indexPath.row) {
                case 0:
                    [cell fillTitle:@"修改手机" detailTitle:@""];
                    break;
                case 1:
                    [cell fillTitle:@"修改密码" detailTitle:@""];
                    break;
                case 2:{
                    if ([[DPMobileApplication sharedInstance].loginUser.pay_password isEqualToString:@"1"]) {
                        [cell fillTitle:@"支付密码" detailTitle:@""];
                    }else{
                        [cell fillTitle:@"支付密码" detailTitle:@"未设置"];
                    }
                }
                    break;
                case 3:
                    [cell fillTitle:@"运费模板" detailTitle:@""];
                    break;
                default:
                    break;
            }
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                
                NSUInteger intg = [[SDImageCache sharedImageCache] getSize];
                NSString * currentVolum = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:intg]];
                [cell fillTitle:@"清除缓存" detailTitle:currentVolum];
                break;
            }
//            case 1:
//                [cell fillTitle:@"意见反馈" detailTitle:@""];
//                break;
            case 1:
                [cell fillTitle:@"关于我们" detailTitle:@""];
                break;
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 24)];
    label.textColor = DefaultTextLightBlackColor;
    label.font = [UIFont systemFontOfSize:12];
    if (section == 0) {
        label.text = @"账户相关";
    }else{
        label.text = @"其他";
    }
    [view addSubview:label];
    return view;
}

#pragma mark - --- 私有方法 ----
- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/isSetWithdrawPwd" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.setPassType = [request.responseJSONObject[@"data"][@"state"] integerValue];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DZSettingCell class] forCellReuseIdentifier:[DZSettingCell cellIdentifier]];
        _tableView.tableFooterView = self.footer;
    }
    return _tableView;
}

- (UIView *)footer{
    if (!_footer) {
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 40)];
        logoutButton.backgroundColor = [UIColor whiteColor];
        [logoutButton setTitle:@"退出当前帐号" forState:UIControlStateNormal];
        [logoutButton setTitleColor:HEXCOLOR(0xea3b3b) forState:UIControlStateNormal];
        logoutButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_footer addSubview:logoutButton];
        [logoutButton addTarget:self action:@selector(logoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footer;
}

@end
