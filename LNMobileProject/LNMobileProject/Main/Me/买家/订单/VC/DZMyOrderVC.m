//
//  DZMyOrderVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/10.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMyOrderVC.h"
#import "DZOrderDetailVC.h"
#import "DZExpressDetailVC.h"
#import "DZOrderCommentVC.h"
#import "DZDeliveryVC.h"
#import "DZModifyOrderVC.h"
#import "DZCartPayVC.h"
#import "DZMessageVC.h"
#import "DZFeedbackVC.h"
#import "DZOrderSearchVC.h"
#import "JSMessageListViewController.h"
#import "FTPopOverMenu.h"
#import "DZMyOrderCell.h"

#import "DZGetOrderListModel.h"
#import "DPMobileApplication.h"

@interface DZMyOrderVC ()<UITableViewDelegate, UITableViewDataSource, MrOrderCellDelegate, DZCartPayVCDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightMoreItem;
@property (nonatomic, strong) UIBarButtonItem *rightSearchItem;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *allTitleLabel;
@property (nonatomic, strong) UILabel *unPaidTitleLabel;
@property (nonatomic, strong) UILabel *unSendTitleLabel;
@property (nonatomic, strong) UILabel *unRecTitleLabel;
@property (nonatomic, strong) UILabel *unCommentTitleLabel;

@property (nonatomic, strong) UILabel *allCountLabel;
@property (nonatomic, strong) UILabel *unPaidCountLabel;
@property (nonatomic, strong) UILabel *unSendCountLabel;
@property (nonatomic, strong) UILabel *unRecCountLabel;
@property (nonatomic, strong) UILabel *unCommentCountLabel;

@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *unPaidButton;
@property (nonatomic, strong) UIButton *unSendButton;
@property (nonatomic, strong) UIButton *unRecButton;
@property (nonatomic, strong) UIButton *unCommentButton;

@property (nonatomic, strong) UIView *slider;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *currentOrdersArray;//存储当前筛选条件下的订单
@property (strong, nonatomic) DZGetOrderListModel *model;

//@property (nonatomic) NSInteger currentSelection;//当前选中的分类
@property (nonatomic) NSInteger pageNum;//当前页码

@end

