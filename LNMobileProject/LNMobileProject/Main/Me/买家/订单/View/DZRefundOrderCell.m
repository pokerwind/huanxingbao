//
//  DZRefundOrderCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZRefundOrderCell.h"
#import "DZRefundOrderInnerCell.h"

@interface DZRefundOrderCell ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *shopLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *stateButtonRight;
@property (weak, nonatomic) IBOutlet UIButton *stateButtonMiddle;
@property (weak, nonatomic) IBOutlet UIButton *stateButtonLeft;
@property (nonatomic) NSInteger rightButtonCode;//最右边按钮对应的操作码 买家：0:撤销申请 1:去退货 2:删除订单 卖家：3:确认退款 4:拒绝退款 5:催促买家 6:卖家删除订单 7:同意退货 8:拒绝退货 9:卖家确认收货
@property (nonatomic) NSInteger middleButtonCode;
@property (nonatomic) NSInteger leftButtonCode;
@property (strong, nonatomic) NSString *order_sn;

@property (nonatomic, strong) NSArray *goodsArray;

@end

@implementation DZRefundOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZRefundItemModel *)model isSeller:(BOOL)isSeller{
    self.goodsArray = model.goods_list;
    self.order_sn = model.order_sn;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    self.shopLabel.text = model.shop_name;
    if ([model.express_amount floatValue] == 0) {
        self.countLabel.text = [NSString stringWithFormat:@"共%ld件(免运费)", model.goods_list.count];
    }else{
        self.countLabel.text = [NSString stringWithFormat:@"共%ld件(含运费%@元)", model.goods_list.count, model.express_amount];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.real_pay_amount];
    if (isSeller) {
        if ([model.shop_state isEqualToString:@"1"]) {//待审核
            self.stateButtonLeft.hidden = YES;
            self.stateButtonMiddle.hidden = NO;
            self.stateButtonRight.hidden = NO;
            if ([model.refund_type isEqualToString:@"1"]) {
                self.payStateLabel.text = @"申请退款";
                [self.stateButtonRight setTitle:@"  同意退款  " forState:UIControlStateNormal];
                [self.stateButtonMiddle setTitle:@"  拒绝退款  " forState:UIControlStateNormal];
                self.rightButtonCode = 3;
                self.middleButtonCode = 4;
            }else{
                self.payStateLabel.text = @"申请退货退款";
                [self.stateButtonRight setTitle:@"  同意退货退款  " forState:UIControlStateNormal];
                self.rightButtonCode = 7;
                [self.stateButtonMiddle setTitle:@"  拒绝退货退款  " forState:UIControlStateNormal];
                self.middleButtonCode = 8;
            }
        }else if ([model.shop_state isEqualToString:@"2"]){//等待买家发货
            self.stateButtonLeft.hidden = YES;
            self.stateButtonMiddle.hidden = YES;
            self.stateButtonRight.hidden = NO;
            self.payStateLabel.text = @"等待买家发货";
            [self.stateButtonRight setTitle:@"  提醒退货  " forState:UIControlStateNormal];
            self.rightButtonCode = 5;
        }else if ([model.shop_state isEqualToString:@"3"]){//拒绝退款退货
            self.stateButtonLeft.hidden = YES;
            self.stateButtonMiddle.hidden = YES;
            self.stateButtonRight.hidden = NO;
            if ([model.refund_type isEqualToString:@"1"]) {
                self.payStateLabel.text = @"拒绝退款";
            }else{
                self.payStateLabel.text = @"拒绝退货退款";
            }
            [self.stateButtonRight setTitle:@"  删除订单  " forState:UIControlStateNormal];
            self.rightButtonCode = 6;
        }else if ([model.shop_state isEqualToString:@"4"]){//已完成
            self.stateButtonLeft.hidden = YES;
            self.stateButtonMiddle.hidden = YES;
            self.stateButtonRight.hidden = NO;
            if ([model.refund_type isEqualToString:@"1"]) {
                self.payStateLabel.text = @"仅退款 退款成功";
            }else{
                self.payStateLabel.text = @"退货退款 退款成功";
            }
            [self.stateButtonRight setTitle:@"  删除订单  " forState:UIControlStateNormal];
            self.rightButtonCode = 6;
        }else if ([model.shop_state isEqualToString:@"10"]){//等待卖家收货
            self.stateButtonLeft.hidden = YES;
            self.stateButtonMiddle.hidden = YES;
            self.stateButtonRight.hidden = NO;
            self.payStateLabel.text = @"等待卖家收货";
            [self.stateButtonRight setTitle:@"  确认收货并退款  " forState:UIControlStateNormal];
            self.rightButtonCode = 9;
        }
    }else{
        self.stateButtonLeft.hidden = YES;
        self.stateButtonMiddle.hidden = YES;
        self.stateButtonRight.hidden = NO;
        if ([model.shop_state isEqualToString:@"1"]) {
            self.payStateLabel.text = @"等待卖家确认";
            [self.stateButtonRight setTitle:@"  撤销申请  " forState:UIControlStateNormal];
            self.rightButtonCode = 0;
        }else if ([model.shop_state isEqualToString:@"2"]){
            self.payStateLabel.text = @"请退货";
            [self.stateButtonRight setTitle:@"  去退货  " forState:UIControlStateNormal];
            self.rightButtonCode = 1;
        }else if ([model.shop_state isEqualToString:@"10"]){
            self.payStateLabel.text = @"等待卖家收货";
            self.stateButtonRight.hidden = YES;
        }else if ([model.shop_state isEqualToString:@"3"]){
            if ([model.refund_type isEqualToString:@"1"]) {
                self.payStateLabel.text = @"卖家拒绝退款";
            }else{
                self.payStateLabel.text = @"卖家拒绝退货退款";
            }
            [self.stateButtonRight setTitle:@"  删除订单  " forState:UIControlStateNormal];
            self.rightButtonCode = 2;
        }else if ([model.shop_state isEqualToString:@"4"]){
            if ([model.refund_type isEqualToString:@"1"]) {
                self.payStateLabel.text = @"仅退款 退款成功";
            }else{
                self.payStateLabel.text = @"退货退款 退款成功";
            }
            [self.stateButtonRight setTitle:@"  删除订单  " forState:UIControlStateNormal];
            self.rightButtonCode = 2;
        }
    }
}

- (IBAction)stateButtonRightAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeOrder:withOperationCode:)]) {
        [self.delegate didChangeOrder:self.order_sn withOperationCode:self.rightButtonCode];
    }
}

- (IBAction)stateButtonMiddleAction:(id)sender {
    [self.delegate didChangeOrder:self.order_sn withOperationCode:self.middleButtonCode];
}

- (IBAction)stateButtonLeftAction:(id)sender {
    [self.delegate didChangeOrder:self.order_sn withOperationCode:self.leftButtonCode];
}

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCellOrderSn:orderGoodId:)]) {
        DZRefundListGoodModel *model = self.goodsArray[indexPath.row];
        [self.delegate didSelectCellOrderSn:model.order_sn orderGoodId:model.order_goods_id];
    }
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentiferId = @"DZRefundOrderInnerCell";
    DZRefundOrderInnerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZRefundOrderInnerCell" owner:nil options:nil] lastObject];
    }
    DZRefundListGoodModel *model = self.goodsArray[indexPath.row];
    [cell fillData:model];
    
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
