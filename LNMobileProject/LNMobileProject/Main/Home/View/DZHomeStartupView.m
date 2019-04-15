//
//  DZHomeStartupView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZHomeStartupView.h"

@implementation DZHomeStartupView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.jumpButton.layer.masksToBounds = YES;
    self.jumpButton.layer.cornerRadius = 15;
    //self.jumpButton.backgroundColor = HEXCOLORA(0x99999999);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
