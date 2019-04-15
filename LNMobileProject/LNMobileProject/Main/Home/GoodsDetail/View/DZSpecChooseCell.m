//
//  DZSpecChooseCell.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSpecChooseCell.h"

@interface DZSpecChooseCell ()

@end

@implementation DZSpecChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.numView.layer.cornerRadius = 4;
    self.numView.layer.masksToBounds = YES;
    self.numView.layer.borderColor = BgColor.CGColor;
    self.numView.layer.borderWidth = 0.5;
    
    [self.numberTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)minusAction:(id)sender {
    [self.changeSubject sendNext:RACTuplePack(@"minus",@(self.row))];
}
- (IBAction)plusAction:(id)sender {
    [self.changeSubject sendNext:RACTuplePack(@"plus",@(self.row))];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.model.buyCount = [textField.text integerValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCartData)]) {
        [self.delegate refreshCartData];
    }
}

@end
