//
//  DZBailVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/25.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZBailVC.h"
#import "DZOpenSTShopVC.h"
#import "DZOpenGCShopVC.h"
#import "DZOpenWPShopVC.h"
#import "DZPayVC.h"

#import "DZBailOperationView.h"
#import "DZOpenShopSelectionView.h"

@interface DZBailVC ()<DZOpenShopSelectionViewDelegate, DZPayVCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currnetPriceLabel;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) DZBailOperationView *operationView;

@property (nonatomic) BOOL canReOpen;//是否能重新开店
@property (nonatomic) NSInteger shopType;//开店类型 1实体店  2工厂店  3网批店
@property (weak, nonatomic) IBOutlet UIButton *openButton;

@property (strong, nonatomic) DZOpenShopSelectionView *shopSelectionView;

@end

@implementation DZBailVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴纳保证金";
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)payButtonAction {
    [self showOperationViewWithType:0];
}

- (IBAction)withdrawButtonAction {
    if (self.canReOpen) {//重新开店
        [self showShopSelectionView];
    }else{
        [self showOperationViewWithType:1];
    }
}

- (void)payButtonClick{
    if ([self.operationView.moneyLabel.text floatValue] == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择保证金金额"];
        return;
    }
    
    [self hideOperationView];
    if ([self.operationView.titleLabel.text isEqualToString:@"解冻诚信保证金"]) {
        NSDictionary *params = @{@"money":self.operationView.moneyLabel.text};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/thawBond" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                [SVProgressHUD showSuccessWithStatus:model.info];
                [[NSNotificationCenter defaultCenter] postNotificationName:SELLERMEVCREFRESHNOTIFICATION object:nil];
                
                if (self.delagate && [self.delagate respondsToSelector:@selector(bailValueDidChange)]) {
                    [self.delagate bailValueDidChange];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }else{
        DZPayVC *vc = [DZPayVC new];
        vc.delegate = self;
        vc.price = [self.operationView.moneyLabel.text floatValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZPayVCDelegate ----
- (void)didPaySuccess{
    [self getData];
    [[NSNotificationCenter defaultCenter] postNotificationName:SELLERMEVCREFRESHNOTIFICATION object:nil];
    
    if (self.delagate && [self.delagate respondsToSelector:@selector(bailValueDidChange)]) {
        [self.delagate bailValueDidChange];
    }
}

#pragma mark - ---- DZOpenShopSelectionViewDelegate ----
- (void)didSelectShopType:(NSInteger)type{
    [self hideOperationView];
    switch (type) {
        case 0:{
            DZOpenSTShopVC *vc = [DZOpenSTShopVC new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:{
            DZOpenGCShopVC *vc = [DZOpenGCShopVC new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{
            DZOpenWPShopVC *vc = [DZOpenWPShopVC new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - ---- 私有方法 ----
- (void)showOperationViewWithType:(NSInteger)type{
    if (type) {
        self.operationView.titleLabel.text = @"解冻诚信保证金";
        [self.operationView.submitButton setTitle:@"解冻" forState:UIControlStateNormal];
    }else{
        self.operationView.titleLabel.text = @"缴纳诚信保证金";
        [self.operationView.submitButton setTitle:@"支付" forState:UIControlStateNormal];
    }
    [[UIApplication sharedApplication].delegate.window addSubview:self.maskView];
    [[UIApplication sharedApplication].delegate.window addSubview:self.operationView];
    [UIView animateWithDuration:.3 animations:^{
        self.operationView.frame = CGRectMake(0, SCREEN_HEIGHT - self.operationView.height, self.operationView.width, self.operationView.height);
    }];
}

- (void)hideOperationView{
    if (self.shopSelectionView.superview) {
        [UIView animateWithDuration:.2 animations:^{
            self.shopSelectionView.frame = CGRectMake(0, SCREEN_HEIGHT, self.shopSelectionView.width, self.shopSelectionView.height);
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self.shopSelectionView removeFromSuperview];
        }];
    }else{    
        [UIView animateWithDuration:.2 animations:^{
            self.operationView.frame = CGRectMake(0, SCREEN_HEIGHT, self.operationView.width, self.operationView.height);
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self.operationView removeFromSuperview];
        }];
    }
}

- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getShopBondMoney" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        if ([request.responseJSONObject[@"status"] boolValue]) {
            self.priceLabel.text = request.responseJSONObject[@"data"][@"frozen_bond"];
            self.canReOpen = [request.responseJSONObject[@"data"][@"is_open"] boolValue];
            if (self.canReOpen) {//可以重新开店
                [self.openButton setTitle:@"重新开店" forState:UIControlStateNormal];
            }else{//不能重新开店
                [self.openButton setTitle:@"解冻" forState:UIControlStateNormal];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:request.responseJSONObject[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)showShopSelectionView{
    [[UIApplication sharedApplication].delegate.window addSubview:self.maskView];
    [[UIApplication sharedApplication].delegate.window addSubview:self.shopSelectionView];
    [UIView animateWithDuration:.3 animations:^{
        self.shopSelectionView.frame = CGRectMake(0, SCREEN_HEIGHT - self.shopSelectionView.height, self.shopSelectionView.width, self.shopSelectionView.height);
    }];
}

#pragma mark - --- getters 和 setters ----
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOperationView)]];
    }
    return _maskView;
}

- (DZBailOperationView *)operationView{
    if (!_operationView) {
        _operationView = [DZBailOperationView viewFormNib];
        _operationView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 190);
        [_operationView.submitButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationView;
}

- (DZOpenShopSelectionView *)shopSelectionView{
    if (!_shopSelectionView) {
        _shopSelectionView = [DZOpenShopSelectionView viewFormNib];
        _shopSelectionView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 255);
        _shopSelectionView.delegate = self;
    }
    return _shopSelectionView;
}

- (void)dealloc{
    
}

@end
