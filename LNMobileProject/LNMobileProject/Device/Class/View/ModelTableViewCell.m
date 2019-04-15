//
//  ModelTableViewCell.m
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/10.
//  Copyright © 2019 rx. All rights reserved.
//

#import "ModelTableViewCell.h"

@implementation ModelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setButtonImageAndTitleWithSpace:(CGFloat)spacing WithButton:(UIButton *)btn{
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text boundingRectWithSize:btn.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil].size;
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}

- (IBAction)openSwitch:(id)sender {
    UISwitch *switches = (UISwitch*)sender;
//    [switches setOn:!switches.on];
    if (self.switchBlock) {
        self.switchBlock(sender);
    }
}

@end
