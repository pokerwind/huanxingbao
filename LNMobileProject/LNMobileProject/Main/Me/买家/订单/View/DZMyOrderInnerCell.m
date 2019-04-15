//
//  DZMyOrderInnerCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMyOrderInnerCell.h"

@implementation DZMyOrderInnerCell

- (void)fillData:(DZGoodInfoModel *)model{
    if (model.goods_img.length) {
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.goods_img]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    }
    self.goodsNameLabel.text = model.goods_name;
    self.countLabel.text = [NSString stringWithFormat:@"数量x%@件", model.total_buy_number];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.price];
    if ([model.refund_state isEqualToString:@"1"]) {
        self.statusLabel.text = @"退款中";
    }else if ([model.refund_state isEqualToString:@"2"]){
        self.statusLabel.text = @"退货退款中";
    }else if ([model.refund_state isEqualToString:@"4"]){
        self.statusLabel.text = @"已退款";
    }else{
        self.statusLabel.text = @"";
    }
}

@end
