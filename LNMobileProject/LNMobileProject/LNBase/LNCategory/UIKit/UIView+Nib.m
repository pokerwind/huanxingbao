//
//  UIView+Nib.m
//  MobileProject
//
//  Created by LiuNiu-MacMini-YQ on 16/9/18.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "UIView+Nib.h"

@implementation UIView (Nib)

+ (instancetype)viewFormNib{
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                       owner:self
                                                     options:nil];
    return viewArray.lastObject;
}

@end
