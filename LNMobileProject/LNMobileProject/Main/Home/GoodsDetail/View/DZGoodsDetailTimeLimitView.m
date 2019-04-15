//
//  DZGoodsDetailTimeLimitView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/20.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodsDetailTimeLimitView.h"

@implementation DZGoodsDetailTimeLimitView

- (void)awakeFromNib {
    self.limitLabel.layer.masksToBounds = YES;
    self.limitLabel.layer.cornerRadius = 10;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
