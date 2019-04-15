//
//  DZGoodsDetailRemarkView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodsDetailRemarkView.h"

@implementation DZGoodsDetailRemarkView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 16;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
