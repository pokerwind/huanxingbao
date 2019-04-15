//
//  DZGoodsDetailTitleView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/28.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodsDetailTitleView.h"

@implementation DZGoodsDetailTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.favoriteView.layer.masksToBounds = YES;
    self.favoriteView.layer.cornerRadius = 11;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
