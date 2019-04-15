//
//  DZRechargeVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/25.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZRechargeVC.h"
#import "DZPaySuccessVC.h"

#import "OpenShare+Weixin.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface DZRechargeVC ()

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIImageView *aliPaySelectionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wxPaySelectionImageView;
@property (nonatomic) NSInteger type;


@end

@implementation DZRechargeVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    
    self.type = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveWXPayResult:) name:WXPAYRESULTNOTIFICATION object:nil];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)aliPayButtonAction {
    self.type = 0;
    self.aliPaySelectionImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_s"];
    self.wxPaySelectionImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_n"];
}

- (IBAction)wxPayButtonAction {
    self.type = 1;
    self.aliPaySelectionImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_n"];
    self.wxPaySelectionImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_s"];
}

- (IBAction)payButtonClick {
    if ([self.moneyTextField.text floatValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入充值金额"];
        return;
    }
    
    if (self.type == 0) {
        NSDictionary *params = @{@"recharge_money":self.moneyTextField.text,
                                 @"pay_code":@"1"
                                 };
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/shopRecharge" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            if ([request.responseJSONObject[@"status"] integerValue] == 1) {
                NSString *link = request.responseJSONObject[@"data"];
                NSLog(@"link:%@",link);
                [[AlipaySDK defaultService] payOrder:link fromScheme:@"sirendingzhi" callback:^(NSDictionary *resultDic) {
                    NSLog(@"result: %@", resultDic);
                    NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
                    switch (resultStatus) {
                        case 9000:{
                            if (self.delegate && [self.delegate respondsToSelector:@selector(didRechargeSuccess)]) {
                                [self.delegate didRechargeSuccess];
                            }
                            DZPaySuccessVC *vc = [DZPaySuccessVC new];
                            [self.navigationController pushViewController:vc animated:YES];
                            break;
                        }
                        case 8000:{
                            [SVProgressHUD showInfoWithStatus:@"处理中"];
                            break;
                        }
                        case 4000:{
                            [SVProgressHUD showInfoWithStatus:@"订单支付失败"];
                            break;
                        }
                        case 5000:{
                            [SVProgressHUD showInfoWithStatus:@"重复请求"];
                            break;
                        }
                        case 6001:{
                            [SVProgressHUD showInfoWithStatus:@"取消支付"];
                            break;
                        }
                        case 6002:{
                            [SVProgressHUD showInfoWithStatus:@"网络连接出错"];
                            break;
                        }
                        case 6004:{
                            [SVProgressHUD showInfoWithStatus:@"支付结果未知"];
                            break;
                        }
                        default:
                            [SVProgressHUD showInfoWithStatus:@"支付错误"];
                            break;
                    }
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:request.responseJSONObject[@"info"]];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }else{
        if (![WXApi isWXAppInstalled]) {
            [SVProgressHUD showInfoWithStatus:@"您没有安装微信"];
            return;
        }
        
        NSDictionary *params = @{
                                 @"recharge_money":self.moneyTextField.text,
                                 @"pay_code":@"2"
                                 };
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/shopRecharge" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            if ([request.responseJSONObject[@"status"] integerValue] == 1) {
                NSDictionary *data = request.responseJSONObject[@"data"];
                PayReq *req = [PayReq new];
                req.partnerId = [NSString stringWithFormat:@"%@", data[@"partnerid"]];
                req.prepayId = [NSString stringWithFormat:@"%@", data[@"prepayid"]];
                req.package = [NSString stringWithFormat:@"%@", data[@"package"]];
                req.nonceStr = [NSString stringWithFormat:@"%@", data[@"noncestr"]];
                req.timeStamp = [data[@"timestamp"] intValue];
                req.sign = [NSString stringWithFormat:@"%@", data[@"sign"]];
                [WXApi sendReq:req];
            }else{
                [SVProgressHUD showErrorWithStatus:request.responseJSONObject[@"info"]];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
}
#pragma mark - ---- 代理相关 ----

#pragma mark - ---- 私有方法 ----
- (void)didReceiveWXPayResult:(NSNotification *)noti{
    NSDictionary *dict = (NSDictionary *)noti.object;
    NSInteger errorCode = [dict[@"errCode"] intValue];
    if (errorCode == 0) {//支付成功
        if (self.delegate && [self.delegate respondsToSelector:@selector(didRechargeSuccess)]) {
            [self.delegate didRechargeSuccess];
        }
        DZPaySuccessVC *vc = [DZPaySuccessVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (errorCode == -1){//支付错误
        [SVProgressHUD showInfoWithStatus:@"支付错误"];
    }else if (errorCode == -2){//用户取消
        [SVProgressHUD showInfoWithStatus:@"取消支付"];
    }
}

#pragma mark - --- getters 和 setters ----
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
