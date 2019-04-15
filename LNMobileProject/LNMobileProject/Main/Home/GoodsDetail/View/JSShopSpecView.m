//
//  JSShopSpecView.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/30.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "JSShopSpecView.h"

@implementation JSShopSpecView

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapG:)];
    [self addGestureRecognizer:tapG];
}

- (void)tapG:(UITapGestureRecognizer *)tapG
{
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
