//
//  DZMoneyManagementVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/24.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMoneyManagementVC.h"
#import "DZRechargeVC.h"
#import "DZBailVC.h"
#import "DZMyBillDetailVC.h"
#import "DZWithdrawVC.h"
#import "DZCardManagementVC.h"

@interface DZMoneyManagementVC ()<DZRechargeVCDelegate, DZBailVCDelegate, DZWithdrawVCDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;

@end

@implementation DZMoneyManagementVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资金管理";
//    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    [self getData];
    
    if (self.isPayBond) {
        self.tipView.hidden = YES;
    }else{
//        [self.tipView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightItemAction)]];
    }
    
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (void)rightItemAction{
    DZBailVC *vc = [DZBailVC new];
    vc.delagate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)tipCloseButtonAction {
    self.tipView.hidden = YES;
}

- (IBAction)incomeButtonAction {
    DZMyBillDetailVC *vc = [DZMyBillDetailVC new];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)outcomeButtonAction {
    DZMyBillDetailVC *vc = [DZMyBillDetailVC new];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)watchButtonAction {
    DZMyBillDetailVC *vc = [DZMyBillDetailVC new];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)withdrawButtonAction {
    DZWithdrawVC *vc = [DZWithdrawVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)rechargeButtonAction {
    DZRechargeVC *vc = [DZRechargeVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cardButtonAction {
    DZCardManagementVC *vc = [DZCardManagementVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- 代理相关 ----
//DZBailVCDelegate
- (void)bailValueDidChange{
    NSDictionary *infoParams = nil;
    LNetWorkAPI *infoApi = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/getShopInfo" parameters:infoParams];
    __weak typeof(self) weakSelf = self;
    [infoApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            if ([[NSString stringWithFormat:@"%@", request.responseJSONObject[@"data"][@"audlt_status"]] integerValue] == 0) {
                weakSelf.tipView.hidden = YES;
            }else{
                if ([request.responseJSONObject[@"data"][@"is_pay_bond"] boolValue]) {
                    weakSelf.tipView.hidden = YES;
                }else{
                    weakSelf.tipView.hidden = NO;
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

//DZWithdrawVCDelegate
- (void)didWithdrawSuccess{
    [self getData];
}

#pragma mark - ---- DZRechargeVCDelegate ----
- (void)didRechargeSuccess{
    [self getData];
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/ShopCenterApi/moneyInfo" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = request.responseJSONObject;
        self.balanceLabel.text = [NSString stringWithFormat:@"%@", resultDict[@"data"][@"user_money"]];
        self.waitLabel.text = resultDict[@"data"][@"settlement"];
        self.incomeLabel.text = resultDict[@"data"][@"income"];
        self.consumeLabel.text = resultDict[@"data"][@"consume"];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"诚信保证" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        _rightItem.tintColor = HEXCOLOR(0x27a2f8);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}

@end
