//
//  DZHomeMidBottomView.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/18.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZHomeMidBottomView.h"

@implementation DZHomeMidBottomView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *jfdhTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jfdhTapG:)];
    [self.jfdhImagev addGestureRecognizer:jfdhTap];
    
    UITapGestureRecognizer *hyqyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hyqyTapG:)];
    [self.hyqyImagev addGestureRecognizer:hyqyTap];
    
    UITapGestureRecognizer *dkfTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dkfTapG:)];
    [self.dkfImageV addGestureRecognizer:dkfTap];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)jfdhTapG:(UITapGestureRecognizer *)tapG
{
    if (self.jBlock) {
        self.jBlock();
    }
}

- (void)hyqyTapG:(UITapGestureRecognizer *)tapG
{
    if (self.hBlock) {
        self.hBlock();
    }
}


- (void)dkfTapG:(UITapGestureRecognizer *)tapG
{
    if (self.dBlock) {
        self.dBlock();
    }
}


@end
