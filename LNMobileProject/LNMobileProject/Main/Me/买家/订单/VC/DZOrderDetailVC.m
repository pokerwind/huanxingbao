//
//  DZOrderDetailVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZOrderDetailVC.h"
#import "DZProblemOrderVC.h"
#import "DZApplyRefundVC.h"
#import "DZCartPayVC.h"
#import "DZExpressDetailVC.h"
#import "DZOrderCommentVC.h"
#import "DZDeliveryVC.h"
#import "DZModifyOrderVC.h"
#import "DZGoodsDetailVC.h"

#import "DZOrderDetailHeaderView.h"
#import "DZOrderDetailCell.h"
#import "DZOrderDetailBottomView.h"

#import "DPMobileApplication.h"
#import "DZGetOrderDetailModel.h"
#import "DZEMChatUserModel.h"
#import "ChatViewController.h"

@interface DZOrderDetailVC ()<UITableViewDataSource, UITableViewDelegate, DZOrderDetailCellDelegate, DZApplyRefundVCDelegate, DZCartPayVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DZOrderDetailHeaderView *header;
@property (strong, nonatomic) NSArray *goodsArray;
@property (strong, nonatomic) DZGetOrderDetailModel *model;
@property (strong, nonatomic) DZOrderDetailBottomView *bottomView;

@property (nonatomic) BOOL canRefund;

@end

@implementation DZOrderDetailVC

static  NSString  *CellIdentiferId = @"DZOrderDetailCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [self.view addSubview:self.tableView];
    
    [self setSubViewsFrame];
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{
    if (self.isPreviewMode) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-40);
        }];
        [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.right.bottom.left.mas_equalTo(0);
        }];
    }
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(323);
        make.width.mas_equalTo(self.tableView);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)phoneButtonAction:(UIButton *)btn{
    if ([DPMobileApplication sharedInstance].isSellerMode) {
        if (self.model.data.mobile.length) {
            NSString *phone = [NSString stringWithFormat:@"telprompt://%@", self.model.data.mobile];
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phone]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"买家预留电话无效"];
        }
    }else{
        if (self.model.data.shop_mobile.length) {
            NSString *phone = [NSString stringWithFormat:@"telprompt://%@", self.model.data.shop_mobile];
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phone]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"商家预留电话无效"];
        }
    }
}

- (void)messageButtonAction:(UIButton *)btn{
        if ([DPMobileApplication sharedInstance].isSellerMode) {
            //卖家和买家聊天？
            if(!self.model.data.echat.emchat_username) {
                return;
            }
            
            [self chatWithInfo:self.model.data.echat];
            
        } else {
            if (!self.model.data.shop_id) {
                return;
            }
            
            //根据shop_id获取 客服信息并对话
            [self chat:self.model.data.shop_id];
        }
    

}

