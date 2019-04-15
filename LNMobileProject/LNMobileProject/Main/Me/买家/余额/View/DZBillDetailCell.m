//
//  DZBillDetailCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/15.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZBillDetailCell.h"

@interface DZBillDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation DZBillDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconLabel.layer.cornerRadius = 15;
    self.iconLabel.layer.masksToBounds = YES;
}

- (void)fillData:(DZBalanceDetailModel *)model{
    self.nameLabel.text = model.type_str;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@%@", model.direct_str,model.amount];
    if ([model.direct_str isEqualToString:@"+"]) {
        self.iconLabel.text = @"收";
        self.iconLabel.backgroundColor = HEXCOLOR(0xff7722);
        self.biandongleixing.textColor = HEXCOLOR(0xff7722);
    }else{
        self.iconLabel.text = @"支";
        self.iconLabel.backgroundColor = HEXCOLOR(0x27a2f8);
        self.biandongleixing.textColor = HEXCOLOR(0x27a2f8);
    }
    self.biandongleixing.text = model.money_type_str;
    self.timerLabel.text = model.add_time;
}

@end
