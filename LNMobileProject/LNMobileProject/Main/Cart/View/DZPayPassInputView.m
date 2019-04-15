//
//  DZPayPassInputView.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/11/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZPayPassInputView.h"

@implementation DZPayPassInputView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.cancelButton.layer.cornerRadius = 4;
    self.confirmButton.layer.cornerRadius = 4;
    self.cancelButton.layer.borderWidth = 0.5;
    self.cancelButton.layer.borderColor = HEXCOLOR(999999).CGColor;
}

@end
