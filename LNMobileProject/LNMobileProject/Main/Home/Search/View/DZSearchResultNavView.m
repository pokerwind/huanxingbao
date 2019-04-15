//
//  DZSearchNavView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/8.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSearchResultNavView.h"

@implementation DZSearchResultNavView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.searchView.layer.masksToBounds = YES;
    self.searchView.layer.cornerRadius = 4;
    self.searchView.layer.borderWidth = 0.5;
    self.searchView.layer.borderColor = HEXCOLOR(0xebebeb).CGColor;
    
//    self.layer.shadowColor = [UIColor grayColor].CGColor;
//    self.layer.shadowOpacity = 0.6;
//    self.layer.shadowRadius = 1;
//    self.layer.shadowOffset = CGSizeMake(0, 0.5);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
