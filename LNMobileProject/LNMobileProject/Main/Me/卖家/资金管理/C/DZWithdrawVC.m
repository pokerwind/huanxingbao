//
//  DZWithdrawVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZWithdrawVC.h"
#import "DZCardManagementVC.h"

#import "DZWithdrawCardCell.h"
#import "DZWithdrawHeader.h"
#import "DZWithdrawFooter.h"
#import "DZNoCardCell.h"
#import "DZPayPassInputView.h"

#import "DZGetUserBankCardListModel.h"

@interface DZWithdrawVC ()<UITableViewDelegate, UITableViewDataSource, DZCardManagementVCDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DZWithdrawHeader *header;
@property (strong, nonatomic) DZWithdrawFooter *footer;

@property (nonatomic, strong) DZPayPassInputView *passInputView;
@property (nonatomic, strong) UIView *mask;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation DZWithdrawVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    
    [self.view addSubview:self.tableView];
    
    [self setSubViewsLayout];
    
    [self getData];
}

- (void)viewDidLayoutSubviews{
    self.header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    self.footer.height = 200;
}

#pragma mark - ---- 布局代码 ----
- (void)setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)withdrawButtonAction{
    if (!self.header.moneyTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入提现金额"];
        return;
    }
    
    NSString *cardId;
    for (DZUserBankCardModel *model in self.dataArray) {
        if (model.isSelected) {
            cardId = model.id;
        }
    }
    
    if (!cardId) {
        [SVProgressHUD showErrorWithStatus:@"请选择提现银行卡"];
        return;
    }
    
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
}

- (void)cardButtonAction{
    DZCardManagementVC *vc = [DZCardManagementVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)inputViewCancelButtonClick{
    self.passInputView.passTextField.text = @"";
    [self.passInputView removeFromSuperview];
    [self.mask removeFromSuperview];
}

- (void)inputViewConfirmButtonClick{
    NSString *passsword = self.passInputView.passTextField.text;
    if (!passsword.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入支付密码"];
        return;
    }
    
    [self.passInputView removeFromSuperview];
    [self.mask removeFromSuperview];
    
    NSString *cardId;
    for (DZUserBankCardModel *model in self.dataArray) {
        if (model.isSelected) {
            cardId = model.id;
        }
    }
    
    NSDictionary *params = @{@"id":cardId, @"money":self.header.moneyTextField.text, @"pay_password":passsword};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/ShopCenterApi/withdrawCard" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didWithdrawSuccess)]) {
                [self.delegate didWithdrawSuccess];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZCardManagementVCDelegate ----
- (void)cardDataDidRefresh{
    [self getData];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count) {
        static NSString *identifier = @"DZWithdrawCardCell";
        DZWithdrawCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [DZWithdrawCardCell viewFormNib];
        }
        DZUserBankCardModel *model = self.dataArray[indexPath.row];
        [cell fillData:model];
        
        return cell;
    }else{
        DZNoCardCell *cell = [DZNoCardCell viewFormNib];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataArray.count) {
        for (DZUserBankCardModel *model in self.dataArray) {
            model.isSelected = NO;
        }
        DZUserBankCardModel *model = self.dataArray[indexPath.row];
        model.isSelected = YES;
        [self.tableView reloadData];
    }else{
        DZCardManagementVC *vc = [DZCardManagementVC new];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getUserBankCardList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        DZGetUserBankCardListModel *model = [DZGetUserBankCardListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.dataArray = model.data;
            [self.tableView reloadData];
            if (self.dataArray.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"请添加银行卡"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.header;
        _tableView.tableFooterView = self.footer;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.emptyDataSetSource = self;
    }
    return _tableView;
}

- (DZWithdrawHeader *)header{
    if (!_header) {
        _header = [DZWithdrawHeader viewFormNib];
    }
    return _header;
}

- (DZWithdrawFooter *)footer{
    if (!_footer) {
        _footer = [DZWithdrawFooter viewFormNib];
        [_footer.withdrawButton addTarget:self action:@selector(withdrawButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footer.cardButton addTarget:self action:@selector(cardButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footer;
}

- (DZPayPassInputView *)passInputView{
    if (!_passInputView) {
        _passInputView = [DZPayPassInputView viewFormNib];
        _passInputView.backgroundColor = [UIColor whiteColor];
        _passInputView.layer.cornerRadius = 4;
        _passInputView.titleLabel.text = @"请输入支付密码";
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

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