- (void)bottomButtonClick:(UIButton *)btn{
    switch (btn.tag) {
        case 0:{//删除订单
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定删除订单吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if ([DPMobileApplication sharedInstance].isSellerMode) {
                    NSDictionary *params = @{@"order_sn":self.order_sn, @"order_status":@"100"};
                    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/chanageOrderStatus" parameters:params];
                    [SVProgressHUD show];
                    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                        if (model.isSuccess) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMYORDERNOTIFICATION object:nil];
                            [SVProgressHUD showSuccessWithStatus:model.info];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [SVProgressHUD showErrorWithStatus:model.info];
                        }
                    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                        [SVProgressHUD showErrorWithStatus:error.domain];
                    }];
                }else{
                    NSDictionary *params = @{@"order_sn":self.order_sn, @"order_status":@"100"};
                    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/chanageOrderStatus" parameters:params];
                    [SVProgressHUD show];
                    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                        if (model.isSuccess) {
                            [SVProgressHUD showSuccessWithStatus:model.info];
                            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMYORDERNOTIFICATION object:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [SVProgressHUD showErrorWithStatus:model.info];
                        }
                    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                        [SVProgressHUD showErrorWithStatus:error.domain];
                    }];
                }
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action1];
            [alert addAction:action2];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
            break;
        }
        case 1:{//修改价格
            DZModifyOrderVC *vc = [DZModifyOrderVC new];
            vc.order_sn = self.order_sn;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{//催促买家付款
            NSDictionary *params = @{@"order_sn":self.order_sn};
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/reminderPayOrder" parameters:params];
            [SVProgressHUD show];
            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                if (model.isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:model.info];
                }else{
                    [SVProgressHUD showErrorWithStatus:model.info];
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }];
            break;
        }
        case 3:{//取消订单
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定取消订单吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if ([DPMobileApplication sharedInstance].isSellerMode) {
                    NSDictionary *params = @{@"order_sn":self.order_sn, @"order_status":@"0"};
                    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/chanageOrderStatus" parameters:params];
                    [SVProgressHUD show];
                    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                        if (model.isSuccess) {
                            [SVProgressHUD showSuccessWithStatus:model.info];
                            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMYORDERNOTIFICATION object:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [SVProgressHUD showErrorWithStatus:model.info];
                        }
                    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                        [SVProgressHUD showErrorWithStatus:error.domain];
                    }];
                }else{
                    NSDictionary *params = @{@"order_sn":self.order_sn, @"order_status":@"0"};
                    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/chanageOrderStatus" parameters:params];
                    [SVProgressHUD show];
                    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                        if (model.isSuccess) {
                            [SVProgressHUD showSuccessWithStatus:model.info];
                            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMYORDERNOTIFICATION object:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [SVProgressHUD showErrorWithStatus:model.info];
                        }
                    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                        [SVProgressHUD showErrorWithStatus:error.domain];
                    }];
                }
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action1];
            [alert addAction:action2];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
            break;
        }
        case 4:{//买家前往付款
            DZCartPayVC *vc = [DZCartPayVC new];
            vc.delegate = self;
            vc.goodsCount = self.model.data.total_buy_number;
            vc.goodsPrice = self.model.data.total_amount;
            vc.expressPrice = self.model.data.express_amount;
            vc.totalPrice = self.model.data.real_pay_amount;
            vc.orderSN = self.order_sn;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:{//卖家前往发货
            DZDeliveryVC *vc = [DZDeliveryVC new];
            vc.order_sn = self.order_sn;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6:{//买家提醒发货
            NSDictionary *params = @{@"order_sn":self.order_sn, @"order_status":@"101"};
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/chanageOrderStatus" parameters:params];
            [SVProgressHUD show];
            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                if (model.isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:model.info];
                }else{
                    [SVProgressHUD showErrorWithStatus:model.info];
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }];
            break;
        }
        case 7:{//查看物流
            DZExpressDetailVC *vc = [DZExpressDetailVC new];
            vc.order_sn = self.order_sn;
            vc.imgUrl = ((DZGoodInfoModel *)self.model.data.order_goods[0]).goods_img;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 8:{//买家确认收货
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您确认已收到货吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *params = @{@"order_sn":self.order_sn, @"order_status":@"4"};
                LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/chanageOrderStatus" parameters:params];
                [SVProgressHUD show];
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                    if (model.isSuccess) {
                        [SVProgressHUD showSuccessWithStatus:model.info];
                        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMYORDERNOTIFICATION object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [SVProgressHUD showErrorWithStatus:model.info];
                    }
                } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:error.domain];
                }];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action1];
            [alert addAction:action2];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
            break;
        }
        case 9:{//前往评价
            DZOrderCommentVC *vc = [DZOrderCommentVC new];
            vc.order_sn = self.order_sn;
            vc.shopId = self.model.data.shop_id;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - ---- DZCartPayVCDelegate ----
- (void)didPaySuccess{
    [self getData];
}

#pragma mark - ---- DZApplyRefundVCDelegate ----
- (void)didSubmitRefund{
    [self getData];
}

#pragma mark - ---- DZOrderDetailCellDelegate ----
- (void)refundWithIndex:(NSInteger)index{
    DZGoodInfoModel *model = self.model.data.order_goods[index];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定要申请退货退款吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        DZApplyRefundVC *vc = [DZApplyRefundVC new];
        vc.goods_id = model.goods_id;
        vc.order_goods_id = model.order_goods_id;
        vc.order_sn = self.model.data.order_sn;
        vc.delegate = self;
        if ([self.model.data.order_status integerValue] > 2) {
            vc.canReturnGood = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)didClickGood:(NSString *)goodId{
    DZGoodsDetailVC *vc = [DZGoodsDetailVC new];
    vc.goodsId = goodId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    for (DZGoodInfoModel *model in self.model.data.order_goods) {
        NSMutableArray *array = [NSMutableArray array];
        for (DZOrderDetailSpecModel *models in model.spec_list) {
            [array addObject:[NSString stringWithFormat:@"%@*%@", models.spec, models.buy_number]];
        }
        NSString *str = [array componentsJoinedByString:@","];
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, MAXFLOAT);
        CGFloat textH = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        height += textH + 98;
    }
    
    return 75 + height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.goodsArray.count) {
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZOrderDetailCell" owner:nil options:nil] lastObject];
    }
    
    cell.canRefund = self.canRefund;
    [cell fillData:self.model];
    cell.delegate = self;
    cell.phoneButton.tag = indexPath.row;
    cell.messageButton.tag = indexPath.row;
    [cell.phoneButton addTarget:self action:@selector(phoneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.messageButton addTarget:self action:@selector(messageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.messageButton.hidden = YES;
    return cell;
}

#pragma mark - --- 私有方法 ----
- (void)getData{
    [SVProgressHUD show];
    NSDictionary *params = @{@"order_sn":self.order_sn};
    LNetWorkAPI *api;
    if ([DPMobileApplication sharedInstance].isSellerMode) {
        api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getOrderInfo" parameters:params];
    }else{
        api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getOrderDetail" parameters:params];
    }
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        self.model = [DZGetOrderDetailModel objectWithKeyValues:request.responseJSONObject];
        if ([self.model.data.order_status integerValue] > 1) {
            self.canRefund = YES;
        }
        if (self.model.isSuccess) {
            [self.header fillData:self.model];
            self.goodsArray = self.model.data.order_goods;
            [self.tableView reloadData];
            
            if (!self.isPreviewMode) {
                [self setupBottomView];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:self.model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)setupBottomView{
    switch ([self.model.data.order_status integerValue]) {
        case 0:{
            self.bottomView.leftButton.hidden = YES;
            self.bottomView.middleButton.hidden = YES;
            self.bottomView.rightButton.hidden = YES;
//            [self.bottomView.rightButton setTitle:@"  删除订单  " forState:UIControlStateNormal];
//            self.bottomView.rightButton.tag = 0;
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.left.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            break;
        }
        case 1:{
            self.bottomView.leftButton.hidden = YES;
            self.bottomView.middleButton.hidden = NO;
            self.bottomView.rightButton.hidden = NO;
            if ([DPMobileApplication sharedInstance].isSellerMode) {
                self.bottomView.leftButton.hidden = NO;
                [self.bottomView.rightButton setTitle:@"  修改价格  " forState:UIControlStateNormal];
                self.bottomView.rightButton.hidden = YES;
                self.bottomView.rightButton.tag = 1;
                [self.bottomView.middleButton setTitle:@"  催促买家  " forState:UIControlStateNormal];
                self.bottomView.middleButton.tag = 2;
                [self.bottomView.leftButton setTitle:@"  取消订单  " forState:UIControlStateNormal];
                self.bottomView.leftButton.tag = 3;
            }else{
                self.bottomView.leftButton.hidden = YES;
                [self.bottomView.rightButton setTitle:@"  前往付款  " forState:UIControlStateNormal];
                self.bottomView.rightButton.tag = 4;
                [self.bottomView.middleButton setTitle:@"  取消订单  " forState:UIControlStateNormal];
                self.bottomView.middleButton.tag = 3;
            }
            break;
        }
        case 2:{
            self.bottomView.leftButton.hidden = YES;
            self.bottomView.middleButton.hidden = YES;
            self.bottomView.rightButton.hidden = NO;
            if ([DPMobileApplication sharedInstance].isSellerMode) {
                [self.bottomView.rightButton setTitle:@"  前往发货  " forState:UIControlStateNormal];
                self.bottomView.rightButton.tag = 5;
            }else{
                [self.bottomView.rightButton setTitle:@"  提醒发货  " forState:UIControlStateNormal];
                self.bottomView.rightButton.tag = 6;
            }
            break;
        }
        case 3:{
            self.bottomView.leftButton.hidden = YES;
            self.bottomView.rightButton.hidden = NO;
            if ([DPMobileApplication sharedInstance].isSellerMode) {
                self.bottomView.middleButton.hidden = YES;
                [self.bottomView.rightButton setTitle:@"  查看物流  " forState:UIControlStateNormal];
                self.bottomView.rightButton.tag = 7;
            }else{
                self.bottomView.middleButton.hidden = NO;
                [self.bottomView.rightButton setTitle:@"  确认收货  " forState:UIControlStateNormal];
                self.bottomView.rightButton.tag = 8;
                [self.bottomView.middleButton setTitle:@"  查看物流  " forState:UIControlStateNormal];
                self.bottomView.middleButton.tag = 7;
            }
            break;
        }
        case 4:{
            if ([DPMobileApplication sharedInstance].isSellerMode) {
                self.bottomView.leftButton.hidden = YES;
                self.bottomView.middleButton.hidden = YES;
                self.bottomView.rightButton.hidden = NO;
//                [self.bottomView.rightButton setTitle:@"  删除订单  " forState:UIControlStateNormal];
//                self.bottomView.rightButton.tag = 0;
                [self.bottomView.rightButton setTitle:@"  查看物流  " forState:UIControlStateNormal];
                self.bottomView.rightButton.tag = 7;
            }else{
                if (self.is_evaluation) {
                    self.bottomView.leftButton.hidden = YES;
                    self.bottomView.middleButton.hidden = YES;
                    self.bottomView.rightButton.hidden = NO;
//                    [self.bottomView.rightButton setTitle:@"  删除订单  " forState:UIControlStateNormal];
//                    self.bottomView.rightButton.tag = 0;
                    [self.bottomView.rightButton setTitle:@"  查看物流  " forState:UIControlStateNormal];
                    self.bottomView.rightButton.tag = 7;
                }else{
                    self.bottomView.leftButton.hidden = YES;
                    self.bottomView.middleButton.hidden = NO;
                    self.bottomView.rightButton.hidden = NO;
                    [self.bottomView.rightButton setTitle:@"  前往评价  " forState:UIControlStateNormal];
                    self.bottomView.rightButton.tag = 9;
//                    [self.bottomView.middleButton setTitle:@"  删除订单  " forState:UIControlStateNormal];
//                    self.bottomView.middleButton.tag = 0;
                    [self.bottomView.middleButton setTitle:@"  查看物流  " forState:UIControlStateNormal];
                    self.bottomView.middleButton.tag = 7;
                }
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.header;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
    }
    return _tableView;
}

- (DZOrderDetailHeaderView *)header{
    if (!_header) {
        _header = [[[NSBundle mainBundle] loadNibNamed:@"DZOrderDetailHeaderView" owner:self options:nil] lastObject];
    }
    return _header;
}

- (NSArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [NSArray array];
    }
    return _goodsArray;
}

- (DZOrderDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [DZOrderDetailBottomView viewFormNib];
        [_bottomView.rightButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.middleButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.leftButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

@end
