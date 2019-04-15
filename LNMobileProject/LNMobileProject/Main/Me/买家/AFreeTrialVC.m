//
//  AFreeTrialVC.m
//  LNMobileProject
//
//  Created by 童浩 on 2019/2/28.
//  Copyright © 2019 Liuniu. All rights reserved.
//

#import "AFreeTrialVC.h"
#import "AFreeTrialCell.h"
#import "AFreeTrialModel.h"
#import "DZLexzViewController.h"
#import "DZSubmitOrderVC.h"

// 判断是否是iPhone X
#define iPhoneX (([UIScreen mainScreen].bounds.size.height > 811.5) ? YES : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define k_NavigationHeight (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define k_TabbarHeight (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)
//比例适配
#define k_OnePx (k_mainSize.width / 750.0)
#define k_oneHeight (k_mainSize.height / 1334.0)
#define k_BuuttonAction UIControlEventTouchUpInside
//设置颜色
#define k_THUIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define k_THUIColorAlpha(hexValue,alphaF) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaF]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//最大view的宽度 相对于父视图
#define k_THViewWitch(hexValue) (hexValue.frame.origin.x + hexValue.frame.size.width)
//最大view的高度 相对于父视图
#define k_THViewHeight(hexValue) (hexValue.frame.origin.y + hexValue.frame.size.height)
//屏幕size
#define k_mainSize [UIScreen mainScreen].bounds.size
#import "DZCartPayVC.h"
#import "DZRefundDeliveryVC.h"
#import "DZApplyRefundVC.h"

@interface AFreeTrialVC ()<UITableViewDelegate,UITableViewDataSource,DZCartPayVCDelegate,DZRefundDeliveryVCDelegate,DZApplyRefundVCDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArrays;
@end

