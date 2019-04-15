//
//  DZShopDetailHeadView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopDetailHeadView.h"

@interface DZShopDetailHeadView()


@end

@implementation DZShopDetailHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.layer.masksToBounds = YES;
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 30;
    
    self.followButton.layer.masksToBounds = YES;
    self.followButton.layer.cornerRadius = 2;
    self.followButton.layer.borderWidth = 0.5;
    self.followButton.layer.borderColor = OrangeColor.CGColor;
    
    self.shopTypeLabel.layer.masksToBounds = YES;
    self.shopTypeLabel.layer.cornerRadius = 2;
    self.commentButton.userInteractionEnabled = NO;
}

- (void)setIsFavoriteStr:(NSString *)isFavoriteStr {
    _isFavoriteStr = isFavoriteStr;
    if ([isFavoriteStr isEqualToString:@"0"]) {
        //未关注
        [self.followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        self.followButton.backgroundColor = OrangeColor;
        [self.followButton setTitleColor:TextWhiteColor forState:UIControlStateNormal];
    } else {
        [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
        self.followButton.backgroundColor = TextWhiteColor;
        [self.followButton setTitleColor:OrangeColor forState:UIControlStateNormal];
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
