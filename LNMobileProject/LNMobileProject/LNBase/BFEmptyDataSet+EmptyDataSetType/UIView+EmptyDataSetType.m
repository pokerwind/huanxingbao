//
//  UIView+EmptyDataSetType.m
//  BFEmptyDataSet
//
//  Created by LiuNiu-MacMini-YQ on 16/8/27.
//  Copyright © 2016年 qtone_yzt. All rights reserved.
//

#import "UIView+EmptyDataSetType.h"
#import <objc/runtime.h>

@implementation UIView (EmptyDataSetType)

- (void)setEmptyDataType:(NSUInteger)emptyDataType{
    objc_setAssociatedObject(self, @selector(emptyDataType), @(emptyDataType), OBJC_ASSOCIATION_ASSIGN);
}

- (NSUInteger)emptyDataType{
    return [objc_getAssociatedObject(self, @selector(emptyDataType)) unsignedIntegerValue];
}

@end
