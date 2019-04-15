//
//  DZAddressSelectionVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZAddressSelectionVC.h"
#import "DZAddMyAddressVC.h"

#import "DZAddressSelectionCell.h"

#import "DPMobileApplication.h"
#import "DZGetAddressListModel.h"

@interface DZAddressSelectionVC ()<UITableViewDelegate, UITableViewDataSource, DZAddMyAddressVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addAddressButton;
@property (strong, nonatomic) NSArray *addressArray;

@end

@implementation DZAddressSelectionVC

static  NSString  *CellIdentiferId = @"DZAddressSelectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的收货地址";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addAddressButton];
    
    [self setSubViewsFrame];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
    [self.addAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.right.bottom.left.mas_equalTo(0);
    }];
}

#pragma mark - ---- DZAddMyAddressVCDelegate ----
- (void)didUpdateAddress{
    [self getData];
}

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectAddress:)]) {
        DZMyAddressItemModel *model = self.addressArray[indexPath.row];
        [self.delegate didSelectAddress:model];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZAddressSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZAddressSelectionCell" owner:nil options:nil] lastObject];
    }
    
    DZMyAddressItemModel *model = self.addressArray[indexPath.row];
    [cell fillData:model];
    
    return cell;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)addAddressButtonAction{
    DZAddMyAddressVC *vc = [DZAddMyAddressVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cellDeleteButtonAction:(UIButton *)btn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定删除地址吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        DZMyAddressItemModel *model = self.addressArray[btn.tag];
        NSDictionary *params = @{@"address_id":model.address_id};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/delAddress" parameters:params];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                [self.tableView.mj_header beginRefreshing];
            }else{
                [SVProgressHUD showErrorWithStatus:model.msg?:@"网络不给力"];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)cellEditButtonAction:(UIButton *)btn{
    DZMyAddressItemModel *model = self.addressArray[btn.tag];
    DZAddMyAddressVC *vc = [DZAddMyAddressVC new];
    vc.addressId = model.address_id;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getAddressList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        DZGetAddressListModel *model = [DZGetAddressListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.addressArray = model.data;
            for (DZMyAddressItemModel *models in model.data) {
                if ([models.address_id isEqualToString:self.currentAddressId]) {
                    models.isSelected = YES;
                }
            }
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info?:@"网络不给力"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData];
        }];
    }
    return _tableView;
}

- (UIButton *)addAddressButton{
    if (!_addAddressButton) {
        _addAddressButton = [UIButton new];
        [_addAddressButton setTitle:@"添加新地址" forState:UIControlStateNormal];
        [_addAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addAddressButton addTarget:self action:@selector(addAddressButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _addAddressButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _addAddressButton.backgroundColor = HEXCOLOR(0xff7722);
    }
    return _addAddressButton;
}

- (NSArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [NSArray array];
    }
    return _addressArray;
}


@end
