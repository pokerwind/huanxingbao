//
//  DZOrderDetailCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZOrderDetailCell.h"
#import "DZOrderDetailInnerCell.h"

@interface DZOrderDetailCell ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *shopLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) NSArray *goodsArray;

@end

@implementation DZOrderDetailCell

- (void)fillData:(DZGetOrderDetailModel *)model{
    self.shopLabel.text = model.data.shop_name;
    if ([model.data.express_amount floatValue] == 0) {
        self.countLabel.text = [NSString stringWithFormat:@"共%@件(免运费)", model.data.total_buy_number];
    }else{
        self.countLabel.text = [NSString stringWithFormat:@"共%@件(含运费%@元)", model.data.total_buy_number, model.data.express_amount];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.data.real_pay_amount];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.goodsArray = model.data.order_goods;
    self.messageButton.hidden = YES;
    [self.tableView reloadData];
}

- (void)refundButtonAction:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refundWithIndex:)]) {
        [self.delegate refundWithIndex:btn.tag];
    }
}

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZGoodInfoModel *model = self.goodsArray[indexPath.row];
    NSMutableArray *array = [NSMutableArray array];
    for (DZOrderDetailSpecModel *models in model.spec_list) {
        [array addObject:[NSString stringWithFormat:@"%@*%@", models.spec, models.buy_number]];
    }
    NSString *str = [array componentsJoinedByString:@","];
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, MAXFLOAT);
    CGFloat textH = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    return 98 + textH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DZGoodInfoModel *model = self.goodsArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickGood:)]) {
        [self.delegate didClickGood:model.goods_id];
    }
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentiferId = @"DZOrderDetailInnerCell";
    DZOrderDetailInnerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZOrderDetailInnerCell" owner:nil options:nil] lastObject];
    }
    
    DZGoodInfoModel *model = self.goodsArray[indexPath.row];
    [cell fillData:model];
    if ([DPMobileApplication sharedInstance].isSellerMode || ![model.allow_return boolValue]) {
        cell.refundButton.hidden = YES;
    }else{
        cell.canRefund = self.canRefund;
        if (cell.canRefund) {
            cell.refundButton.tag = indexPath.row;
            [cell.refundButton addTarget:self action:@selector(refundButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([model.order_return_status integerValue] == 0) {
                cell.refundButton.enabled = YES;
                [cell.refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
                cell.refundButton.backgroundColor = HEXCOLOR(0xff7722);
            }else if ([model.order_return_status integerValue] == 3){
                cell.refundButton.enabled = YES;
                [cell.refundButton setTitle:@"再次申请" forState:UIControlStateNormal];
                cell.refundButton.backgroundColor = HEXCOLOR(0xff7722);
            }else{
                cell.refundButton.enabled = NO;
                [cell.refundButton setTitle:model.order_return_msg forState:UIControlStateNormal];
                cell.refundButton.backgroundColor = HEXCOLOR(0x666666);
            }
        }
    }
    
    return cell;
}

#pragma mark - ---- getter ----
- (NSArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [NSArray array];
    }
    return _goodsArray;
}

@end
