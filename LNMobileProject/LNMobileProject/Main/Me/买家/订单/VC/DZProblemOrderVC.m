//
//  DZProblemOrderVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZProblemOrderVC.h"
#import "DZRefundDeliveryVC.h"
#import "DZProblemOrderDetailVC.h"

#import "DZRefundOrderCell.h"

#import "DZGetAllRefundListModel.h"

@interface DZProblemOrderVC ()<UITableViewDelegate, UITableViewDataSource, DZRefundOrderCellDelegate, DZProblemOrderDetailVCDelegate, DZRefundDeliveryVCDelegate>

@property (nonatomic, strong) UIButton *ingButton;
@property (nonatomic, strong) UIButton *finishedButton;
@property (nonatomic, strong) UIView *slider;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSString *type;

@end

@implementation DZProblemOrderVC

static  NSString  *CellIdentiferId = @"DZMyOrderCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"退货退款";
    
    [self.view addSubview:self.ingButton];
    [self.view addSubview:self.finishedButton];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.line];
    [self.view addSubview:self.tableView];
    
    [self setSubViewsFrame];
    
    self.type = @"1";//1：为进行中 2：为已完成
    [self getData];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{
    [self.ingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, 40));
        make.top.left.mas_equalTo(0);
    }];
    [self.finishedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, 40));
        make.top.right.mas_equalTo(0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line.mas_bottom);
        make.right.bottom.left.mas_equalTo(0);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)ingButtonAction{
    _ingButton.selected = YES;
    _finishedButton.selected = NO;
    [UIView animateWithDuration:.2 animations:^{
        self.slider.frame = CGRectMake(0, self.slider.y, self.slider.width, self.slider.height);
    }];
    self.type = @"1";
    [self getData];
}

- (void)finishedButtonAction{
    _ingButton.selected = NO;
    _finishedButton.selected = YES;
    [UIView animateWithDuration:.2 animations:^{
        self.slider.frame = CGRectMake(SCREEN_WIDTH / 2, self.slider.y, self.slider.width, self.slider.height);
    }];
    self.type = @"2";
    [self getData];
}

#pragma mark - ---- DZRefundOrderCellDelegate ----
- (void)didSelectCellOrderSn:(NSString *)orderSn orderGoodId:(NSString *)orderGoodId{
    DZProblemOrderDetailVC *vc = [DZProblemOrderDetailVC new];
    vc.order_sn = orderSn;
    vc.order_goods_id = orderGoodId;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didChangeOrder:(NSString *)order_sn withOperationCode:(NSInteger)code{
    switch (code) {
        case 0:{//撤销
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"撤销申请？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *params = @{@"order_sn":order_sn};
                LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/goBackRefundOrder" parameters:params];
                [SVProgressHUD show];
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    [SVProgressHUD dismiss];
                    LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                    if (model.isSuccess) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:USERORDERINFOUPDATEDNOTIFICATION object:nil];
                        [SVProgressHUD showSuccessWithStatus:model.info];
                        for (DZRefundItemModel *model in self.dataArray) {
                            if ([model.order_sn isEqualToString:order_sn]) {
                                NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
                                [array removeObject:model];
                                self.dataArray = array;
                                [self.tableView reloadData];
                                break;
                            }
                        }
                    }else{
                        [SVProgressHUD showErrorWithStatus:model.info];
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
            break;
        }
        case 1:{//发货
            DZRefundDeliveryVC *vc = [DZRefundDeliveryVC new];
            vc.order_sn = order_sn;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{//删除订单
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"删除订单？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *params = @{@"order_sn":order_sn};
                LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/delRefundOrder" parameters:params];
                [SVProgressHUD show];
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    [SVProgressHUD dismiss];
                    LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                    if (model.isSuccess) {
                        [SVProgressHUD showSuccessWithStatus:model.info];
                        [[NSNotificationCenter defaultCenter] postNotificationName:USERORDERINFOUPDATEDNOTIFICATION object:nil];
                        for (DZRefundItemModel *model in self.dataArray) {
                            if ([model.order_sn isEqualToString:order_sn]) {
                                NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
                                [array removeObject:model];
                                self.dataArray = array;
                                [self.tableView reloadData];
                                break;
                            }
                        }
                    }else{
                        [SVProgressHUD showErrorWithStatus:model.info];
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
            break;
        }
        default:
            break;
    }
}
#pragma mark - ---- DZRefundDeliveryVCDelegate ----
- (void)didSendSuccess{
    [self getData];
}

#pragma mark - ---- DZProblemOrderDetailVCDelegate ----
- (void)didRevokeOrder{
    [self getData];
}

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZRefundItemModel *model = self.dataArray[indexPath.row];
    return 135.5 + model.goods_list.count * 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZRefundOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZRefundOrderCell" owner:nil options:nil] lastObject];
    }
    DZRefundItemModel *model = self.dataArray[indexPath.row];
    [cell fillData:model isSeller:NO];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"shop_state":self.type};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getAllRefundList" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetAllRefundListModel *model = [DZGetAllRefundListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.dataArray = model.data;
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (UIButton *)ingButton{
    if (!_ingButton) {
        _ingButton = [UIButton new];
        [_ingButton setTitle:@"进行中" forState:UIControlStateNormal];
        [_ingButton setTitleColor:HEXCOLOR(0xff8903) forState:UIControlStateSelected];
        [_ingButton setTitleColor:DefaultTextBlackColor forState:UIControlStateNormal];
        _ingButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _ingButton.backgroundColor = [UIColor whiteColor];
        [_ingButton addTarget:self action:@selector(ingButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _ingButton.selected = YES;
    }
    return _ingButton;
}

- (UIButton *)finishedButton{
    if (!_finishedButton) {
        _finishedButton = [UIButton new];
        [_finishedButton setTitle:@"已结束" forState:UIControlStateNormal];
        [_finishedButton setTitleColor:HEXCOLOR(0xff8903) forState:UIControlStateSelected];
        [_finishedButton setTitleColor:DefaultTextBlackColor forState:UIControlStateNormal];
        _finishedButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _finishedButton.backgroundColor = [UIColor whiteColor];
        [_finishedButton addTarget:self action:@selector(finishedButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishedButton;
}

- (UIView *)slider{
    if (!_slider) {
        _slider = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH / 2, 1)];
        _slider.backgroundColor = HEXCOLOR(0xff8903);
    }
    return _slider;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0.5)];
        _line.backgroundColor = BannerOtherDotColor;
    }
    return _line;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