@implementation DZMyOrderVC
static  NSString  *CellIdentiferId = @"DZMyOrderCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    if ([DPMobileApplication sharedInstance].isSellerMode) {
        self.navigationItem.rightBarButtonItems = @[self.rightMoreItem, self.rightSearchItem];
    }else{
        self.navigationItem.rightBarButtonItem = self.rightMoreItem;
    }
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.line];
    [self.view addSubview:self.allTitleLabel];
    [self.view addSubview:self.unPaidTitleLabel];
    [self.view addSubview:self.unSendTitleLabel];
    [self.view addSubview:self.unRecTitleLabel];
    [self.view addSubview:self.unCommentTitleLabel];
    
    [self.view addSubview:self.allCountLabel];
    [self.view addSubview:self.unPaidCountLabel];
    [self.view addSubview:self.unSendCountLabel];
    [self.view addSubview:self.unRecCountLabel];
    [self.view addSubview:self.unCommentCountLabel];
    
    [self.view addSubview:self.allButton];
    [self.view addSubview:self.unPaidButton];
    [self.view addSubview:self.unSendButton];
    [self.view addSubview:self.unRecButton];
    [self.view addSubview:self.unCommentButton];
    
    [self.view addSubview:self.slider];
    
    [self.view addSubview:self.tableView];
    
    [self setSubViewsFrame];
    
    self.pageNum = 1;
    
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewData) name:REFRESHMYORDERNOTIFICATION object:nil];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.mas_equalTo(43);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(43);
        make.right.left.mas_equalTo(0);
    }];
    [self.allTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH / 5);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(6);
    }];
    [self.unPaidTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.allTitleLabel);
        make.top.mas_equalTo(self.allTitleLabel);
        make.left.mas_equalTo(self.allTitleLabel.mas_right);
    }];
    [self.unSendTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.allTitleLabel);
        make.top.mas_equalTo(self.allTitleLabel);
        make.left.mas_equalTo(self.unPaidTitleLabel.mas_right);
    }];
    [self.unRecTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.allTitleLabel);
        make.top.mas_equalTo(self.allTitleLabel);
        make.left.mas_equalTo(self.unSendTitleLabel.mas_right);
    }];
    [self.unCommentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.allTitleLabel);
        make.top.mas_equalTo(self.allTitleLabel);
        make.left.mas_equalTo(self.unRecTitleLabel.mas_right);
    }];
    [self.allCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.allTitleLabel);
        make.top.mas_equalTo(self.allTitleLabel.mas_bottom).with.offset(3);
    }];
    [self.unPaidCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.unPaidTitleLabel);
        make.top.mas_equalTo(self.unPaidTitleLabel.mas_bottom).with.offset(3);
    }];
    [self.unSendCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.unSendTitleLabel);
        make.top.mas_equalTo(self.unSendTitleLabel.mas_bottom).with.offset(3);
    }];
    [self.unRecCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.unRecTitleLabel);
        make.top.mas_equalTo(self.unRecTitleLabel.mas_bottom).with.offset(3);
    }];
    [self.unCommentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.unCommentTitleLabel);
        make.top.mas_equalTo(self.unCommentTitleLabel.mas_bottom).with.offset(3);
    }];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH / 5);
        make.height.mas_equalTo(40);
    }];
    [self.unPaidButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.mas_equalTo(self.allButton);
        make.left.mas_equalTo(self.allButton.mas_right);
    }];
    [self.unSendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.mas_equalTo(self.allButton);
        make.left.mas_equalTo(self.unPaidButton.mas_right);
    }];
    [self.unRecButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.mas_equalTo(self.allButton);
        make.left.mas_equalTo(self.unSendButton.mas_right);
    }];
    [self.unCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.mas_equalTo(self.allButton);
        make.left.mas_equalTo(self.unRecButton.mas_right);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line.mas_bottom);
        make.right.bottom.left.mas_equalTo(0);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)rightMoreItemClick:(UIBarButtonItem *)sender event:(UIEvent *)event{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.tintColor = [UIColor colorWithWhite:0 alpha:0.8];
    configuration.textAlignment = NSTextAlignmentCenter;
    [FTPopOverMenu showFromEvent:event withMenuArray:@[@"首页",@"消息",@"我要反馈"] doneBlock:^(NSInteger selectedIndex) {
        switch (selectedIndex) {
            case 0:
                [self showTabWithIndex:0 needSwitch:NO showLogin:NO];
                break;
            case 1:{
                JSMessageListViewController *vc = [JSMessageListViewController new];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{
                DZFeedbackVC *vc = [DZFeedbackVC new];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    } dismissBlock:nil];
}

- (void)rightSearchItemClick:(UIBarButtonItem *)sender event:(UIEvent *)event{
    DZOrderSearchVC *vc = [DZOrderSearchVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)switchButtonAction:(UIButton *)btn{
    self.currentSelection = btn.tag;
    
    self.allTitleLabel.textColor = DefaultTextBlackColor;
    self.allCountLabel.textColor = DefaultTextBlackColor;
    self.unPaidTitleLabel.textColor = DefaultTextBlackColor;
    self.unPaidCountLabel.textColor = DefaultTextBlackColor;
    self.unSendTitleLabel.textColor = DefaultTextBlackColor;
    self.unSendCountLabel.textColor = DefaultTextBlackColor;
    self.unRecTitleLabel.textColor = DefaultTextBlackColor;
    self.unRecCountLabel.textColor = DefaultTextBlackColor;
    self.unCommentTitleLabel.textColor = DefaultTextBlackColor;
    self.unCommentCountLabel.textColor = DefaultTextBlackColor;
    switch (btn.tag) {
        case 0:{
            self.allTitleLabel.textColor = HEXCOLOR(0xff8903);
            self.allCountLabel.textColor = HEXCOLOR(0xff8903);
            break;
        }
        case 1:{
            self.unPaidTitleLabel.textColor = HEXCOLOR(0xff8903);
            self.unPaidCountLabel.textColor = HEXCOLOR(0xff8903);
            break;
        }
        case 2:{
            self.unSendTitleLabel.textColor = HEXCOLOR(0xff8903);
            self.unSendCountLabel.textColor = HEXCOLOR(0xff8903);
            break;
        }
        case 3:{
            self.unRecTitleLabel.textColor = HEXCOLOR(0xff8903);
            self.unRecCountLabel.textColor = HEXCOLOR(0xff8903);
            break;
        }
        case 4:{
            self.unCommentTitleLabel.textColor = HEXCOLOR(0xff8903);
            self.unCommentCountLabel.textColor = HEXCOLOR(0xff8903);
            break;
        }
        default:
            break;
    }
    [UIView animateWithDuration:.2 animations:^{
        self.slider.frame = CGRectMake(btn.tag * SCREEN_WIDTH / 5, self.slider.y, self.slider.width, self.slider.height);
    }];
    
    self.currentSelection = btn.tag;
    self.pageNum = 1;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - ---- DZCartPayVCDelegate ----
- (void)didPaySuccess{
    [self getNewData];
}
#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZOrderListItemModel *model = self.currentOrdersArray[indexPath.row];
    return 135.5 + model.goods_info.count * 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DZOrderListItemModel *model = self.currentOrdersArray[indexPath.row];
    DZOrderDetailVC *vc = [DZOrderDetailVC new];
    vc.order_sn = model.order_sn;
    vc.is_evaluation = model.is_evaluation;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentOrdersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZMyOrderCell" owner:self options:nil] lastObject];
    }
    
    DZOrderListItemModel *model = self.currentOrdersArray[indexPath.row];
    [cell fillData:model];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - ---- MrOrderCellDelegate ----
//(0:取消订单1:前往付款2:提醒发货3:确认收货4:查看物流5:再次购买6:前往评价7:删除订单)
- (void)didChangeOrder:(NSString *)order_sn withOperationCode:(NSInteger)code{
    switch (code) {
        case 0:{//取消订单
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定取消订单吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *params = @{@"order_sn":order_sn, @"order_status":@"0"};
                LNetWorkAPI *api;
                if ([DPMobileApplication sharedInstance].isSellerMode) {
                    api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/chanageOrderStatus" parameters:params];
                }else{
                    api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/chanageOrderStatus" parameters:params];
                }
                [SVProgressHUD show];
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    [SVProgressHUD dismiss];
                    LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                    if (model.isSuccess) {
                        [SVProgressHUD showSuccessWithStatus:model.info];
                        [self.tableView.mj_header beginRefreshing];
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
        case 1:{
            NSLog(@"====前往付款=== order_sn: %@", order_sn);
            for (DZOrderListItemModel *model in self.currentOrdersArray) {
                if ([model.order_sn isEqualToString:order_sn]) {
                    DZCartPayVC *vc = [DZCartPayVC new];
                    vc.goodsCount = model.total_buy_number;
                    vc.goodsPrice = model.total_amount;
                    vc.expressPrice = model.express_amount;
                    vc.totalPrice = model.real_pay_amount;
                    vc.orderSN = order_sn;
                    vc.delegate = self;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
            }
            break;
        }
        case 2:{//提醒发货
            NSDictionary *params = @{@"order_sn":order_sn, @"order_status":@"101"};
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/UserCenterApi/chanageOrderStatus" parameters:params];
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
            break;
        }
        case 3:{//确认收货
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您确认已收到货吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *params = @{@"order_sn":order_sn, @"order_status":@"4"};
                LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/chanageOrderStatus" parameters:params];
                [SVProgressHUD show];
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    [SVProgressHUD dismiss];
                    LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                    if (model.isSuccess) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:USERORDERINFOUPDATEDNOTIFICATION object:nil];
                        [SVProgressHUD showSuccessWithStatus:model.info];
                        [self.tableView.mj_header beginRefreshing];
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
        case 4:{
            NSLog(@"====查看物流=== order_sn: %@", order_sn);
            DZExpressDetailVC *vc = [DZExpressDetailVC new];
            vc.order_sn = order_sn;
            for (DZOrderListItemModel *model in self.currentOrdersArray) {
                if ([model.order_sn isEqualToString:order_sn]) {
                    vc.imgUrl = ((DZGoodInfoModel *)model.goods_info[0]).goods_img;
                    break;
                }
            }
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6:{
            NSLog(@"====前往评价=== order_sn: %@", order_sn);
            DZOrderCommentVC *vc = [DZOrderCommentVC new];
            vc.order_sn = order_sn;
            for (DZOrderListItemModel *model in self.currentOrdersArray) {
                if ([model.order_sn isEqualToString:order_sn]) {
                    vc.shopId = model.shop_id;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
            }
            break;
        }
        case 7:{//删除订单
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定删除订单吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *params = @{@"order_sn":order_sn, @"order_status":@"100"};
                LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/chanageOrderStatus" parameters:params];
                [SVProgressHUD show];
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    [SVProgressHUD dismiss];
                    LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                    if (model.isSuccess) {
                        [SVProgressHUD showSuccessWithStatus:model.info];
                        [self.tableView.mj_header beginRefreshing];
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
        case 8:{//催促买家
            NSDictionary *params = @{@"order_sn":order_sn};
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/reminderPayOrder" parameters:params];
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
            break;
        }
        case 9:{//前往发货
            DZDeliveryVC *vc = [DZDeliveryVC new];
            vc.order_sn = order_sn;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 10:{//修改价格
            DZModifyOrderVC *vc = [DZModifyOrderVC new];
            vc.order_sn = order_sn;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 11:{
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - ---- 私有方法 ----
- (void)getNewData{
    NSString *order_status;
    NSString *is_comment;
    switch (self.currentSelection) {
        case 0:
            break;
        case 1:
            order_status = @"1";
            break;
        case 2:
            order_status = @"2";
            break;
        case 3:
            order_status = @"3";
            break;
        case 4:
            is_comment = @"0";
            break;
        default:
            break;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"p":@(1)}];
    if (is_comment) {
        [params setObject:is_comment forKey:@"is_comment"];
        [params setObject:@"4" forKey:@"order_status"];
    }
    if (order_status) {
        [params setObject:order_status forKey:@"order_status"];
    }
    if ([DPMobileApplication sharedInstance].isSellerMode) {
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getOrderList" parameters:params];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [self.tableView.mj_header endRefreshing];
            self.model = [DZGetOrderListModel objectWithKeyValues:request.responseJSONObject];
            if (self.model.isSuccess) {
                self.allCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_0"] stringValue]];
                self.unPaidCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_1"] stringValue]];
                self.unSendCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_2"] stringValue]];
                self.unRecCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_3"] stringValue]];
                self.unCommentCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_4"] stringValue]];
                
                self.currentOrdersArray = [NSMutableArray arrayWithArray:self.model.data.order_list];
                [self.tableView reloadData];
                self.pageNum = 1;
            }else{
                [SVProgressHUD showErrorWithStatus:self.model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }else{
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getOrderList" parameters:params];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [self.tableView.mj_header endRefreshing];
            self.model = [DZGetOrderListModel objectWithKeyValues:request.responseJSONObject];
            if (self.model.isSuccess) {
                self.allCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_0"] stringValue]];
                self.unPaidCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_1"] stringValue]];
                self.unSendCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_2"] stringValue]];
                self.unRecCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_3"] stringValue]];
                self.unCommentCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_4"] stringValue]];
                
                self.currentOrdersArray = [NSMutableArray arrayWithArray:self.model.data.order_list];
                [self.tableView reloadData];
                self.pageNum = 1;
            }else{
                [SVProgressHUD showErrorWithStatus:self.model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
}

- (void)getMoreData{
    NSString *order_status;
    NSString *is_comment;
    switch (self.currentSelection) {
        case 0:
            break;
        case 1:
            order_status = @"1";
            break;
        case 2:
            order_status = @"2";
            break;
        case 3:
            order_status = @"3";
            break;
        case 4:
            is_comment = @"0";
            break;
        default:
            break;
    }
    self.pageNum++;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"p":@(self.pageNum)}];
    if (is_comment) {
        [params setObject:is_comment forKey:@"is_comment"];
        [params setObject:@"4" forKey:@"order_status"];
    }
    if (order_status) {
        [params setObject:order_status forKey:@"order_status"];
    }
    
    [self.currentOrdersArray removeAllObjects];
    
    if ([DPMobileApplication sharedInstance].isSellerMode) {
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getOrderList" parameters:params];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [self.tableView.mj_footer endRefreshing];
            self.model = [DZGetOrderListModel objectWithKeyValues:request.responseJSONObject];
            if (self.model.isSuccess) {
                self.allCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_0"] stringValue]];
                self.unPaidCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_1"] stringValue]];
                self.unSendCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_2"] stringValue]];
                self.unRecCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_3"] stringValue]];
                self.unCommentCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_4"] stringValue]];
                
                [self.currentOrdersArray addObjectsFromArray:self.model.data.order_list];
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:self.model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }else{
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getOrderList" parameters:params];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [self.tableView.mj_footer endRefreshing];
            self.model = [DZGetOrderListModel objectWithKeyValues:request.responseJSONObject];
            if (self.model.isSuccess) {
                self.allCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_0"] stringValue]];
                self.unPaidCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_1"] stringValue]];
                self.unSendCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_2"] stringValue]];
                self.unRecCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_3"] stringValue]];
                self.unCommentCountLabel.text = [NSString stringWithFormat:@"(%@)", [self.model.data.order_count[@"status_4"] stringValue]];
                
                [self.currentOrdersArray addObjectsFromArray:self.model.data.order_list];
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:self.model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
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

- (UILabel *)allTitleLabel{
    if (!_allTitleLabel) {
        _allTitleLabel = [UILabel new];
        _allTitleLabel.textColor = HEXCOLOR(0xff8903);
        _allTitleLabel.font = [UIFont systemFontOfSize:13];
        _allTitleLabel.textAlignment = NSTextAlignmentCenter;
        _allTitleLabel.text = @"全部";
    }
    return _allTitleLabel;
}

- (UILabel *)unPaidTitleLabel{
    if (!_unPaidTitleLabel) {
        _unPaidTitleLabel = [UILabel new];
        _unPaidTitleLabel.textColor = DefaultTextBlackColor;
        _unPaidTitleLabel.font = [UIFont systemFontOfSize:13];
        _unPaidTitleLabel.textAlignment = NSTextAlignmentCenter;
        _unPaidTitleLabel.text = @"待付款";
    }
    return _unPaidTitleLabel;
}

- (UILabel *)unSendTitleLabel{
    if (!_unSendTitleLabel) {
        _unSendTitleLabel = [UILabel new];
        _unSendTitleLabel.textColor = DefaultTextBlackColor;
        _unSendTitleLabel.font = [UIFont systemFontOfSize:13];
        _unSendTitleLabel.textAlignment = NSTextAlignmentCenter;
        _unSendTitleLabel.text = @"待发货";
    }
    return _unSendTitleLabel;
}

- (UILabel *)unRecTitleLabel{
    if (!_unRecTitleLabel) {
        _unRecTitleLabel = [UILabel new];
        _unRecTitleLabel.textColor = DefaultTextBlackColor;
        _unRecTitleLabel.font = [UIFont systemFontOfSize:13];
        _unRecTitleLabel.textAlignment = NSTextAlignmentCenter;
        _unRecTitleLabel.text = @"待收货";
    }
    return _unRecTitleLabel;
}

- (UILabel *)unCommentTitleLabel{
    if (!_unCommentTitleLabel) {
        _unCommentTitleLabel = [UILabel new];
        _unCommentTitleLabel.textColor = DefaultTextBlackColor;
        _unCommentTitleLabel.font = [UIFont systemFontOfSize:13];
        _unCommentTitleLabel.textAlignment = NSTextAlignmentCenter;
        _unCommentTitleLabel.text = @"待评价";
    }
    return _unCommentTitleLabel;
}

- (UILabel *)allCountLabel{
    if (!_allCountLabel) {
        _allCountLabel = [UILabel new];
        _allCountLabel.textColor = HEXCOLOR(0xff8903);
        _allCountLabel.font = [UIFont systemFontOfSize:13];
        _allCountLabel.textAlignment = NSTextAlignmentCenter;
        _allCountLabel.text = @"(0)";
    }
    return _allCountLabel;
}

- (UILabel *)unPaidCountLabel{
    if (!_unPaidCountLabel) {
        _unPaidCountLabel = [UILabel new];
        _unPaidCountLabel.textColor = DefaultTextBlackColor;
        _unPaidCountLabel.font = [UIFont systemFontOfSize:13];
        _unPaidCountLabel.textAlignment = NSTextAlignmentCenter;
        _unPaidCountLabel.text = @"(0)";
    }
    return _unPaidCountLabel;
}

- (UILabel *)unSendCountLabel{
    if (!_unSendCountLabel) {
        _unSendCountLabel = [UILabel new];
        _unSendCountLabel.textColor = DefaultTextBlackColor;
        _unSendCountLabel.font = [UIFont systemFontOfSize:13];
        _unSendCountLabel.textAlignment = NSTextAlignmentCenter;
        _unSendCountLabel.text = @"(0)";
    }
    return _unSendCountLabel;
}

- (UILabel *)unRecCountLabel{
    if (!_unRecCountLabel) {
        _unRecCountLabel = [UILabel new];
        _unRecCountLabel.textColor = DefaultTextBlackColor;
        _unRecCountLabel.font = [UIFont systemFontOfSize:13];
        _unRecCountLabel.textAlignment = NSTextAlignmentCenter;
        _unRecCountLabel.text = @"(0)";
    }
    return _unRecCountLabel;
}

- (UILabel *)unCommentCountLabel{
    if (!_unCommentCountLabel) {
        _unCommentCountLabel = [UILabel new];
        _unCommentCountLabel.textColor = DefaultTextBlackColor;
        _unCommentCountLabel.font = [UIFont systemFontOfSize:13];
        _unCommentCountLabel.textAlignment = NSTextAlignmentCenter;
        _unCommentCountLabel.text = @"(0)";
    }
    return _unCommentCountLabel;
}

- (UIButton *)allButton{
    if (!_allButton) {
        _allButton = [UIButton new];
        _allButton.tag = 0;
        [_allButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (UIButton *)unPaidButton{
    if (!_unPaidButton) {
        _unPaidButton = [UIButton new];
        _unPaidButton.tag = 1;
        [_unPaidButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unPaidButton;
}
- (UIButton *)unSendButton{
    if (!_unSendButton) {
        _unSendButton = [UIButton new];
        _unSendButton.tag = 2;
        [_unSendButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unSendButton;
}
- (UIButton *)unRecButton{
    if (!_unRecButton) {
        _unRecButton = [UIButton new];
        _unRecButton.tag = 3;
        [_unRecButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unRecButton;
}
- (UIButton *)unCommentButton{
    if (!_unCommentButton) {
        _unCommentButton = [UIButton new];
        _unCommentButton.tag = 4;
        [_unCommentButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unCommentButton;
}

- (UIView *)slider{
    if (!_slider) {
        _slider = [[UIView alloc] initWithFrame:CGRectMake(self.currentSelection * SCREEN_WIDTH / 5, 42, SCREEN_WIDTH / 5, 1)];
        _slider.backgroundColor = HEXCOLOR(0xff8903);
    }
    return _slider;
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
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getNewData];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self getMoreData];
        }];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

- (NSMutableArray *)currentOrdersArray{
    if (!_currentOrdersArray) {
        _currentOrdersArray = [NSMutableArray array];
    }
    return _currentOrdersArray;
}

- (UIBarButtonItem *)rightMoreItem{
    if (!_rightMoreItem) {
        _rightMoreItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"order_ico_more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightMoreItemClick:event:)];
    }
    return _rightMoreItem;
}

- (UIBarButtonItem *)rightSearchItem{
    if (!_rightSearchItem) {
        _rightSearchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"order_ico_search"] style:UIBarButtonItemStylePlain target:self action:@selector(rightSearchItemClick:event:)];
    }
    return _rightSearchItem;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
