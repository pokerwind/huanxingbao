//
//  DZModifyOrderVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZModifyOrderVC.h"

#import "DZModifyOrderFooter.h"
#import "DZModifyOrderCell.h"

#import "DZChanageOrderPriceModel.h"

@interface DZModifyOrderVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DZModifyOrderCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DZModifyOrderFooter *footer;

@property (strong, nonatomic) NSArray *goodsArray;
@property (strong, nonatomic) DZChanageOrderPriceModel *model;

@property (nonatomic) BOOL isFreeForExpress;//是否包邮

@property (strong, nonatomic) NSMutableArray *cellArray;

@end

@implementation DZModifyOrderVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改订单";
    
    self.tableView.tableFooterView = self.footer;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.footer.height = 234;
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)submitButtonClick {
    NSString *express_amount = self.isFreeForExpress?@"0":self.footer.expressTextField.text;
    NSMutableArray *order_goods_id = [NSMutableArray array];
    NSMutableArray *discount_type = [NSMutableArray array];
    NSMutableArray *discount_money = [NSMutableArray array];
    for (int i = 0; i < self.goodsArray.count; i++) {
        DZGoodInfoModel *model = self.goodsArray[i];
        [order_goods_id addObject:model.order_goods_id];
        DZModifyOrderCell *cell = self.cellArray[i];
        [discount_type addObject:[NSString stringWithFormat:@"%ld", cell.typeSc.selectedSegmentIndex]];
        [discount_money addObject:[NSString stringWithFormat:@"%.2f", [cell.changeMoneyTextField.text floatValue]]];
    }
    
    NSDictionary *params = @{@"order_sn":self.order_sn, @"express_amount":express_amount, @"order_goods_id":order_goods_id, @"discount_type":discount_type, @"discount_money":discount_money};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/saveChanageOrderPrice" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMYORDERNOTIFICATION object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)expressButtonClick{
    self.isFreeForExpress = !self.isFreeForExpress;
    if (self.isFreeForExpress) {
        [self.footer.expressButton setImage:[UIImage imageNamed:@"cart_icon_checkbox_s"] forState:UIControlStateNormal];
        self.footer.expressLabel.text = @"¥0.00";
        self.footer.expressTextField.text = @"0.00";
    }else{
        [self.footer.expressButton setImage:[UIImage imageNamed:@"cart_icon_checkbox_n"] forState:UIControlStateNormal];
        self.footer.expressLabel.text = [NSString stringWithFormat:@"¥%@", self.model.data.express_amount];
        self.footer.expressTextField.text = @"0.00";
    }
    [self priceDidUpdate];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZModifyOrderCellDelegate ----
- (void)priceDidUpdate{
    CGFloat price = 0.0;
    for (DZModifyOrderCell *cell in self.cellArray) {
        price += [[cell.moneyLabel.text substringFromIndex:1] floatValue];
    }
    price += [self.footer.expressTextField.text floatValue];
    
    self.footer.currentPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", price];
}

#pragma mark - ---- UITextFieldDelegate ----
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.footer.expressTextField) {
        if (textField.text.floatValue == 0) {
            self.isFreeForExpress = YES;
            [self.footer.expressButton setImage:[UIImage imageNamed:@"cart_icon_checkbox_s"] forState:UIControlStateNormal];
            self.footer.expressLabel.text = @"¥0.00";
            self.footer.expressTextField.text = @"0.00";
        }else{
            self.isFreeForExpress = NO;
            [self.footer.expressButton setImage:[UIImage imageNamed:@"cart_icon_checkbox_n"] forState:UIControlStateNormal];
            self.footer.expressLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.footer.expressTextField.text floatValue]];
        }
    }
    
    [self priceDidUpdate];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZModifyOrderCell *cell;
    if (indexPath.row < self.cellArray.count) {
        cell = self.cellArray[indexPath.row];
    }else{
        cell = [DZModifyOrderCell viewFormNib];
        [self.cellArray addObject:cell];
    }

    DZGoodInfoModel *model = self.goodsArray[indexPath.row];
    [cell fillData:model];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    [SVProgressHUD show];
    NSDictionary *params = @{@"order_sn":self.order_sn};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/chanageOrderPrice" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        self.model = [DZChanageOrderPriceModel objectWithKeyValues:request.responseJSONObject];
        if (self.model.isSuccess) {
            self.footer.numberLabel.text = self.model.data.order_sn;
            self.footer.dateLabel.text = self.model.data.add_time;
            self.footer.nameLabel.text = self.model.data.consignee;
            self.footer.addressLabel.text = self.model.data.address;
            self.footer.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.model.data.before_pay_amount];
            self.footer.currentPriceLabel.text = [NSString stringWithFormat:@"¥%@", self.model.data.real_pay_amount];

            if ([self.model.data.express_amount floatValue] == 0) {
                self.isFreeForExpress = YES;
                [self.footer.expressButton setImage:[UIImage imageNamed:@"cart_icon_checkbox_s"] forState:UIControlStateNormal];
                self.footer.expressLabel.text = @"¥0.00";
            }else{
                self.isFreeForExpress = NO;
                [self.footer.expressButton setImage:[UIImage imageNamed:@"cart_icon_checkbox_n"] forState:UIControlStateNormal];
                self.footer.expressLabel.text = [NSString stringWithFormat:@"¥%@", self.model.data.express_amount];
                self.footer.expressTextField.text = [NSString stringWithFormat:@"%@", self.model.data.express_amount];
            }
            
            self.goodsArray = self.model.data.order_goods;
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:self.model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (DZModifyOrderFooter *)footer{
    if (!_footer) {
        _footer = [DZModifyOrderFooter viewFormNib];
        [_footer.expressButton addTarget:self action:@selector(expressButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _footer.expressTextField.delegate = self;
    }
    return _footer;
}

- (NSArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [NSArray array];
    }
    return _goodsArray;
}

- (NSMutableArray *)cellArray{
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}

@end
