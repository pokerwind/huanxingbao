//
//  DZSystemNoticeCell.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/10/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSystemNoticeCell.h"

@implementation DZSystemNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y +=4;
    frame.size.height -=4;
    [super setFrame:frame];
}

@end
