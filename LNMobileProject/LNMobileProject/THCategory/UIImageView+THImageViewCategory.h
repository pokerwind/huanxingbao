//
//  UIImageView+THImageViewCategory.h
//  TadpoleYun
//
//  Created by iOSMac on 2018/5/16.
//  Copyright © 2018年 iOSMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (THImageViewCategory)
/**
 *  @brief  根据bundle中的图片名创建imageview
 *
 *  @param imageName bundle中的图片名
 *
 *  @return imageview
 */
+ (id) imageViewWithImageNamed:(NSString*)imageName;
/**
 *  @brief  创建imageview动画
 *
 *  @param imageArray 图片名称数组
 *  @param duration   动画时间
 *
 *  @return imageview
 */
+ (id) imageViewWithImageArray:(NSArray*)imageArray duration:(NSTimeInterval)duration;
- (void) setImageWithStretchableImage:(NSString*)imageName;
// 画水印
// 图片水印
- (void) setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect;
// 文字水印
- (void) setImage:(UIImage *)image withStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font;
- (void) setImage:(UIImage *)image withStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;
/**
 *  @brief  倒影
 */
- (void)reflect;
@end
