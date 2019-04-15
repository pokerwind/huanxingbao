//
//  DZSubmitOrderVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSubmitOrderVC.h"
#import "DZAddressSelectionVC.h"
#import "DZCartModifyVC.h"
#import "DZCartPayVC.h"

#import "DZSubmitOrderHeader.h"
#import "DZSubmitOrderFooter.h"
#import "DZSubmitOrderCell.h"

#import "DZCartConfirmModel.h"

@interface DZSubmitOrderVC ()<UITableViewDelegate, UITableViewDataSource, DZSubmitOrderCellDelegate, DZCartModifyVCDelegate, DZAddressSelectionVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (strong, nonatomic) DZSubmitOrderHeader *header;
@property (strong, nonatomic) DZSubmitOrderFooter *footer;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) NSString *addressId;
@property (strong, nonatomic) NSMutableArray *cellArray;

@property (strong, nonatomic) DZCartConfirmModel *model;

@end

@implementation DZSubmitOrderVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写订单";
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getData];
}

- (void)viewDidLayoutSubviews{
    self.header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 85);
    self.footer.frame = CGRectMake(self.footer.x, self.footer.y, SCREEN_WIDTH, 132);
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)submitButtonAction {
    if (!self.model) {
        [SVProgressHUD showErrorWithStatus:@"获取商品信息失败"];
        return;
    }
    
    
    NSMutableArray *msgArray = [NSMutableArray array];
    for (DZSubmitOrderCell *cell in self.cellArray) {
        if (cell.messageTextField.text.length) {
            [msgArray addObject:cell.messageTextField.text];
        }else{
            [msgArray addObject:@""];
        }
    }
    NSString *remark = [msgArray componentsJoinedByString:@"@$"];
//    NSMutableArray *shopArray = [NSMutableArray array];
//    for (DZCartConfirmShopModel *model in self.dataArray) {
//        [shopArray addObject:model.shop_id];
//    }
//    NSString *shopId = [shopArray componentsJoinedByString:@","];
    NSString *is_from_cart;
    if (self.source == 1) {
        //立即购买
        is_from_cart = @"0";
    }else{
        is_from_cart = @"1";
    }
    if (self.iswodeshiyong.length != 0) {
        is_from_cart = @"0";
        self.source = 1;
    }
    if (!self.addressId) {
        [SVProgressHUD showErrorWithStatus:@"请先设置收货地址"];
        return;
    }
    NSString *shopId = [self.shopIds componentsJoinedByString:@","];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.addressId forKey:@"address_id"];
    
    if (self.source == 1) {
        //立即购买
//        is_from_cart = @"0";
        [params setObject:self.goodId forKey:@"goods_id"];
        [params setObject:self.from_shop_id forKey:@"from_shop_id"];
        [params setObject:self.buy_number forKey:@"buy_number"];
        [params setObject:self.act_id forKey:@"act_id"];
        [params setObject:self.goods_spec_key forKey:@"goods_spec_key"];
        

    }else{
//        is_from_cart = @"1";
        [params setObject:shopId forKey:@"shop_id"];
    }
    
    [params setObject:remark forKey:@"remark"];
    [params setObject:is_from_cart forKey:@"is_from_cart"];
    
