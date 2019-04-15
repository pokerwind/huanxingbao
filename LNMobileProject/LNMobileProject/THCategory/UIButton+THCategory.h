//
//  UIButton+THCategory.h
//  BusinessSecretary
//
//  Created by 典典 on 2017/5/8.
//  Copyright © 2017年 童浩. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TouchedBlock)(NSInteger index);
@interface UIButton (THCategory)
/**
 *  @brief  设置按钮额外热区
 */
@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;
/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
/*
    button的block设置方法
 */
-(void)addActionHandler:(TouchedBlock)touchHandler;

/** 图片在左，标题在右 */
- (void)setIconInLeft;
/** 图片在右，标题在左 */
- (void)setIconInRight;
/** 图片在上，标题在下 */
- (void)setIconInTop;
/** 图片在下，标题在上 */
- (void)setIconInBottom;

//** 可以自定义图片和标题间的间隔 */
- (void)setIconInLeftWithSpacing:(CGFloat)Spacing;
- (void)setIconInRightWithSpacing:(CGFloat)Spacing;
- (void)setIconInTopWithSpacing:(CGFloat)Spacing;
- (void)setIconInBottomWithSpacing:(CGFloat)Spacing;

- (void)countDownFromTime:(NSInteger)startTime title:(NSString *)title unitTitle:(NSString *)unitTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;

@end
