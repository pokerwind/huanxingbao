//
//  DZShopSelectionCell.m
//  LNMobileProject
//
//  Created by 童浩 on 2019/2/25.
//  Copyright © 2019 Liuniu. All rights reserved.
//

#import "DZShopSelectionCell.h"

@implementation DZShopSelectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.layer.masksToBounds = YES;
    self.nameLabel.layer.cornerRadius = 10;
    self.nameLabel.layer.borderWidth = 1;
    self.nameLabel.layer.borderColor = [UIColor colorWithRed:255 / 256.0 green:184 / 256.0 blue:125 / 256.0 alpha:1].CGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
