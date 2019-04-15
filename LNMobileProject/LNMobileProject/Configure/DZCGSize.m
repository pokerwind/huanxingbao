//
//  DZCGSize.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/28.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZCGSize.h"

@implementation DZCGSize
/** 根据文字内容和字体，最大宽度 得到尺寸 */
+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxW:(CGFloat)maxW{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
