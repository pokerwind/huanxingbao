//
//  DZRefundOrderInnerCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZRefundOrderInnerCell.h"

@interface DZRefundOrderInnerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation DZRefundOrderInnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZRefundListGoodModel *)model{
    if (model.goods_img.length) {
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.goods_img]]];
    }
    self.goodsNameLabel.text = model.goods_name;
    self.countLabel.text = [NSString stringWithFormat:@"数量%@件", model.buy_number];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.price];
}

@end
