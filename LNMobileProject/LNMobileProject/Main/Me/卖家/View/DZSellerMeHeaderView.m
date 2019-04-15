//
//  DZSellerMeHeaderView.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/24.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSellerMeHeaderView.h"

@implementation DZSellerMeHeaderView

- (IBAction)henderButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHeaderAtIndex:)]) {
        [self.delegate didClickHeaderAtIndex:sender.tag];
    }
}


@end
