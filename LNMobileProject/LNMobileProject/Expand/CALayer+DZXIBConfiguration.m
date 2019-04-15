//
//  CALayer+DZXIBConfiguration.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "CALayer+DZXIBConfiguration.h"

@implementation CALayer (DZXIBConfiguration)

-(void)setBorderUIColor:(UIColor *)color
{
    self.borderColor=color.CGColor;
}
-(UIColor *)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
