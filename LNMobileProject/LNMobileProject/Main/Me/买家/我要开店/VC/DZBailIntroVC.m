//
//  DZBailIntroVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZBailIntroVC.h"
#import "DZBailVC.h"
#import "DZPayVC.h"
#import "DZOpenGCShopVC.h"
#import "DZOpenSTShopVC.h"
#import "DZOpenWPShopVC.h"

#import "DZOpenShopSelectionView.h"

@interface DZBailIntroVC ()<DZOpenShopSelectionViewDelegate, DZPayVCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) DZOpenShopSelectionView *shopSelectionView;

@end

@implementation DZBailIntroVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴纳保证金";
    
    NSArray *vcs = self.navigationController.viewControllers;
    NSArray *newVcs = [NSArray arrayWithObjects:vcs.firstObject, vcs.lastObject, nil];
    self.navigationController.viewControllers = newVcs;
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)payButtonAction {
    DZPayVC *vc = [DZPayVC new];
    vc.needSwitch = self.needSwitch;
    vc.delegate = self;
    vc.price = [self.priceLabel.text floatValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)reChooseButtonAction {
    [self showShopSelectionView];
}
#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZPayVCDelegate ----
- (void)didPaySuccess{
    [[NSNotificationCenter defaultCenter] postNotificationName:SELLERMEVCREFRESHNOTIFICATION object:nil];
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
- (void)getData{
    NSDictionary *params =nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getShopBondMoney" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        if ([request.responseJSONObject[@"status"] integerValue]) {
            self.priceLabel.text = request.responseJSONObject[@"data"][@"shop_bond"];
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

- (void)hideOperationView{
    [UIView animateWithDuration:.2 animations:^{
        self.shopSelectionView.frame = CGRectMake(0, SCREEN_HEIGHT, self.shopSelectionView.width, self.shopSelectionView.height);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.shopSelectionView removeFromSuperview];
    }];
}

#pragma mark - --- getters 和 setters ----
- (DZOpenShopSelectionView *)shopSelectionView{
    if (!_shopSelectionView) {
        _shopSelectionView = [DZOpenShopSelectionView viewFormNib];
        _shopSelectionView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 255);
        _shopSelectionView.delegate = self;
    }
    return _shopSelectionView;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOperationView)]];
    }
    return _maskView;
}

@end
