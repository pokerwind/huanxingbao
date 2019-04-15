//
//  DZProblemHistoryNormalCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/27.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZProblemHistoryNormalCell.h"

@interface DZProblemHistoryNormalCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation DZProblemHistoryNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZTalkRecordModel *)model{
    if ([model.admin_type isEqualToString:@"0"]) {
        self.containerView.backgroundColor = HEXCOLOR(0xff7722);
    }else{
        self.containerView.backgroundColor = HEXCOLOR(0x27A2F8);
    }
    
    self.nameLabel.text = model.title;
    self.dateLabel.text = model.add_time;
    self.descLabel.text = model.content;
}

@end
