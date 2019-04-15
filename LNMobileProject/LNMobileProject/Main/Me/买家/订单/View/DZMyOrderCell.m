//
//  DZMyOrderCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/10.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMyOrderCell.h"
#import "DZMyOrderInnerCell.h"

@interface DZMyOrderCell ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *shopLabel;
@property (weak, nonatomic) IBOutlet UIView *dateLine;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *stateButtonRight;
@property (weak, nonatomic) IBOutlet UIButton *stateButtonMiddle;
@property (weak, nonatomic) IBOutlet UIButton *stateButtonLeft;
@property (nonatomic) NSInteger rightButtonCode;//最右边按钮对应的操作码(0:取消订单1:前往付款2:提醒发货3:确认收货4:查看物流5:再次购买6:前往评价7:删除订单8:催促买家9:前往发货10:修改价格11:)
@property (nonatomic) NSInteger middleButtonCode;
@property (nonatomic) NSInteger leftButtonCode;
@property (strong, nonatomic) NSString *order_sn;

@property (nonatomic, strong) NSArray *goodsArray;

@end

@implementation DZMyOrderCell

- (void)fillData:(DZOrderListItemModel *)model{
    self.goodsArray = model.goods_info;
    self.order_sn = model.order_sn;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = NO;
    [self.tableView reloadData];
    
    self.shopLabel.text = model.shop_name;
    if ([DPMobileApplication sharedInstance].isSellerMode) {
        self.dateLabel.text = model.add_time;
    }else{
        self.dateLabel.hidden = YES;
        self.dateLine.hidden = YES;
    }
    if ([model.express_amount floatValue] == 0) {
        self.countLabel.text = [NSString stringWithFormat:@"共%@件(免运费)", model.total_buy_number];
    }else{
        self.countLabel.text = [NSString stringWithFormat:@"共%@件(含运费%@元)", model.total_buy_number, model.express_amount];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.real_pay_amount];
    
    switch ([model.order_status integerValue]) {
        case 0:{
            self.payStateLabel.text = @"交易取消";
            self.stateButtonLeft.hidden = YES;
            self.stateButtonMiddle.hidden = YES;
            self.stateButtonRight.hidden = YES;
            [self.stateButtonRight setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            self.stateButtonRight.layer.borderColor = HEXCOLOR(0xc7c7c7).CGColor;
            break;
        }
        case 1:{
            self.payStateLabel.text = @"等待付款";
            self.stateButtonMiddle.hidden = NO;
            self.stateButtonRight.hidden = NO;
            [self.stateButtonRight setTitleColor:HEXCOLOR(0xff7722) forState:UIControlStateNormal];
            self.stateButtonRight.layer.borderColor = HEXCOLOR(0xff7722).CGColor;
            if ([DPMobileApplication sharedInstance].isSellerMode) {
                self.stateButtonLeft.hidden = NO;
                self.stateButtonRight.hidden = YES;
                self.layoutC.constant = -40;
//                [self.stateButtonRight setTitle:@"  修改价格  " forState:UIControlStateNormal];
                self.rightButtonCode = 10;
                [self.stateButtonMiddle setTitle:@"  催促买家  " forState:UIControlStateNormal];
                self.middleButtonCode = 8;
                [self.stateButtonLeft setTitle:@"  取消订单  " forState:UIControlStateNormal];
                self.leftButtonCode = 0;
            }else{
                self.stateButtonLeft.hidden = YES;
                [self.stateButtonRight setTitle:@"  前往付款  " forState:UIControlStateNormal];
                self.rightButtonCode = 1;
                [self.stateButtonMiddle setTitle:@"  取消订单  " forState:UIControlStateNormal];
                self.middleButtonCode = 0;
            }
            break;
        }
        case 2:{
            self.payStateLabel.text = @"等待发货";
            self.stateButtonLeft.hidden = YES;
            self.stateButtonMiddle.hidden = YES;
            self.stateButtonRight.hidden = NO;
            [self.stateButtonRight setTitleColor:HEXCOLOR(0xff7722) forState:UIControlStateNormal];
            self.stateButtonRight.layer.borderColor = HEXCOLOR(0xff7722).CGColor;
            if ([DPMobileApplication sharedInstance].isSellerMode) {
                [self.stateButtonRight setTitle:@"  前往发货  " forState:UIControlStateNormal];
                self.rightButtonCode = 9;
            }else{
                [self.stateButtonRight setTitle:@"  提醒发货  " forState:UIControlStateNormal];
                self.rightButtonCode = 2;
            }
            break;
        }
        case 3:{
            self.payStateLabel.text = @"等待收货";
            self.stateButtonLeft.hidden = YES;
            self.stateButtonRight.hidden = NO;
            [self.stateButtonRight setTitleColor:HEXCOLOR(0xff7722) forState:UIControlStateNormal];
            self.stateButtonRight.layer.borderColor = HEXCOLOR(0xff7722).CGColor;
            if ([DPMobileApplication sharedInstance].isSellerMode) {
                self.stateButtonMiddle.hidden = YES;
                [self.stateButtonRight setTitle:@"  查看物流  " forState:UIControlStateNormal];
                self.rightButtonCode = 4;
            }else{
                self.stateButtonMiddle.hidden = NO;
                [self.stateButtonRight setTitle:@"  确认收货  " forState:UIControlStateNormal];
                [self.stateButtonMiddle setTitle:@"  查看物流  " forState:UIControlStateNormal];
                self.rightButtonCode = 3;
                self.middleButtonCode = 4;
            }
            break;
        }
        case 4:{
            self.payStateLabel.text = @"交易完成";
            if ([DPMobileApplication sharedInstance].isSellerMode) {
                self.stateButtonLeft.hidden = YES;
                self.stateButtonMiddle.hidden = YES;
                self.stateButtonRight.hidden = NO;
                [self.stateButtonRight setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
                self.stateButtonRight.layer.borderColor = HEXCOLOR(0xc7c7c7).CGColor;
//                [self.stateButtonRight setTitle:@"  删除订单  " forState:UIControlStateNormal];
//                self.rightButtonCode = 7;
                [self.stateButtonRight setTitle:@"  查看物流  " forState:UIControlStateNormal];
                self.rightButtonCode = 4;
            }else{
                if (model.is_evaluation) {
                    self.stateButtonLeft.hidden = YES;
                    self.stateButtonMiddle.hidden = YES;
                    self.stateButtonRight.hidden = NO;
                    [self.stateButtonRight setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
                    self.stateButtonRight.layer.borderColor = HEXCOLOR(0xc7c7c7).CGColor;
//                    [self.stateButtonRight setTitle:@"  删除订单  " forState:UIControlStateNormal];
//                    self.rightButtonCode = 7;
                    [self.stateButtonRight setTitle:@"  查看物流  " forState:UIControlStateNormal];
                    self.rightButtonCode = 4;
                }else{
                    self.stateButtonLeft.hidden = YES;
                    self.stateButtonMiddle.hidden = NO;
                    self.stateButtonRight.hidden = NO;
                    [self.stateButtonRight setTitleColor:HEXCOLOR(0xff7722) forState:UIControlStateNormal];
                    self.stateButtonRight.layer.borderColor = HEXCOLOR(0xff7722).CGColor;
                    [self.stateButtonRight setTitle:@"  前往评价  " forState:UIControlStateNormal];
//                    [self.stateButtonMiddle setTitle:@"  删除订单  " forState:UIControlStateNormal];
                    [self.stateButtonMiddle setTitle:@"  查看物流  " forState:UIControlStateNormal];
                    self.rightButtonCode = 6;
//                    self.middleButtonCode = 7;
                    self.middleButtonCode = 4;
                }
            }
            break;
        }
        default:
            break;
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

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentiferId = @"DZMyOrderInnerCell";
    DZMyOrderInnerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZMyOrderInnerCell" owner:nil options:nil] lastObject];
    }
    
    DZGoodInfoModel *model = self.goodsArray[indexPath.row];
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
