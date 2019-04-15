//
//  DZShopFileTopView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopFileTopView.h"

@implementation DZShopFileTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.followButton.layer.masksToBounds = YES;
    self.followButton.layer.cornerRadius = 2;
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 23;
    self.followButton.layer.borderWidth = 0.5;
    self.followButton.layer.borderColor = OrangeColor.CGColor;
}

- (void)setIsFavoriteStr:(NSString *)isFavoriteStr {
    _isFavoriteStr = isFavoriteStr;
    if ([isFavoriteStr isEqualToString:@"0"]) {
        //未关注
        [self.followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        self.followButton.backgroundColor = OrangeColor;
        [self.followButton setTitleColor:TextWhiteColor forState:UIControlStateNormal];
        self.followButton.layer.borderColor = OrangeColor.CGColor;
    } else {
        [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
        self.followButton.backgroundColor = TextWhiteColor;
        [self.followButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        self.followButton.layer.borderColor = HEXCOLOR(0xdfdfdf).CGColor;
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
