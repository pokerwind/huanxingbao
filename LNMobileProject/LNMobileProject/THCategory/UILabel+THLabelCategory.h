//
//  UILabel+THLabelCategory.h
//  TadpoleYun
//
//  Created by iOSMac on 2018/5/16.
//  Copyright © 2018年 iOSMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (THLabelCategory)
- (void)setLabelTextColor:(UIColor *)textColor font:(UIFont *)font;

- (CGSize)labelSizeWithMaxiSize:(CGSize)maxiSize numberOfLines:(NSInteger)numberOfLines;
@end
