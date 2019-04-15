//
//  DZMyAddressVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMyAddressVC.h"
#import "DZAddMyAddressVC.h"

#import "DZMyAddressCell.h"

#import "DPMobileApplication.h"
#import "DZGetAddressListModel.h"

@interface DZMyAddressVC ()<UITableViewDelegate, UITableViewDataSource, DZAddMyAddressVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addAddressButton;
@property (strong, nonatomic) NSArray *addressArray;

@end

@implementation DZMyAddressVC

static  NSString  *CellIdentiferId = @"DZMyAddressCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的收货地址";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addAddressButton];
    
    [self setSubViewsFrame];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    return 144;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZMyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZMyAddressCell" owner:nil options:nil] lastObject];
    }
    
    DZMyAddressItemModel *model = self.addressArray[indexPath.row];
    [cell fillName:model.consignee mobile:model.mobile address:model.address isDefault:model.is_default];
    cell.deleteButton.tag = indexPath.row;
    cell.editButton.tag = indexPath.row;
    cell.defaultButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(cellDeleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editButton addTarget:self action:@selector(cellEditButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.defaultButton addTarget:self action:@selector(cellDefaultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)addAddressButtonAction{
    DZAddMyAddressVC *vc = [DZAddMyAddressVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cellDeleteButtonAction:(UIButton *)btn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定删除地址吗？" preferredStyle:UIAlertControllerStyleAlert];
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

- (void)cellDefaultButtonAction:(UIButton *)btn{
    DZMyAddressItemModel *model = self.addressArray[btn.tag];
    if (model.is_default) {
        [SVProgressHUD showInfoWithStatus:@"不能取消默认地址，请设置另一处地址为默认."];
        return;
    }
    
    NSString *addressId = model.address_id;
    NSDictionary *params = @{@"address_id":model.address_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/makeAddressDefault" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            for (DZMyAddressItemModel *models in self.addressArray) {
                models.is_default = 0;
                if ([models.address_id isEqualToString:addressId]) {
                    models.is_default = 1;
                }
            }
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
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
        _tableView.allowsSelection = NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
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
