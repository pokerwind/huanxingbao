//
//  DZGoodPreviewVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/12.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodPreviewVC.h"
#import "DZCreateGoodVC.h"
#import "DZGoodsDetailVC.h"
#import "LNNavigationController.h"

@interface DZGoodPreviewVC ()<DZCreateGoodVCDelegate>

@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@property (strong, nonatomic) DZGoodsDetailVC *detailVC;

@end

@implementation DZGoodPreviewVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.detailVC.view];
    self.detailVC.bottomView.hidden = YES;
    [self.detailVC.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    
    [self fillMode];
    
    [self setSubViewsLayout];
}

#pragma mark - ---- 布局代码 ----
- (void)setSubViewsLayout{
    [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)editButtonClick {
    DZCreateGoodVC *vc = [DZCreateGoodVC new];
    vc.delegate = self;
    vc.isEditMode = YES;
    vc.goodId = self.goods_id;
    LNNavigationController *nvc = [[LNNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)operationButtonClick {
    NSString *goodsState;
    if ([self.currentType isEqualToString:@"0"]) {
        goodsState = @"1";
    }else{
        goodsState = @"0";
    }
    NSDictionary *params = @{@"goods_state":goodsState, @"goods_id":self.goods_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsEditApi/changeGoodsStatus" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(goodOperationSuccess:)]) {
                [self.delegate goodOperationSuccess:self.goods_id];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZCreateGoodVCDelegate ----
- (void)didModifyGood{
    [self.detailVC loadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodOperationSuccess)]) {
        [self.delegate goodOperationSuccess];
    }
}

#pragma mark - ---- 私有方法 ----
- (void)fillMode{
    if ([self.currentType isEqualToString:@"1"]) {
        [self.operationButton setTitle:@"下架" forState:UIControlStateNormal];
        [self.operationButton setImage:[UIImage imageNamed:@"good_icon_down"] forState:UIControlStateNormal];
    }else{
        [self.operationButton setTitle:@"上架" forState:UIControlStateNormal];
        [self.operationButton setImage:[UIImage imageNamed:@"good_icon_up"] forState:UIControlStateNormal];
    }
}

#pragma mark - --- getters 和 setters ----
- (DZGoodsDetailVC *)detailVC{
    if (!_detailVC) {
        _detailVC = [DZGoodsDetailVC new];
        _detailVC.goodsId = self.goods_id;
        [_detailVC.backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailVC;
}

@end
