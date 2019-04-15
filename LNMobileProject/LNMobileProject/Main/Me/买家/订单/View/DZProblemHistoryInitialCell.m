//
//  DZProblemHistoryInitialCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/27.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZProblemHistoryInitialCell.h"
#import "UIColor+HDXColor.h"

@interface DZProblemHistoryInitialCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *containterView;

@end

@implementation DZProblemHistoryInitialCell

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
        self.containterView.backgroundColor = HEXCOLOR(0xff7722);
    }else{
        self.containterView.backgroundColor = HEXCOLOR(0x27A2F8);
    }
    
    self.nameLabel.text = model.title;
    self.dateLabel.text = model.add_time;
    self.reasonLabel.text = model.reason;
    self.moneyLabel.text = model.refundAmont;
    self.messageLabel.text = model.desc;
}

@end
