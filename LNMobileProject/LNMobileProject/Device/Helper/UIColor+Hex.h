//
//  UIColor+Hex.h
//  SYLongPressDragSort
//
//  Created by hahaha on 2017/7/7.
//  Copyright © 2017年 RX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end
