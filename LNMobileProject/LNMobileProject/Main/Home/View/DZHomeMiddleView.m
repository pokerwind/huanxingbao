//
//  DZHomeMiddleView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZHomeMiddleView.h"

@implementation DZHomeMiddleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *leftTapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBtnClick:)];
    [self.leftView addGestureRecognizer:leftTapG];
    
    UITapGestureRecognizer *rightTapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBtnClick:)];
    [self.rightView addGestureRecognizer:rightTapG];
}

- (void)leftBtnClick:(UITapGestureRecognizer *)tapG
{
    if (self.leftBlock) {
        self.leftBlock(@"");
    }
    NSLog(@"1111");
}

- (void)rightBtnClick:(UITapGestureRecognizer *)tapG
{
    if (self.rightBlock) {
        self.rightBlock(@"");
    }
    NSLog(@"2222");
}

@end
