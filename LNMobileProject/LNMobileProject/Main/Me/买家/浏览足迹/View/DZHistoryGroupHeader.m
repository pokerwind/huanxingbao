//
//  DZHistoryGroupHeader.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/18.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZHistoryGroupHeader.h"

@implementation DZHistoryGroupHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 25)];
        self.dateLabel.textColor = HEXCOLOR(0x333333);
        self.dateLabel.font = [UIFont systemFontOfSize:14];
        self.dateLabel.text = @"--月--日";
        [self addSubview:self.dateLabel];
    }
    
    return self;
}

@end
