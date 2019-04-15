//
//  DZCartModifyVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCartModifyVC.h"

#import "DZCartModifyHeader.h"
#import "DZCartSpecCell.h"

#import "DZEditCartGoodsSpecModel.h"

@interface DZCartModifyVC ()<UITableViewDelegate, UITableViewDataSource, DZCartSpecCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) DZCartModifyHeader *header;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) DZEditCartGoodsSpecModel *model;

@end

@implementation DZCartModifyVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改规格和数量";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.header;
    
    [self getData];
}

- (void)viewDidLayoutSubviews{
    self.header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)submitButtonAction {
    NSMutableArray *specKeyArray = [NSMutableArray array];
    NSMutableArray *numberArray = [NSMutableArray array];
    NSInteger totalBuyCount = 0;
    
    for (DZCartSpecModel *model in self.dataArray) {
        [specKeyArray addObject:model.spec_key];
        [numberArray addObject:model.has_number];
        
        totalBuyCount += [model.has_number integerValue];
    }
    
    if (totalBuyCount < [self.model.data.goods_info.retail_amount integerValue]) {
        [SVProgressHUD showInfoWithStatus:@"小于最低拿货数量"];
        return;
    }
    
    NSString *specString = [specKeyArray componentsJoinedByString:@","];
    NSString *numberString = [numberArray componentsJoinedByString:@","];
    
    NSDictionary *params = @{@"goods_id":self.goods_id, @"goods_spec_key":specString, @"buy_number":numberString};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/CartApi/saveCartSpecNumber" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CARTUPDATENOTIFICATION object:nil];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cartDidModified)]) {
                [self.delegate cartDidModified];
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"返回进货车" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ac2];
            [alert addAction:ac1];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZCartSpecCellDelegate ----
- (void)refreshCartData{
    [self.tableView reloadData];
    
    NSInteger totalCount = 0;
    float totalPrice = 0.0;
    for (DZCartSpecModel *model in self.dataArray) {
        totalCount += [model.has_number integerValue];
    }
    if (totalCount >= [self.model.data.goods_info.basic_amount integerValue]) {
        totalPrice = totalCount * [self.model.data.goods_info.pack_price floatValue];
    }else{
        totalPrice = totalCount * [self.model.data.goods_info.shop_price floatValue];
    }
    self.countLabel.text = [NSString stringWithFormat:@"共%ld件", totalCount];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", totalPrice];
}
#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"DZCartSpecCell";
    DZCartSpecCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [DZCartSpecCell viewFormNib];
    }
    
    DZCartSpecModel *model = self.dataArray[indexPath.row];
    [cell fillData:model];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"goods_id":self.goods_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/CartApi/editCartGoodsSpec" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        self.model = [DZEditCartGoodsSpecModel objectWithKeyValues:request.responseJSONObject];
        if (self.model.isSuccess) {
            self.header.nameLabel.text = self.model.data.goods_info.goods_name;
            if (self.model.data.goods_info.goods_img.length) {
                [self.header.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, self.model.data.goods_info.goods_img]]];
            }
            self.header.expressCountLabel.text = [NSString stringWithFormat:@"%@件以上", self.model.data.goods_info.basic_amount];
            self.header.expressPriceLabel.text = [NSString stringWithFormat:@"¥%@", self.model.data.goods_info.pack_price];
            self.header.handPriceLabel.text = [NSString stringWithFormat:@"¥%@", self.model.data.goods_info.shop_price];
            self.header.handCountLabel.text = [NSString stringWithFormat:@"%@-%ld件", self.model.data.goods_info.retail_amount, [self.model.data.goods_info.basic_amount integerValue] - 1];
            
            self.dataArray = self.model.data.goods_spec;
            
            [self refreshCartData];
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
- (DZCartModifyHeader *)header{
    if (!_header) {
        _header = [DZCartModifyHeader viewFormNib];
    }
    return _header;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
