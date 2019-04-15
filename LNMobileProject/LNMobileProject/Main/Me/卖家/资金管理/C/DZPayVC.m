//
//  DZPayVC.m
//  LNMobileProject
//
//  Created by ios on 2017/10/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZPayVC.h"
#import "DZPaySuccessVC.h"

#import "OpenShare+Weixin.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface DZPayVC ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *balanceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alipayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wxImageView;
@property (nonatomic) NSInteger type;

@end

@implementation DZPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付";
    self.type = 0;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", self.price];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveWXPayResult:) name:WXPAYRESULTNOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)balanceButtonClick {
    self.type = 0;
    self.balanceImageView.image = [UIImage imageNamed:@"my_address_icon_s"];
    self.alipayImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
    self.wxImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
}

- (IBAction)alipayButtonClick {
    self.type = 1;
    self.balanceImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
    self.alipayImageView.image = [UIImage imageNamed:@"my_address_icon_s"];
    self.wxImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
}

- (IBAction)wxButtonClick {
    self.type = 2;
    self.balanceImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
    self.alipayImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
    self.wxImageView.image = [UIImage imageNamed:@"my_address_icon_s"];
}

- (IBAction)payButtonClick {
    if (self.type == 0) {//余额
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"金额：￥%.2f元，确定用余额支付吗？", self.price] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *params = @{
                                     @"bond_money":self.priceLabel.text,
                                     @"pay_code":@"4"
                                     };
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/shopPayBond" parameters:params];
            [SVProgressHUD show];
            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                [SVProgressHUD dismiss];
                if ([request.responseJSONObject[@"status"] integerValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:request.responseJSONObject[@"info"]];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didPaySuccess)]) {
                        [self.delegate didPaySuccess];
                    }
                    DZPaySuccessVC *vc = [DZPaySuccessVC new];
                    vc.needSwitch = self.needSwitch;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:request.responseJSONObject[@"info"]];
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:error.domain];
            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }else if (self.type == 1){//支付宝
        NSDictionary *params = @{
                                 @"bond_money":self.priceLabel.text,
                                 @"pay_code":@"1"
                                 };
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/shopPayBond" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            if ([request.responseJSONObject[@"status"] integerValue] == 1) {
                NSString *link = request.responseJSONObject[@"data"];
                NSLog(@"link:%@",link);
                [[AlipaySDK defaultService] payOrder:link fromScheme:@"sirendingzhi" callback:^(NSDictionary *resultDic) {
                    NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
                    switch (resultStatus) {
                        case 9000:{
                            [SVProgressHUD showSuccessWithStatus:request.responseJSONObject[@"info"]];
                            if (self.delegate && [self.delegate respondsToSelector:@selector(didPaySuccess)]) {
                                [self.delegate didPaySuccess];
                            }
                            DZPaySuccessVC *vc = [DZPaySuccessVC new];
                            vc.needSwitch = self.needSwitch;
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
    }else{//微信
        if (![WXApi isWXAppInstalled]) {
            [SVProgressHUD showInfoWithStatus:@"您没有安装微信"];
            return;
        }
        NSDictionary *params = @{
                                 @"bond_money":self.priceLabel.text,
                                 @"pay_code":@"2"
                                 };
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/shopPayBond" parameters:params];
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

- (void)didReceiveWXPayResult:(NSNotification *)noti{
    NSDictionary *dict = (NSDictionary *)noti.object;
    NSInteger errorCode = [dict[@"errCode"] intValue];
    if (errorCode == 0) {//支付成功
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPaySuccess)]) {
            [self.delegate didPaySuccess];
        }
        if (self.needSwitch) {
            DZPaySuccessVC *vc = [DZPaySuccessVC new];
            vc.needSwitch = self.needSwitch;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (errorCode == -1){//支付错误
        [SVProgressHUD showInfoWithStatus:@"支付错误"];
    }else if (errorCode == -2){//用户取消
        [SVProgressHUD showInfoWithStatus:@"取消支付"];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
