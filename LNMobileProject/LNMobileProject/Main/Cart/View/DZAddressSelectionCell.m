//
//  DZAddressSelectionCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZAddressSelectionCell.h"

@interface DZAddressSelectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;

@end

@implementation DZAddressSelectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZMyAddressItemModel *)model{
    self.nameLabel.text = model.consignee;
    self.mobileLabel.text = model.mobile;
    self.addressLabel.text = model.address;
    
    if (model.isSelected) {
        self.selectionImageView.image = [UIImage imageNamed:@"my_address_icon_s"];
    }else{
        self.selectionImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
    }
}

@end
