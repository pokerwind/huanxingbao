//
//  PullListCell.m
//  ShopMobile
//
//  Created by LiuNiu-MacMini-YQ on 2017/3/13.
//  Copyright © 2017年 liuniukeji. All rights reserved.
//

#import "PullListCell.h"

@interface PullListCell ()

@property (nonatomic, strong) UIImageView *cheakView;

@end

@implementation PullListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (UIImageView *)cheakView
{
    if (_cheakView == nil) {
        _cheakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screen_icon_selected"]];
        _cheakView.frame = CGRectMake(0, 0, 20, 20);
//        _cheakView.contentMode =  UIViewContentModeScaleAspectFill;
//        _cheakView.clipsToBounds  = YES;
        self.accessoryView = _cheakView;
    }
    return _cheakView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.cheakView.hidden = !selected;
    if (selected) {
        self.cellTitleLabel.textColor = OrangeColor;
    } else {
        self.cellTitleLabel.textColor = TextLightColor;
    }
    // Configure the view for the selected state
}

@end
