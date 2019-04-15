//
//  DZCGSize.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/28.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DZCGSize : NSObject
/** 根据文字内容和字体，最大宽度 得到尺寸 */
+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxW:(CGFloat)maxW;

@end

NS_ASSUME_NONNULL_END
