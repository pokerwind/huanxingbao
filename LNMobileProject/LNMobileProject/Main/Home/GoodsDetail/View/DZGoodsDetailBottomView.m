//
//  DZGoodsDetailBottomView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodsDetailBottomView.h"

@implementation DZGoodsDetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)cartClick:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

@end
