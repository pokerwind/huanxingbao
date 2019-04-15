//
//  DZHomeAdReusableView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZHomeAdReusableView.h"

@implementation DZHomeAdReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickAction:(id)sender {
    [self.clickSubject sendNext:self.model];
}

@end
