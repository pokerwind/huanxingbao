//
//  UIView+Utilities.m
//  SMStore
//
//  Created by JingGuo on 2017/8/25.
//  Copyright © 2017年 Smedia Education Technology Co., Ltd. All rights reserved.
//

#import "UIView+Utilities.h"

#ifndef UIView_Utilities

#define kTagBadgeView  1000
#define kTagBadgePointView  1001
#define kTagLineView 1007

#endif
static const void *Th_indexkey = &Th_indexkey;
static const void *Button_indexkey = &Button_indexkey;

@implementation UIView (Utilities)
- (NSInteger)index {
    NSNumber *buttonNumber = objc_getAssociatedObject(self, Button_indexkey);
    return buttonNumber.integerValue;
}
- (void)setIndex:(NSInteger)index {
    NSNumber *buttonNumber = [NSNumber numberWithInteger:index];
    objc_setAssociatedObject(self, Button_indexkey, buttonNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSIndexPath *)th_index {
    return objc_getAssociatedObject(self, Th_indexkey);
}

- (void)setTh_index:(NSIndexPath *)th_index{
    objc_setAssociatedObject(self, Th_indexkey, th_index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setLeft:(CGFloat)newleft {
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTop:(CGFloat)newtop {
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)bottom {
    return (self.frame.origin.y + self.frame.size.height);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next);
    
    UIViewController *currentController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return currentController;
}

- (void)alertControllerWithTitle:(NSString *)title
                         message:(NSString *)message
                  preferredStyle:(UIAlertControllerStyle)preferredStyle
                    actionTitles:(NSArray<NSString *> *)actionTitles
                          cancel:(NSString *)cancel
                         handler:(void (^)(NSInteger))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:preferredStyle];
    for (int index = 0; index < actionTitles.count; index ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitles[index]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           NSString *title = action.title;
                                                           if ([actionTitles containsObject:title]) {
                                                               NSInteger actionIndex = [actionTitles indexOfObject:title];
                                                               if (handler) {
                                                                   handler(actionIndex + 1);
                                                               }
                                                           }
                                                       }];
        [alertController addAction:action];
    }
    if (cancel) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 if (handler) {
                                                                     handler(0);
                                                                 }
                                                             }];
        [alertController addAction:cancelAction];
    }
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}


- (void)resetX:(float)pX
{
    self.frame = CGRectMake(pX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
- (void)resetY:(float)pY
{
    self.frame = CGRectMake(self.frame.origin.x, pY, self.frame.size.width, self.frame.size.height);
}
- (void)resetWidth:(float)pWid
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, pWid, self.frame.size.height);
}
- (void)resetHeight:(float)pHeight
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, pHeight);
}

#pragma mark - 添加点击手势block
- (void)addBlock4Tap:(TapBlock)tapMBlock
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGes =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapMethod:)];
    [self addGestureRecognizer:tapGes];
    __weak UIView* weakSelf = self;
    weakSelf.tapBlock = tapMBlock;
}
- (void)tapMethod:(UIGestureRecognizer*)sender
{
    self.tapBlock(sender.view);
}
- (void)setTapBlock:(TapBlock)tapBlock
{
    objc_setAssociatedObject(self, @"tapBlock", tapBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (TapBlock)tapBlock
{
    return objc_getAssociatedObject(self, @"tapBlock");
}
#pragma mark - 添加虚线
- (void)appendImaginaryLineWithLineColor:(UIColor *)lineColor andDashPattern:(NSArray<NSNumber *>*)dashPatten andLineWid:(float)lineWid
{
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = lineColor.CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    //设置路径
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = lineWid;
    //设置线条的样式
    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = dashPatten;
//  @[@4, @2];
    [self.layer addSublayer:border];
}
/**
 *  自定义边框
 *
 *  @param cornerRadius 角落半径
 *  @param borderWidth  边框宽度
 *  @param color        边框颜色
 */
-(void)setBorderCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color{
    if (cornerRadius != 0) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
    }
    if (borderWidth != 0) {
        self.layer.borderWidth = borderWidth;
    }
    if (color != nil) {
        self.layer.borderColor = color.CGColor;
    }
}

/**
 *  设置阴影
 */
- (void)setShadow:(UIColor *)color{
    self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
    self.layer.shadowColor = color.CGColor;//阴影的颜色
    self.layer.shadowOpacity = 0.5f;   // 阴影透明度
    self.layer.shadowOffset = CGSizeMake(2,2); // 阴影的范围
    self.layer.shadowRadius = 2;  // 阴影扩散的范围控制
}
- (void)drawVerticalLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    UIView *lineView = self;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为Color
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
- (void)drawDashLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    UIView *lineView = self;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为Color
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
@end
