//
//  DZOrderSearchVC.m（文件名称）
//  LNMobileProject（工程名称）
//
//  Created by  六牛科技 on 2017/10/30.
//
//  山东六牛网络科技有限公司 https://liuniukeji.com
//

#import "DZOrderSearchVC.h"
#import "DZOrderDetailVC.h"
#import "DZExpressDetailVC.h"
#import "DZOrderCommentVC.h"
#import "DZDeliveryVC.h"
#import "DZModifyOrderVC.h"
#import "DZCartPayVC.h"
#import "DZMessageVC.h"
#import "DZFeedbackVC.h"

#import "DZSearchNavView.h"
#import "DZMyOrderCell.h"

#import "DZGetOrderListModel.h"

@interface DZOrderSearchVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MrOrderCellDelegate>

@property (nonatomic, strong) DZSearchNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DZOrderSearchVC

static  NSString  *CellIdentiferId = @"DZMyOrderCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self initNavigationBar];
    self.navView.searchTextFiled.placeholder = @"买家名称/订单编号";
    self.navView.searchTextFiled.returnKeyType = UIReturnKeySearch;
    self.navView.searchTextFiled.delegate = self;
    [self.view addSubview:self.navView];
    [self.view addSubview:self.tableView];
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSubViewsFrame];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)initNavigationBar {
    self.navigationItem.titleView = self.navView;
}

#pragma mark - ---- 代理相关 ----
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!self.navView.searchTextFiled.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入关键词"];
        return NO;
    }
    
    [self.navView.searchTextFiled resignFirstResponder];
    NSDictionary *params = @{@"keyword":self.navView.searchTextFiled.text};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/searchOrder" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZGetOrderListModel *model = [DZGetOrderListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD dismiss];
            self.dataArray = model.data.order_list;
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
    
    return NO;
}

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZOrderListItemModel *model = self.dataArray[indexPath.row];
    return 135.5 + model.goods_info.count * 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DZOrderListItemModel *model = self.dataArray[indexPath.row];
    DZOrderDetailVC *vc = [DZOrderDetailVC new];
    vc.order_sn = model.order_sn;
    vc.is_evaluation = model.is_evaluation;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZMyOrderCell" owner:self options:nil] lastObject];
    }
    
    DZOrderListItemModel *model = self.dataArray[indexPath.row];
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
            for (DZOrderListItemModel *model in self.dataArray) {
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
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/chanageOrderStatus" parameters:params];
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
            for (DZOrderListItemModel *model in self.dataArray) {
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
            for (DZOrderListItemModel *model in self.dataArray) {
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

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{
    
}

- (void) setSubViewsLayout{
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(KNavigationBarH + 0.5);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.right.bottom.left.mas_equalTo(0);
    }];
}

#pragma mark - --- getters 和 setters ----
- (DZSearchNavView *)navView {
    if(!_navView) {
        _navView = [DZSearchNavView viewFormNib];
        @weakify(self);
        [[_navView.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _navView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
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
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

@end
