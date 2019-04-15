//
//  DZFreightTemplateCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZFreightTemplateCell.h"

@implementation DZFreightTemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellIdentifier{
    return NSStringFromClass([self class]);
}

@end
