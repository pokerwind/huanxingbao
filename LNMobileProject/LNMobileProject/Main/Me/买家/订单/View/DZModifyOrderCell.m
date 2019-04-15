//
//  DZModifyOrderCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZModifyOrderCell.h"

@interface DZModifyOrderCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) DZGoodInfoModel *model;

@end

@implementation DZModifyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.changeMoneyTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZGoodInfoModel *)model{
    self.model = model;
    if (model.goods_img.length) {
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.goods_img]]];
    }
    self.nameLabel.text = model.goods_name;
    self.countLabel.text = [NSString stringWithFormat:@"数量%@件", model.total_buy_number];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
    self.moneyLabel.text= [NSString stringWithFormat:@"¥%@", model.after_money];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.typeSc.selectedSegmentIndex == 0) {
        self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.model.after_money floatValue] > [self.changeMoneyTextField.text floatValue]?[self.model.after_money floatValue] - [self.changeMoneyTextField.text floatValue]:0.00];
    }else{
        self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.model.after_money floatValue] + [self.changeMoneyTextField.text floatValue]];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(priceDidUpdate)]) {
        [self.delegate priceDidUpdate];
    }
}

- (IBAction)changeScClick:(UISegmentedControl *)sender {
    if (self.typeSc.selectedSegmentIndex == 0) {
        self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.model.after_money floatValue] > [self.changeMoneyTextField.text floatValue]?[self.model.after_money floatValue] - [self.changeMoneyTextField.text floatValue]:0.00];
    }else{
        self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.model.after_money floatValue] + [self.changeMoneyTextField.text floatValue]];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(priceDidUpdate)]) {
        [self.delegate priceDidUpdate];
    }
}


@end
