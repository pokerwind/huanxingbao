//
//  UIColor+THColorCategpry.h
//  TadpoleYun
//
//  Created by iOSMac on 2018/5/16.
//  Copyright © 2018年 iOSMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (THColorCategpry)
/**
 颜色转图片
 
 @param color 输入颜色
 @return 输出色块
 */
+(UIImage *)createImageWithColor:(UIColor *)color;
/**
 随机返回一个颜色
 
 @return 随机色
 */
+ (UIColor *)randomColor;

/**
 RGB转换成UIColor
 
 @return 返回UIColor对象
 */
+ (UIColor *)returnColorWithR:(CGFloat)red andG:(CGFloat)green andB:(CGFloat)blue;

/**
 将16进制颜色转换成UIColor
 
 @param colorStr 16进制色值
 
 @return UIColor
 */
+ (UIColor *)returnColorWithHexString:(NSString *)colorStr;

/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;
/**
 *  @brief  获取canvas用的颜色字符串
 *
 *  @return canvas颜色
 */
- (NSString *)canvasColorString;
/**
 *  @brief  获取网页颜色字串
 *
 *  @return 网页颜色
 */
- (NSString *)webColorString;
@end
