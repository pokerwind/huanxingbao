//
//  UIView+Utilities.h
//  SMStore
//
//  Created by JingGuo on 2017/8/25.
//  Copyright © 2017年 Smedia Education Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^TapBlock)(UIView* view);
@interface UIView (Utilities)

/**
 辅助 View 基于 frame 的布局
 */
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGSize size;

@property (nonatomic, copy) TapBlock tapBlock;
@property (nonatomic,strong)NSIndexPath *th_index;
@property (nonatomic,assign)NSInteger index;
/**
 获取 View 响应的 controller
 永远可以获取一个 controller，可用来处理需要在 UIView 中需要 controller 的场景

 @return 响应 controller
 */
- (UIViewController *)viewController;

/**
 创建系统 alertController
 事件回调中的 actionIndex 标识：
 *** cancel 为 0；
 *** 事件列表中从 1 开始，依次递增。

 @param title           标题
 @param message         描述
 @param preferredStyle  风格
 @param actionTitles    事件列表
 @param cancel          取消事件
 @param handler         事件回调
 */
- (void)alertControllerWithTitle:(NSString *)title
                         message:(NSString *)message
                  preferredStyle:(UIAlertControllerStyle)preferredStyle
                    actionTitles:(NSArray <NSString *>*)actionTitles
                          cancel:(NSString *)cancel
                         handler:(void (^)(NSInteger actionIndex))handler;
//给View添加点击手势
- (void)addBlock4Tap:(TapBlock)tapMBlock;

- (void)resetX:(float)pX;
- (void)resetY:(float)pY;
- (void)resetWidth:(float)pWid;
- (void)resetHeight:(float)pHeight;
//添加虚线 dashPatten虚线的间隔
- (void)appendImaginaryLineWithLineColor:(UIColor *)lineColor andDashPattern:(NSArray<NSNumber *>*)dashPatten andLineWid:(float)lineWid;
/**
 *  自定义边框
 *
 *  @param cornerRadius 圆角半径
 *  @param borderWidth  边框宽度
 *  @param color        边框颜色
 */
- (void)setBorderCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color;

/**
 *  设置阴影
 */
- (void)setShadow:(UIColor *)color;
/**
 *  水平虚线
 */
- (void)drawDashLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
/**
 *  垂直虚线
 */
- (void)drawVerticalLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
@end
