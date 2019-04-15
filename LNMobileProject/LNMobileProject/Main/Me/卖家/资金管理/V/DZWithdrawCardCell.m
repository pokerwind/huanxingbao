//
//  DZWithdrawCardCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZWithdrawCardCell.h"

@interface DZWithdrawCardCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation DZWithdrawCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZUserBankCardModel *)model{
    self.nameLabel.text = model.bank_name;
    self.numberLabel.text = model.bank_num;
    
    if (model.isSelected) {
        self.selectImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_s"];
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_n"];
    }
}

@end
