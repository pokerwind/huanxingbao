//
//  DZGoodsDetailNavView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodsDetailNavView.h"

@implementation DZGoodsDetailNavView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(0, 0.5);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
