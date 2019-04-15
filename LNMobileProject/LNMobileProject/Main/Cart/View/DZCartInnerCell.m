//
//  DZCartInnerCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/31.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCartInnerCell.h"

@interface DZCartInnerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *formatLabel;
@property (weak, nonatomic) IBOutlet UILabel *invalidLabel;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;

@property (strong, nonatomic) JSShopCartGoods *model;

@end

@implementation DZCartInnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(JSShopCartGoods *)model{
    self.model = model;
    if (model.goods_img.length) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.goods_img]]];
    }
    self.nameLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.price];
    self.countLabel.text = [NSString stringWithFormat:@"x%@", model.buy_number];
    self.specLabel.text = model.spec_name;
    
//    NSMutableString *resultStr = [NSMutableString string];
//    for (DZCartListGoodSpecModel *models in model.spec) {
//        [resultStr appendString:models.color];
//        for (DZCartListGoodSpecSizeModel *modelsp in models.size) {
//            [resultStr appendString:[NSString stringWithFormat:@"%@x%@ ", modelsp.size_name, modelsp.buy_number]];
//        }
//    }
//    self.formatLabel.text = resultStr;
    if (model.isSelected) {
        self.selectedImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_s"];
    }else{
        self.selectedImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_n"];
    }
    
    if ([model.is_valid boolValue]) {
        self.invalidLabel.hidden = YES;
    }else{
        self.invalidLabel.hidden = NO;
    }
}

- (IBAction)selectButtonAction {
    self.model.isSelected = !self.model.isSelected;
}


@end
