//
//  DZSizePickerCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/29.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSizePickerCell.h"

@interface DZSizePickerCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end

@implementation DZSizePickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = HEXCOLOR(0xe6e6e6).CGColor;
}

- (void)fillData:(DZColorModel *)model{
    self.nameLabel.text = model.item;
    if (model.isSelected) {
        self.selectedImageView.hidden = NO;
    }else{
        self.selectedImageView.hidden = YES;
    }
}

@end