@implementation AFreeTrialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的试用";
    [self.tableView registerNib:[UINib nibWithNibName:@"AFreeTrialCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AFreeTrialCellID"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    self.view.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self upDataAction];
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArrays.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
#pragma mark - ---- DZOrderDetailCellDelegate ----
- (void)refundWithIndex:(NSInteger)index{
    AFreeTrialModel *model = self.dataArrays[index];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定要申请退货退款吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        DZApplyRefundVC *vc = [DZApplyRefundVC new];
        vc.goods_id = model.goods_id;
        vc.order_goods_id = model.order_goods_id;
        vc.order_sn = model.order_sn;
        vc.delegate = self;
        vc.canReturnGood = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
- (void)didSubmitRefund {
    [self.tableView.mj_header beginRefreshing];
}
- (void)buttonOneAction:(UIButton *)button {
    AFreeTrialModel *model = self.dataArrays[button.th_index.section];
    NSInteger order_status = model.order_return_status.intValue; //退货状态
    if (order_status == 0) {
        NSInteger order_status1 = model.order_status.intValue;
        switch (order_status1) {
            case 0:
            {

            }
                break;
            case 1:
            {
                DZCartPayVC *vc = [DZCartPayVC new];
                vc.goodsCount = @"1";
                vc.goodsPrice = model.final_price;
                vc.expressPrice = model.final_price;
                vc.totalPrice = model.final_price;
                vc.orderSN = model.order_sn;
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                //提醒发货
                NSDictionary *params = @{@"order_sn":model.order_sn, @"order_status":@"101"};
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
            }
                break;
            case 3:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您确认已收到货吗？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    NSDictionary *params = @{@"order_sn":model.order_sn, @"order_status":@"4"};
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
//                [cell.buttonOne setTitle:@"确认收货" forState:UIControlStateNormal];
            }
                break;
            case 4:
            {
                if (model.is_show_cunliu.integerValue == 1) {
                    DZLexzViewController *lexz = [[DZLexzViewController alloc]init];
                    lexz.order_sn = model.order_sn;
                    lexz.source = 7;
                    [self.navigationController pushViewController:lexz animated:YES];
                }else {
                    [self refundWithIndex:button.th_index.section];
                }
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)buttonTwoAction:(UIButton *)button {
    AFreeTrialModel *model = self.dataArrays[button.th_index.section];
    NSInteger order_status = model.order_return_status.intValue; //退货状态
    if (order_status == 0) {
        NSInteger order_status1 = model.order_status.intValue;
        switch (order_status1) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定取消订单吗？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    NSDictionary *params = @{@"order_sn":model.order_sn, @"order_status":@"0"};
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
            }
                break;
            case 4:
            {
                [self refundWithIndex:button.th_index.section];
//                DZRefundDeliveryVC *dare = [[DZRefundDeliveryVC alloc]init];
//                dare.order_sn = model.order_sn;
//                dare.delegate = self;
//                [self.navigationController pushViewController:dare animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)didSendSuccess {
    [self.tableView.mj_header beginRefreshing];
}
- (void)didPaySuccess {
    [self.tableView.mj_header beginRefreshing];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AFreeTrialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AFreeTrialCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.buttonOne setBorderCornerRadius:5 andBorderWidth:1 andBorderColor:RGBACOLOR(255, 99, 0, 1)];
    [cell.buttonOne setTitleColor:RGBACOLOR(255, 99, 0, 1) forState:UIControlStateNormal];
    [cell.butttonTwo setBorderCornerRadius:5 andBorderWidth:1 andBorderColor:RGBACOLOR(226, 226,226, 1)];
    AFreeTrialModel *model = self.dataArrays[indexPath.section];
    cell.dingdanhaoLabel.text = [NSString stringWithFormat:@"订单号:%@",model.order_sn];
    cell.buttonOne.th_index = indexPath;
    cell.butttonTwo.th_index = indexPath;
    [cell.buttonOne addTarget:self action:@selector(buttonOneAction:) forControlEvents:k_BuuttonAction];
    [cell.butttonTwo addTarget:self action:@selector(buttonTwoAction:) forControlEvents:k_BuuttonAction];
    cell.butttonTwo.hidden = NO;
    cell.buttonOne.userInteractionEnabled = YES;
    cell.shangpinguigeLabel.text = model.goods_spec_value;
    NSString *urlString = FULL_URL(model.goods_img);
    [cell.shangpintuImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:GetImage(@"avatar_grey")];
    cell.shangpinmingchengLabel.text = model.goods_name;
    cell.shangpinJiaGeLabel.text = [NSString stringWithFormat:@"￥%.2lf",model.final_price.doubleValue];

    NSInteger order_status = model.order_return_status.intValue; //退货状态
    if (order_status == 0) {
        NSInteger order_status1 = model.order_status.intValue;
        switch (order_status1) {
            case 0:
                {
                    cell.dingdanzhuangtaiLabel.text = @"";
                }
                break;
            case 1:
            {
                cell.dingdanzhuangtaiLabel.text = @"待付款";
                [cell.buttonOne setTitle:@"立即支付" forState:UIControlStateNormal];
                [cell.butttonTwo setTitle:@"取消订单" forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                cell.butttonTwo.hidden = YES;
                cell.dingdanzhuangtaiLabel.text = @"待发货";
//                cell.buttonOne.userInteractionEnabled = NO;
                [cell.buttonOne setTitle:@"提醒发货" forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                cell.dingdanzhuangtaiLabel.text = @"待收货";
                cell.butttonTwo.hidden = YES;
//                cell.buttonOne.userInteractionEnabled = NO;
                [cell.buttonOne setTitle:@"确认收货" forState:UIControlStateNormal];
            }
                break;
            case 4:
            {
                if (model.is_show_cunliu.integerValue == 1) {
                    cell.dingdanzhuangtaiLabel.text = @"已完成";
                    [cell.buttonOne setTitle:@"存留" forState:UIControlStateNormal];
                    [cell.butttonTwo setTitle:@"退货" forState:UIControlStateNormal];
                }else {
                    [cell.buttonOne setBorderCornerRadius:5 andBorderWidth:1 andBorderColor:RGBACOLOR(226, 226,226, 1)];
                    [cell.buttonOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [cell.buttonOne setTitle:@"退货" forState:UIControlStateNormal];
                    cell.butttonTwo.hidden = YES;
//                    [cell.butttonTwo setTitle:@"" forState:UIControlStateNormal];
                }
            }
                break;
                
            default:
                break;
        }
    }else {
        cell.butttonTwo.hidden = YES;
        cell.buttonOne.userInteractionEnabled = NO;
        switch (order_status) {
            case 1:
                {
                    [cell.buttonOne setTitle:@"申请中" forState:UIControlStateNormal];
                    cell.dingdanzhuangtaiLabel.text = @"申请中";
                }
                break;
            case 2:
            {
                [cell.buttonOne setTitle:@"同意退货" forState:UIControlStateNormal];
                cell.dingdanzhuangtaiLabel.text = @"同意退货";
            }
                break;
            case 3:
            {
                [cell.buttonOne setTitle:@"申请驳回" forState:UIControlStateNormal];
                cell.dingdanzhuangtaiLabel.text = @"退货被驳回";
            }
                break;
            case 4:
            {
                [cell.buttonOne setTitle:@"退货完成" forState:UIControlStateNormal];
                cell.dingdanzhuangtaiLabel.text = @"退货完成";
            }
                break;
            default:
                break;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    return view;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}
- (NSMutableArray*)dataArrays {
    if (!_dataArrays) {
        _dataArrays = [NSMutableArray array];
    }
    return _dataArrays;
}
- (void)upDataAction {
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    [par setObject:[DPMobileApplication sharedInstance].loginUser.token forKey:@"token"];
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/UserCenterApi/myTestList" parameters:par];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSDictionary *dataDic = request.rawJSONObject;
        NSString *status1 = dataDic[@"status"];
        if (status1.intValue == 1) {
            [self.dataArrays removeAllObjects];
            for (NSDictionary *dic in dataDic[@"data"]) {
                AFreeTrialModel *model = [[AFreeTrialModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArrays addObject:model];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:dataDic[@"info"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
        [self.tableView.mj_header endRefreshing];
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
