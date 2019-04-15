//
//  DZSellerProblemOrderVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSellerProblemOrderVC.h"
#import "DZSellerProblemOrderDetailVC.h"

#import "DZRefundOrderCell.h"
#import "DZPayPassInputView.h"

#import "DZGetAllRefundListModel.h"

@interface DZSellerProblemOrderVC ()<UITableViewDelegate, UITableViewDataSource, DZRefundOrderCellDelegate, DZSellerProblemOrderDetailVCDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *slider;
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UILabel *inLabel;
@property (nonatomic, strong) UILabel *outLabel;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *inButton;
@property (nonatomic, strong) UIButton *outButton;
@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSString *type;

@property (nonatomic, strong) DZPayPassInputView *passInputView;
@property (nonatomic, strong) UIView *mask;
@property (nonatomic, strong) NSString *passViewOrderSN;

@end

@implementation DZSellerProblemOrderVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退货退款";
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.line];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.allLabel];
    [self.view addSubview:self.inLabel];
    [self.view addSubview:self.outLabel];
    [self.view addSubview:self.allButton];
    [self.view addSubview:self.inButton];
    [self.view addSubview:self.outButton];
    [self.view addSubview:self.tableView];
    
    [self setSubViewsFrame];
    
    self.type = @"1";
    [self getData];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(39.5);
        make.right.left.mas_equalTo(0);
    }];
    [self.allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH / 3);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    [self.inLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.mas_equalTo(self.allLabel);
        make.left.mas_equalTo(self.allLabel.mas_right);
    }];
    [self.outLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.mas_equalTo(self.allLabel);
        make.left.mas_equalTo(self.inLabel.mas_right);
    }];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.allLabel);
    }];
    [self.inButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.inLabel);
    }];
    [self.outButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.outLabel);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.right.bottom.left.mas_equalTo(0);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)switchButtonAction:(UIButton *)btn{
    self.allLabel.textColor = DefaultTextBlackColor;
    self.inLabel.textColor = DefaultTextBlackColor;
    self.outLabel.textColor = DefaultTextBlackColor;
    
    switch (btn.tag) {
        case 0:{
            self.allLabel.textColor = HEXCOLOR(0xff8903);
            self.type = @"1";
            [self getData];
            break;
        }
        case 1:{
            self.inLabel.textColor = HEXCOLOR(0xff8903);
            self.type = @"2";
            [self getData];
            break;
        }
        case 2:{
            self.outLabel.textColor = HEXCOLOR(0xff8903);
            self.type = @"3";
            [self getData];
            break;
        }
        default:
            break;
    }
    [UIView animateWithDuration:.2 animations:^{
        self.slider.frame = CGRectMake(btn.tag * SCREEN_WIDTH / 3, self.slider.y, self.slider.width, self.slider.height);
    }];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZSellerProblemOrderDetailVCDelegate ----
- (void)didChangeStatus{
    [self getData];
}

- (void)didDeleteOrder:(NSString *)orderSn{
    for (DZRefundItemModel *model in self.dataArray) {
        if ([model.order_sn isEqualToString:orderSn]) {
            NSMutableArray *arrar = [NSMutableArray arrayWithArray:self.dataArray];
            [arrar removeObject:model];
            self.dataArray = arrar;
            [self.tableView reloadData];
            break;
        }
    }
}

#pragma mark - ---- DZRefundOrderCellDelegate ----
//3:确认退款 4:拒绝退款 5:催促买家 6:卖家删除订单 7:同意退货 8:拒绝退货
- (void)didChangeOrder:(NSString *)order_sn withOperationCode:(NSInteger)code{
    switch (code) {
        case 3:{
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
            self.passInputView.tag = 1;
            self.passViewOrderSN = order_sn;

            break;
        }
        case 4:{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"拒绝买家申请？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *params = @{@"order_sn":order_sn, @"refund_type":@"3"};
                LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/agreeRefund" parameters:params];
                [SVProgressHUD show];
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    [SVProgressHUD dismiss];
                    LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                    if (model.isSuccess) {
                        for (DZRefundItemModel *model in self.dataArray) {
                            if ([model.order_sn isEqualToString:order_sn]) {
                                NSMutableArray *arrar = [NSMutableArray arrayWithArray:self.dataArray];
                                [arrar removeObject:model];
                                self.dataArray = arrar;
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
        case 5:{
            for (DZRefundItemModel *model in self.dataArray) {
                if ([model.order_sn isEqualToString:order_sn]) {
                    NSDictionary *params = @{@"refund_id":model.refund_id};
                    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/reminderRefundOrder" parameters:params];
                    [SVProgressHUD show];
                    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                        [SVProgressHUD dismiss];
                        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                        if (model.isSuccess) {
                            [SVProgressHUD showSuccessWithStatus:model.info];
                        }else{
                            [SVProgressHUD showErrorWithStatus:model.info];
                        }
                    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showErrorWithStatus:error.domain];
                    }];
                }
            }
            break;
        }
        case 6:{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确认删除？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *params = @{@"order_sn":order_sn};
                LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/delRefundOrder" parameters:params];
                [SVProgressHUD show];
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    [SVProgressHUD dismiss];
                    LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                    if (model.isSuccess) {
                        for (DZRefundItemModel *model in self.dataArray) {
                            if ([model.order_sn isEqualToString:order_sn]) {
                                NSMutableArray *arrar = [NSMutableArray arrayWithArray:self.dataArray];
                                [arrar removeObject:model];
                                self.dataArray = arrar;
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
        case 7:{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"同意买家申请？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *params = @{@"order_sn":order_sn, @"refund_type":@"2"};
                LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/agreeRefund" parameters:params];
                [SVProgressHUD show];
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    [SVProgressHUD dismiss];
                    LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                    if (model.isSuccess) {
                        for (DZRefundItemModel *model in self.dataArray) {
                            if ([model.order_sn isEqualToString:order_sn]) {
                                NSMutableArray *arrar = [NSMutableArray arrayWithArray:self.dataArray];
                                [arrar removeObject:model];
                                self.dataArray = arrar;
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
        case 8:{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"同意买家申请？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *params = @{@"order_sn":order_sn, @"refund_type":@"4"};
                LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/agreeRefund" parameters:params];
                [SVProgressHUD show];
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    [SVProgressHUD dismiss];
                    LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                    if (model.isSuccess) {
                        for (DZRefundItemModel *model in self.dataArray) {
                            if ([model.order_sn isEqualToString:order_sn]) {
                                NSMutableArray *arrar = [NSMutableArray arrayWithArray:self.dataArray];
                                [arrar removeObject:model];
                                self.dataArray = arrar;
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
        case 9:{//卖家确认收货            
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
            self.passInputView.tag = 2;
            self.passViewOrderSN = order_sn;
            
            break;
        }
        default:
            break;
    }
}

- (void)didSelectCellOrderSn:(NSString *)orderSn orderGoodId:(NSString *)orderGoodId{
    DZSellerProblemOrderDetailVC *vc = [DZSellerProblemOrderDetailVC new];
    vc.delegate = self;
    vc.order_sn = orderSn;
    vc.order_goods_id = orderGoodId;
    for (DZRefundItemModel *model in self.dataArray) {
        if ([model.order_sn isEqualToString:orderSn]) {
            vc.refund_type = model.refund_type;
            vc.shop_state = model.shop_state;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
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
    static  NSString  *CellIdentiferId = @"DZRefundOrderCell";
    DZRefundOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZRefundOrderCell" owner:nil options:nil] lastObject];
    }
    DZRefundItemModel *model = self.dataArray[indexPath.row];
    [cell fillData:model isSeller:YES];
    cell.delegate = self;
    
    return cell;
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
    
    [self.passInputView removeFromSuperview];
    [self.mask removeFromSuperview];
    
    if (self.passInputView.tag == 1) {
        NSDictionary *params = @{@"order_sn":self.passViewOrderSN, @"refund_type":@"1", @"password":self.passInputView.passTextField.text};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/agreeRefund" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                for (DZRefundItemModel *model in self.dataArray) {
                    if ([model.order_sn isEqualToString:self.passViewOrderSN]) {
                        NSMutableArray *arrar = [NSMutableArray arrayWithArray:self.dataArray];
                        [arrar removeObject:model];
                        self.dataArray = arrar;
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
    }else if (self.passInputView.tag == 2){
        NSDictionary *params = @{@"order_sn":self.passViewOrderSN, @"password":self.passInputView.passTextField.text};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/finishOrderRfund" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                for (DZRefundItemModel *models in self.dataArray) {
                    [SVProgressHUD showSuccessWithStatus:model.info];
                    if ([models.order_sn isEqualToString:self.passViewOrderSN]) {
                        NSMutableArray *arrar = [NSMutableArray arrayWithArray:self.dataArray];
                        [arrar removeObject:models];
                        self.dataArray = arrar;
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
    }
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"shop_state":self.type};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getRefundGoodsList" parameters:params];
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
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = BannerOtherDotColor;
    }
    return _line;
}

- (UIView *)slider{
    if (!_slider) {
        _slider = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH / 3, 1)];
        _slider.backgroundColor = HEXCOLOR(0xff8903);
    }
    return _slider;
}

- (UILabel *)allLabel{
    if (!_allLabel) {
        _allLabel = [UILabel new];
        _allLabel.font = [UIFont systemFontOfSize:14];
        _allLabel.textColor = HEXCOLOR(0xff8903);
        _allLabel.textAlignment = NSTextAlignmentCenter;
        _allLabel.text = @"等待我处理";
    }
    return _allLabel;
}

- (UILabel *)inLabel{
    if (!_inLabel) {
        _inLabel = [UILabel new];
        _inLabel.font = [UIFont systemFontOfSize:14];
        _inLabel.textColor = HEXCOLOR(0x333333);
        _inLabel.textAlignment = NSTextAlignmentCenter;
        _inLabel.text = @"等待买家处理";
    }
    return _inLabel;
}

- (UILabel *)outLabel{
    if (!_outLabel) {
        _outLabel = [UILabel new];
        _outLabel.font = [UIFont systemFontOfSize:14];
        _outLabel.textColor = HEXCOLOR(0x333333);
        _outLabel.textAlignment = NSTextAlignmentCenter;
        _outLabel.text = @"已结束";
    }
    return _outLabel;
}

- (UIButton *)allButton{
    if (!_allButton) {
        _allButton = [UIButton new];
        _allButton.tag = 0;
        [_allButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (UIButton *)inButton{
    if (!_inButton) {
        _inButton = [UIButton new];
        _inButton.tag = 1;
        [_inButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inButton;
}

- (UIButton *)outButton{
    if (!_outButton) {
        _outButton = [UIButton new];
        _outButton.tag = 2;
        [_outButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _outButton;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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

@end
