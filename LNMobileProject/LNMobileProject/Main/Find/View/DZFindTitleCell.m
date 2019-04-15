//
//  DZFindTitleCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZFindTitleCell.h"

@interface DZFindTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

@end

@implementation DZFindTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZCategoryListModel *)model{
    self.labelName.text = model.cat_name_mobile;
    
    if (model.isSelected) {
        self.viewLine.hidden = NO;
        self.labelName.textColor = HEXCOLOR(0xff8903);
        self.contentView.backgroundColor = [UIColor whiteColor];
    }else{
        self.viewLine.hidden = YES;
        self.labelName.textColor = HEXCOLOR(0x333333);
        self.contentView.backgroundColor = HEXCOLOR(0xf7f7f7);
    }
}

@end
