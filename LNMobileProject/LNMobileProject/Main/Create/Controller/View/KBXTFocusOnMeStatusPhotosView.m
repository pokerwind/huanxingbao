//
//  KBXTFocusOnMeStatusPhotosView.m
//  LNMobileProject
//
//  Created by liuniukeji on 2017/8/18.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//
// RGB颜色
#define gRColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
/**
 * 背景色
 */
#define backGroundColor gRColor(78, 54, 122)
// 随机色
#define gRandomColor gRColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#import "KBXTFocusOnMeStatusPhotosView.h"
@interface KBXTFocusOnMeStatusPhotosView ()
@property (nonatomic, strong) UIButton *photoView;
@end
@implementation KBXTFocusOnMeStatusPhotosView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
    }
    return self;
}
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    NSUInteger photosCount = photos.count;
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        self.photoView = [[UIButton alloc] init];
        [self addSubview:self.photoView];
    }
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {

        self.photoView = self.subviews[i];
        if (i < photosCount) { // 显示
            self.photoView.hidden = NO;
            [self.photoView setTitle:photos[i] forState:UIControlStateNormal];
            self.photoView.tag = i;
            self.photoView.backgroundColor = gRandomColor;
            [self.photoView addTarget:self action:@selector(photoViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        } else { // 隐藏
            self.photoView.hidden = YES;
        }
    }
    
}
- (void)photoViewBtn:(UIButton *)btn{
    // 通知第一个控制器，告诉它，按钮被点了
    
    // 通知代理
    // 判断代理信号是否有值
    if (self.delegateSignal) {
        // 有值，才需要通知
        [self.delegateSignal sendNext:btn];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;
    NSUInteger maxCol = ((photosCount>=3)?3:3);
    for (int i = 0; i<self.photos.count; i++) {
        UIImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = 10+col * (40+10);
        
        int row = i / maxCol;
        photoView.y = 10+row * (40+10);
        photoView.width = self.width/3;
        photoView.height = 40;
    }
}

+ (CGFloat)sizeWithCount:(NSUInteger)count
{
    ///最大列数(一行最多有多少列)
    NSUInteger maxCols = 3;
    ///列数
    //    NSUInteger cols = (count >= 3)?3:count;
    ///第几列的宽高70 + 间距 减掉一个，比如有3列，我们只需要中间的两个间距，所以减掉一个。
    //    CGFloat photosW = cols * 70 + (cols - 1) * 10;
    ///行数
    NSUInteger rows = (count+maxCols-1)/maxCols;
    CGFloat photosH = 10+rows * (40+10);
    
    NSLog(@"photosH---------%f",photosH);
    return photosH;
}
@end
