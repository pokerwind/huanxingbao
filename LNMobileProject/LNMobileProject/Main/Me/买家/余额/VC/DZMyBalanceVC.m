//
//  DZMyBalanceVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMyBalanceVC.h"
#import "DZMyBillDetailVC.h"
#import "DZBalanceHelpCenterVC.h"
#import "DZRechargeVC.h"

#import "DPMobileApplication.h"
#import "DZGetBalanceModel.h"

#import "DZBillTipView.h"
#import "DZWithdrawVC.h"

@interface DZMyBalanceVC ()<DZRechargeVCDelegate,DZWithdrawVCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cangkuyuELabel;

@property (strong, nonatomic) DZBillTipView *tipView;
@property (strong, nonatomic) UIView *maskView;
@property (weak, nonatomic) IBOutlet UIButton *titianButton;

@end

@implementation DZMyBalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的余额";
    [self.titianButton addTarget:self action:@selector(tixianAction) forControlEvents:k_BuuttonAction];
    [self getData];
}
//提现
- (void)tixianAction {
    DZWithdrawVC *vc = [DZWithdrawVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didWithdrawSuccess {
    [self getData];
}
//DZRechargeVCDelegate
- (void)didRechargeSuccess{
    [self getData];
}

- (IBAction)billDetailButtonAction:(id)sender {
    [self.navigationController pushViewController:[DZMyBillDetailVC new] animated:YES];
}

- (IBAction)incomeButtonAction {
    DZMyBillDetailVC *vc = [DZMyBillDetailVC new];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)consumeButtonAction {
    DZMyBillDetailVC *vc = [DZMyBillDetailVC new];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)rechargeButtonAction:(id)sender {
    DZRechargeVC *vc = [DZRechargeVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)helpButtonAction:(id)sender {
    self.maskView.alpha = 0.1;
    [AppDelegateInstance.window addSubview:self.maskView];
    [AppDelegateInstance.window addSubview:self.tipView];
    [UIView animateWithDuration:.3 animations:^{
        self.maskView.alpha = 1;
        self.tipView.frame = CGRectMake(0, SCREEN_HEIGHT - self.tipView.height, self.tipView.width, self.tipView.height);
    }];
}

- (void)tipCloseClick{
    [UIView animateWithDuration:.2 animations:^{
        self.maskView.alpha = 0;
        self.tipView.frame = CGRectMake(0, SCREEN_HEIGHT, self.tipView.width, self.tipView.height);
    }completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.tipView removeFromSuperview];
    }];
}

- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/UserCenterApi/getBalance" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetBalanceModel *model = [DZGetBalanceModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.balanceLabel.text = model.data.available_money;
            self.incomeLabel.text = model.data.income;
            self.consumeLabel.text = model.data.consume;
            self.cangkuyuELabel.text = model.data.warehouse_money;
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (DZBillTipView *)tipView{
    if (!_tipView) {
        _tipView = [DZBillTipView viewFormNib];
        _tipView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 147);
        [_tipView.closeButton addTarget:self action:@selector(tipCloseClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipView;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    }
    return _maskView;
}

@end
