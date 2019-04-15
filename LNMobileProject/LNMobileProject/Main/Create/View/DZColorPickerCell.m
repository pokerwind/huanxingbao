//
//  DZColorPickerCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/29.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZColorPickerCell.h"

@interface DZColorPickerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end

@implementation DZColorPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)fillData:(DZColorModel *)model{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.color_img]]];
    self.nameLabel.text = model.item;
    if (model.isSelected) {
        self.selectedImageView.hidden = NO;
    }else{
        self.selectedImageView.hidden = YES;
    }
}

@end
