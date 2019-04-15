//
//  DZSubmitOrderInnerCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSubmitOrderInnerCell.h"

@interface DZSubmitOrderInnerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *formatLabel;

@property (strong, nonatomic) DZCartConfirmGoodModel *model;

@end

@implementation DZSubmitOrderInnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)fillData:(DZCartConfirmGoodModel *)model{
    self.model = model;
    if (model.goods_img.length) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.goods_img]]];
    }
    self.nameLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.price];
//    [resultStr appendString:model.spec_name];
    
    NSInteger count = model.buy_number.intValue;
//    for (DZCartConfirmSpecModel *models in model.spec) {
//        for (DZCartConfirmSizeModel *modelsp in models.size) {
//            count += [modelsp.buy_number integerValue];
//        }
//    }
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", count];
    NSMutableString *resultStr = [NSMutableString string];
    [resultStr appendString:model.spec_name];

//    for (DZCartConfirmSpecModel *models in model.spec) {
//        if ([models.color isKindOfClass:[NSNull class]] || models.color.length == 0) {
//        }else {
//            [resultStr appendString:models.color];
//        }
////        for (DZCartConfirmSizeModel *modelsp in models.size) {
////            [resultStr appendString:[NSString stringWithFormat:@"%@x%@ ", modelsp.size_name, modelsp.buy_number]];
////        }
//    }
    self.modifyButton.hidden = YES;
    self.formatLabel.text = resultStr;
}

@end
