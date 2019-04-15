//
//  DZExpressCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/4.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZExpressCell.h"

@interface DZExpressCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;

@end

@implementation DZExpressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZExpressListModel *)model{
    self.nameLabel.text = model.name;
    if (model.isSelected) {
        self.selectionImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_s"];
    }else{
        self.selectionImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_n"];
    }
}

@end
