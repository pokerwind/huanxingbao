//
//  AFreeTrialCell.m
//  LNMobileProject
//
//  Created by 童浩 on 2019/3/2.
//  Copyright © 2019 Liuniu. All rights reserved.
//

#import "AFreeTrialCell.h"

@implementation AFreeTrialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.buttonOne setBorderCornerRadius:5 andBorderWidth:1 andBorderColor:RGBACOLOR(255, 99, 0, 1)];
    [self.butttonTwo setBorderCornerRadius:5 andBorderWidth:1 andBorderColor:RGBACOLOR(226, 226,226, 1)];
    self.shangpintuImageView.clipsToBounds = YES;
    self.shangpintuImageView.contentMode = UIViewContentModeScaleAspectFill;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
