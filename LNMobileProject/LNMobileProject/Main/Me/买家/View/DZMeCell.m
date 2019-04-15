//
//  DZMeCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/10.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMeCell.h"

@interface DZMeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dotLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation DZMeCell

- (void)fillIcon:(NSString *)iconName title:(NSString *)title hasNew:(BOOL)hasNew subTitle:(nullable NSString *)subTitle{
    self.iconImageView.image = [UIImage imageNamed:iconName];
    self.dotLabel.layer.cornerRadius = 8;
    self.dotLabel.layer.masksToBounds = YES;
    self.nameLabel.text = title;
    if (hasNew) {
        self.dotLabel.hidden = NO;
    }else{
        self.dotLabel.hidden = YES;
    }
    if (subTitle) {
        self.subTitleLabel.hidden = NO;
        self.subTitleLabel.text = subTitle;
    }else{
        self.subTitleLabel.hidden = YES;
    }
}

@end