//    NSDictionary *params = @{@"address_id":self.addressId, @"shop_id":shopId, @"remark":remark};
    NSString *urls = @"/Api/OrderApi/addToOrder";
    if (self.iswodeshiyong.length != 0) {
//        if (self.iswodeshiyong.length != 0) {
        [params setObject:self.order_sn forKey:@"old_order_sn"];
        [params setObject:self.goods_price forKey:@"goods_price"];
//        }
        urls = @"/Api/IndexUserApi/addToFreeTestOrder";
    }else {
        NSString *sglid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sglid"];
        if (sglid != nil && sglid.length != 0) {
            [params setObject:sglid forKey:@"sglid"];
        }
    }
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:urls parameters:params method:LCRequestMethodPost];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {            
            [SVProgressHUD showSuccessWithStatus:model.info];
            DZCartPayVC *vc = [DZCartPayVC new];
            vc.goodsCount = self.model.data.order_buy_counts;
            vc.goodsPrice = self.model.data.order_price;
            vc.expressPrice = self.model.data.order_express_price;
            vc.totalPrice = self.model.data.final_price;
            vc.orderSN = request.responseJSONObject[@"data"];
            vc.needRemoveVC = YES;//移除订单提交页
            [[NSNotificationCenter defaultCenter] postNotificationName:CARTUPDATENOTIFICATION object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:USERORDERINFOUPDATEDNOTIFICATION object:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)addressButtonAction{
    DZAddressSelectionVC *vc = [DZAddressSelectionVC new];
    vc.delegate = self;
    vc.currentAddressId = self.addressId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZAddressSelectionVCDelegate ----
- (void)didSelectAddress:(DZMyAddressItemModel *)model{
    self.header.nameLabel.text = model.consignee;
    self.header.mobileLabel.text = model.mobile;
    self.header.addressLabel.text = model.address;
    
    self.addressId = model.address_id;
    
    [self getData];
}

#pragma mark - ---- DZCartModifyVCDelegate ----
- (void)cartDidModified{
    [self getData];
}

#pragma mark - ---- DZSubmitOrderCellDelegate ----
- (void)modifyFrameWithGroup:(NSInteger)group goodIndex:(NSInteger)goodIndex{
    DZCartConfirmShopModel *model = self.dataArray[group];
    DZCartConfirmGoodModel *goodModel = model.goods[goodIndex];
    
    DZCartModifyVC *vc = [DZCartModifyVC new];
    vc.goods_id = goodModel.goods_id;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZCartConfirmShopModel *model = self.dataArray[indexPath.row];
    return 145 - 44 + 118 * model.goods_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZSubmitOrderCell *cell;
    if (self.cellArray.count > indexPath.row) {
        cell = self.cellArray[indexPath.row];
    }else{
        cell = [DZSubmitOrderCell viewFormNib];
        [self.cellArray insertObject:cell atIndex:indexPath.row];
    }
    
    DZCartConfirmShopModel *model = self.dataArray[indexPath.row];
    [cell fillData:model];
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSString *is_from_cart;
    if (self.source == 1) {
        //立即购买
        
        is_from_cart = @"0";
    }else{
        is_from_cart = @"1";
    }
    if (self.iswodeshiyong.length != 0) {
        is_from_cart = @"0";
        self.source = 1;
    }
//    NSString *ids = [self.goodIds componentsJoinedByString:@","];
    NSString *shopIds = [self.shopIds componentsJoinedByString:@","];
    NSString *cartIds = [self.cart_ids componentsJoinedByString:@","];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.addressId forKey:@"address_id"];
    [params setObject:shopIds forKey:@"shop_id"];
    [params setObject:self.goodId forKey:@"goods_id"];
    [params setObject:is_from_cart forKey:@"is_from_cart"];
    [params setObject:self.from_shop_id forKey:@"from_shop_id"];
    [params setObject:self.buy_number forKey:@"buy_number"];
    [params setObject:self.goods_spec_key forKey:@"goods_spec_key"];
    [params setObject:cartIds forKey:@"cart_id"];
    [params setObject:self.act_id forKey:@"act_id"];
    [params setObject:self.act_type forKey:@"act_type"];
    if (self.iswodeshiyong.length != 0) {
        [params setObject:self.order_sn forKey:@"order_sn"];
        [params setObject:self.goods_price forKey:@"goods_price"];
    }
    NSString *urls = @"/Api/CartApi/cartConfirm";
    if (self.iswodeshiyong.length != 0) {
        urls = @"/Api/IndexUserApi/confirmFreeTestOrder";
    }
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:urls parameters:params method:LCRequestMethodPost];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        self.model = [DZCartConfirmModel objectWithKeyValues:request.responseJSONObject];
        if (self.model.isSuccess) {
            if (self.model.data.address_id.length) {
                self.header.nameLabel.text = self.model.data.consignee;
                self.header.mobileLabel.text = self.model.data.mobile;
                self.header.addressLabel.text = self.model.data.address;
                self.addressId = self.model.data.address_id;
            }
            
            self.footer.countLabel.text = [NSString stringWithFormat:@"共%@件", self.model.data.order_buy_counts];
            self.footer.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.model.data.order_price];
            self.footer.expressPriceLabel.text = [NSString stringWithFormat:@"¥%@", self.model.data.order_express_price];
            self.moneyLabel.text = [NSString stringWithFormat:@"¥%@", self.model.data.final_price];
//            NSArray *listsa = self.model.data.list;
//            NSArray *goods_lists = listsa.firstObject[@"goods_list"];
//            if (goods_lists.count == 1) {
//                NSArray *arrays1 = self.model.data.list;
////                DZCartConfirmShopModel *model =
//                NSMutableArray *arrays2 = [NSMutableArray array];
//                for (NSDictionary *dic in arrays1.firstObject[@"goods_list"]) {
//                    DZCartConfirmShopModel *model12 = [DZCartConfirmShopModel objectWithKeyValues:dic];
//                    model12.shop_express = arrays1.firstObject[@"shop_express_price"];
//                    if (model12.goods.count == 0) {
//                        DZCartConfirmGoodModel *goodModel = [DZCartConfirmGoodModel objectWithKeyValues:dic];
//                        NSMutableArray *goodsa = [NSMutableArray array];
//                        [goodsa addObject:goodModel];
//                        if (goodModel.spec.count == 0) {
//                            DZCartConfirmSpecModel *modelspec = [DZCartConfirmSpecModel objectWithKeyValues:dic];
//                            NSMutableArray *specarray = [NSMutableArray array];
//                            [specarray addObject:modelspec];
//                            if (modelspec.size.count == 0) {
//                                DZCartConfirmSizeModel *modelsize = [DZCartConfirmSizeModel objectWithKeyValues:dic];
//                                NSMutableArray *sizearray = [NSMutableArray array];
//                                [sizearray addObject:modelsize];
//                                modelspec.size = sizearray;
//                            }
//                            goodModel.spec = specarray;
//                        }
//                        model12.goods = goodsa;
//                    }
//                    [arrays2 addObject:model12];
//                }
//                self.dataArray = arrays2;
//            }else {
                self.dataArray = self.model.data.list;
//            }
            [self.tableView reloadData];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showErrorWithStatus:self.model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (DZSubmitOrderHeader *)header{
    if (!_header) {
        _header = [DZSubmitOrderHeader viewFormNib];
        [_header.addressButton addTarget:self action:@selector(addressButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _header;
}

- (DZSubmitOrderFooter *)footer{
    if (!_footer) {
        _footer = [DZSubmitOrderFooter viewFormNib];
    }
    return _footer;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)cellArray{
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}

@end
