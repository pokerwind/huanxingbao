//
//  UILabel+THLabelCategory.m
//  TadpoleYun
//
//  Created by iOSMac on 2018/5/16.
//  Copyright © 2018年 iOSMac. All rights reserved.
//

#import "UILabel+THLabelCategory.h"

@implementation UILabel (THLabelCategory)
- (void)setLabelTextColor:(UIColor *)textColor font:(UIFont *)font;
{
    self.textColor = textColor;
    self.font = font;
}
- (CGSize)labelSizeWithMaxiSize:(CGSize)maxiSize numberOfLines:(NSInteger)numberOfLines{
    self.numberOfLines = numberOfLines;
    CGSize Size = [self sizeThatFits:maxiSize];
    return Size;
}
@end
