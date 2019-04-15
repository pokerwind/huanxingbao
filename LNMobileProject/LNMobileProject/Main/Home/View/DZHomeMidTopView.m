//
//  DZHomeMidTopView.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/18.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZHomeMidTopView.h"

@implementation DZHomeMidTopView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *lxzTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lxzTapG:)];
    [self.lxzImageV addGestureRecognizer:lxzTap];
    
    UITapGestureRecognizer *mfsyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mfsyTapG:)];
    [self.mfsyImagev addGestureRecognizer:mfsyTap];
    
    UITapGestureRecognizer *pxgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pxgTapG:)];
    [self.pxgImageV addGestureRecognizer:pxgTap];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)lxzTapG:(UITapGestureRecognizer *)tapG
{
    if (self.lBlock) {
        self.lBlock();
    }
}

- (void)mfsyTapG:(UITapGestureRecognizer *)tapG
{
    if (self.mBlock) {
        self.mBlock();
    }
}


- (void)pxgTapG:(UITapGestureRecognizer *)tapG
{
    if (self.pBlock) {
        self.pBlock();
    }
}


@end
