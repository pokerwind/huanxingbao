//
//  NSString+THStringCategory.h
//  TadpoleYun
//
//  Created by iOSMac on 2018/5/16.
//  Copyright © 2018年 iOSMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (THStringCategory)
/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGRect)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font         字体
 *  @param lineSpace    行间距
 *  @param maxSize      最大尺寸
 */
- (CGRect)sizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxSize:(CGSize)maxSize;
//字符串MD5加密
- (NSString *)md5Hash;
//字符串是否包含Emoji表情
- (BOOL)isContainsEmoji;
+ (NSString *)safeString:(NSString *)str;
@end
