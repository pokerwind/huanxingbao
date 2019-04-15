//
//  DZCartPayVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCartPayVC.h"
#import "DZPaySuccessVC.h"
#import "DZPayPassSettingVC.h"

#import "DZPayPassInputView.h"

#import <NSString+NERChainable.h>
#import <NSObject+MJKeyValue.h>
#import "OpenShare+Weixin.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "DZSubmitOrderHeader.h"
#import "DZAddressSelectionVC.h"

@interface DZCartPayVC ()<DZAddressSelectionVCDelegate>
/*
 * DZSubmitOrderHeader
 */
@property (nonatomic,strong)DZSubmitOrderHeader *header;

/*
 * addressId
 */
@property (nonatomic,copy)NSString *addressId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *balanceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alipayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wxImageView;

@property (nonatomic, strong) DZPayPassInputView *passInputView;
@property (nonatomic, strong) UIView *mask;

@property (nonatomic) NSInteger payType;//1:余额2:支付宝3:微信

@end

@implementation DZCartPayVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
//    if (self.source == 1) {
//        self.topConstraint.constant = 85;
//        [self.view addSubview:self.header];
//        [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.mas_equalTo(self.view);
//            make.height.mas_equalTo(85);
//        }];
//    }
    self.payType = 1;
    self.countLabel.text = [NSString stringWithFormat:@"共%@件", self.goodsCount];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.goodsPrice];
    self.expressPriceLabel.text = [NSString stringWithFormat:@"¥%@", self.expressPrice];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", self.totalPrice];
    
    //移除订单提交页
    if (!self.delegate) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [array removeObjectAtIndex:self.navigationController.viewControllers.count - 2];
        self.navigationController.viewControllers = array;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveWXPayResult:) name:WXPAYRESULTNOTIFICATION object:nil];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)balanceButtonAction {
    self.payType = 1;
    self.balanceImageView.image = [UIImage imageNamed:@"my_address_icon_s"];
    self.alipayImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
    self.wxImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
}

- (IBAction)alipayButtonAction {
    self.payType = 2;
    self.balanceImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
    self.alipayImageView.image = [UIImage imageNamed:@"my_address_icon_s"];
    self.wxImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
}

- (IBAction)wxButtonAction {
    self.payType = 3;
    self.balanceImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
    self.alipayImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
    self.wxImageView.image = [UIImage imageNamed:@"my_address_icon_s"];
}

- (IBAction)payButtonAction {
    NSString *urlStr = nil;
    
    if (self.source == 1) {
        urlStr = @"/Api/IndexUserApi/doPayGiftBag";
    }else{
        urlStr = @"/Api/OrderApi/orderPay";
    }
    
    if (self.payType == 1) {//余额支付
        if ([[DPMobileApplication sharedInstance].loginUser.pay_password isEqualToString:@"1"]) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.mask];
            [[UIApplication sharedApplication].keyWindow addSubview:self.passInputView];
            [self.mask mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            [self.passInputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.73, SCREEN_HEIGHT * 0.234));
            }];
            [self.passInputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo([UIApplication sharedApplication].keyWindow);
                make.centerY.mas_equalTo([UIApplication sharedApplication].keyWindow).multipliedBy(0.9);
            }];
            [self.passInputView.passTextField becomeFirstResponder];
        }else{
            DZPayPassSettingVC *vc = [DZPayPassSettingVC new];
            vc.isPresent = YES;
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nvc animated:YES completion:nil];
        }
    }else if (self.payType == 2){//支付宝支付
        NSDictionary *params = @{@"order_sn":self.orderSN,
                                 @"pay_code":@"1"
                                 };
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:urlStr parameters:params];
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
                            if (self.delegate && [self.delegate respondsToSelector:@selector(didPaySuccess)]) {
                                [self.delegate didPaySuccess];
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
    }else if (self.payType == 3){//微信支付
        if (![WXApi isWXAppInstalled]) {
            [SVProgressHUD showInfoWithStatus:@"您没有安装微信"];
            return;
        }
        NSDictionary *params = @{@"order_sn":self.orderSN,
                                 @"pay_code":@"2"
                                 };
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:urlStr parameters:params];
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

- (void)inputViewCancelButtonClick{
    self.passInputView.passTextField.text = @"";
    [self.passInputView removeFromSuperview];
    [self.mask removeFromSuperview];
}

- (void)inputViewConfirmButtonClick{
    if (!self.passInputView.passTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入支付密码"];
        return;
    }
    NSString *urlStr = nil;
    
    if (self.source == 1) {
        urlStr = @"/Api/IndexUserApi/doPayGiftBag";
    }else{
        urlStr = @"/Api/OrderApi/orderPay";
    }
    [self.passInputView removeFromSuperview];
    [self.mask removeFromSuperview];
    NSDictionary *params = @{@"order_sn":self.orderSN,
                             @"pay_code":@"4",
                             @"pay_password":self.passInputView.passTextField.text
                             };
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:urlStr parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        if ([request.responseJSONObject[@"status"] integerValue] == 1) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didPaySuccess)]) {
                [self.delegate didPaySuccess];
            }
            DZPaySuccessVC *vc = [DZPaySuccessVC new];
            [[NSNotificationCenter defaultCenter] postNotificationName:USERORDERINFOUPDATEDNOTIFICATION object:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:request.responseJSONObject[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 代理相关 ----

#pragma mark - ---- 私有方法 ----
- (void)didReceiveWXPayResult:(NSNotification *)noti{
    NSDictionary *dict = (NSDictionary *)noti.object;
    NSInteger errorCode = [dict[@"errCode"] intValue];
    if (errorCode == 0) {//支付成功
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPaySuccess)]) {
            [self.delegate didPaySuccess];
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
- (DZPayPassInputView *)passInputView{
    if (!_passInputView) {
        _passInputView = [DZPayPassInputView viewFormNib];
        _passInputView.backgroundColor = [UIColor whiteColor];
        _passInputView.layer.cornerRadius = 4;
        [_passInputView.cancelButton addTarget:self action:@selector(inputViewCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_passInputView.confirmButton addTarget:self action:@selector(inputViewConfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passInputView;
}

- (UIView *)mask{
    if (!_mask) {
        _mask = [UIView new];
        _mask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    }
    return _mask;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//#pragma mark - --- getters 和 setters ----
//- (DZSubmitOrderHeader *)header{
//    if (!_header) {
//        _header = [DZSubmitOrderHeader viewFormNib];
//        [_header.addressButton addTarget:self action:@selector(addressButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _header;
//}
//
//- (void)addressButtonAction{
//    DZAddressSelectionVC *vc = [DZAddressSelectionVC new];
//    vc.delegate = self;
//    vc.currentAddressId = self.addressId;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//#pragma mark - ---- DZAddressSelectionVCDelegate ----
//- (void)didSelectAddress:(DZMyAddressItemModel *)model{
//    self.header.nameLabel.text = model.consignee;
//    self.header.mobileLabel.text = model.mobile;
//    self.header.addressLabel.text = model.address;
//    
//    self.addressId = model.address_id;
//}

@end
