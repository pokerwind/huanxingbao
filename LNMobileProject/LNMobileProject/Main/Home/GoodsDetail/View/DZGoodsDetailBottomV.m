//
//  DZGoodsDetailBottomV.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/2/14.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZGoodsDetailBottomV.h"

@implementation DZGoodsDetailBottomV
- (IBAction)btnClick:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
