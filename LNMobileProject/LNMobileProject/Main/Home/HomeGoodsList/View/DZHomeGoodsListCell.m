//
//  DZHomeGoodsListCell.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZHomeGoodsListCell.h"
#import "DZGoodsModel.h"
@interface DZHomeGoodsListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;

@end

@implementation DZHomeGoodsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderColor = BorderColor.CGColor;
    self.layer.borderWidth = 0.5;
    self.picImageView.layer.masksToBounds = YES;
}

- (void)fillPic:(NSString *)picUrl title:(NSString *)title pack_price:(NSString *)pack_price shop_price:(NSString *)shop_price{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, picUrl]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nameLabel.text = title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",shop_price];
    self.xiaoshouLabel.text = [NSString stringWithFormat:@"已卖出:%ld",pack_price.integerValue];
}

- (void)setEditingState:(NSInteger)state{
    
    if (state == 1) {
        self.selectionView.hidden = NO;
        self.selectionImageView.image = [UIImage imageNamed:@"group_checkbox_s"];
    }else if (state == -1){
        self.selectionView.hidden = NO;
        self.selectionImageView.image = [UIImage imageNamed:@"group_checkbox_n"];
    }else{
        self.selectionView.hidden = YES;
    }
}

- (void)configView:(DZGoodsModel *)model {
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.goods_img]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nameLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.shop_price];
}

@end
