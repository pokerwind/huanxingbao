//
//  DZMyBalanceHelpCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMyBalanceHelpCell.h"

@interface DZMyBalanceHelpCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation DZMyBalanceHelpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZArticleListModel *)model{
    self.nameLabel.text = model.title;
    self.detailLabel.text = model.introduce;
}

@end
