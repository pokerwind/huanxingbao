//
//  DZAddAlertView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZAddAlertView.h"

@implementation DZAddAlertView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    
    self.continueButton.layer.masksToBounds = YES;
    self.continueButton.layer.cornerRadius = 2;
    self.continueButton.layer.borderWidth = 0.5;
    self.continueButton.layer.borderColor = HEXCOLOR(0xebebeb).CGColor;
    
    self.checkoutButton.layer.masksToBounds = YES;
    self.checkoutButton.layer.cornerRadius = 2;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
