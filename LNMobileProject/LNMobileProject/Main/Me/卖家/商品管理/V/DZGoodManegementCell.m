//
//  DZGoodManegementCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/24.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodManegementCell.h"

@interface DZGoodManegementCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation DZGoodManegementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZGoodModel *)model{
    if (model.goods_img.length) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.goods_img]]];
    }
    self.nameLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.shop_price];
    self.countLabel.text = [NSString stringWithFormat:@"销量:%@",model.sale_num];
}

@end
