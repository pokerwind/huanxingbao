//
//  DZOrderDetailInnerCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZOrderDetailInnerCell.h"

@interface DZOrderDetailInnerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundStateLabel;

@end

@implementation DZOrderDetailInnerCell

- (void)fillData:(DZGoodInfoModel *)model{
    if (model.goods_img.length) {
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.goods_img]]];
    }
    self.goodsNameLabel.text = model.goods_name;
    self.countLabel.text = [NSString stringWithFormat:@"%@件", model.total_buy_number];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.price];
    
    if ([DPMobileApplication sharedInstance].isSellerMode) {
        if ([model.refund_state isEqualToString:@"1"]) {
            self.refundStateLabel.text = @"退款中";
        }else if ([model.refund_state isEqualToString:@"2"]){
            self.refundStateLabel.text = @"退货退款中";
        }else{
            self.refundStateLabel.text = @"";
        }
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (DZOrderDetailSpecModel *models in model.spec_list) {
        [array addObject:[NSString stringWithFormat:@"%@*%@", models.spec, models.buy_number]];
    }
    self.formatLabel.text = [array componentsJoinedByString:@","];
    
    [self.formatLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(formatLabelTap)]];
}

- (void)formatLabelTap{
    [SVProgressHUD showSuccessWithStatus:@"尺寸数量复制成功！"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.formatLabel.text;
}

- (void)setCanRefund:(BOOL)canRefund{
    _canRefund = canRefund;
    if (canRefund) {
        self.refundButton.hidden = NO;
    }else{
        self.refundButton.hidden = YES;
    }
}

@end
