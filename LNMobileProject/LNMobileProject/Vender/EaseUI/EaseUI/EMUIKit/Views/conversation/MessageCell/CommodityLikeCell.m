//
//  CommodityLikeCell.m
//  ShopMobile
//
//  Created by net apa on 2017/5/18.
//  Copyright © 2017年 liuniukeji. All rights reserved.
//

#import "CommodityLikeCell.h"

@implementation CommodityLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sendBtn.layer.cornerRadius = 15;
    self.sendBtn.layer.borderColor = HEXCOLOR(0xFF632A).CGColor;
    self.sendBtn.layer.borderWidth = 1;
    self.sendBtn.clipsToBounds = YES;
    self.commodityImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
