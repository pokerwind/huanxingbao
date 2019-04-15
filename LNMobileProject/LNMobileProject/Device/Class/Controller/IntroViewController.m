//
//  IntroViewController.m
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/19.
//  Copyright © 2019 rx. All rights reserved.
//

#import "IntroViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface IntroViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate>//签代理
{
    UIScrollView *scrolleView;
    UIImageView *imgV;
    NSMutableArray *introImages;
}
@property (nonatomic, strong) SDCycleScrollView *cycleView;
@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"使用说明";
    introImages = [NSMutableArray new];
    for (int i = 1; i<16; i++) {
        [introImages addObject:[NSString stringWithFormat:@"intro%d.jpg",i]];
    }
    
//    scrolleView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
//    [scrolleView setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:scrolleView];
//    
//    //初始化imageview，设置图片
//    imgV = [[UIImageView alloc]init];
//    imgV.image = [UIImage imageNamed:@"WechatIMG664.png"];
//    imgV.frame = CGRectMake(0, 0, ScreenW, [self imageCompressForWidthScale:imgV.image targetWidth:ScreenW].size.height);
//    [scrolleView addSubview:imgV];
//    
//    //设置代理,设置最大缩放和虽小缩放
//    scrolleView.delegate = self;
//    scrolleView.maximumZoomScale = 5;
//    scrolleView.minimumZoomScale = 1;
//    
//    //设置UIScrollView的滚动范围和图片的真实尺寸一致
//    scrolleView.contentSize = imgV.frame.size;
//    
//    
//    
//    
//    if (@available(iOS 11.0, *)) {
//        scrolleView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//    
//    [scrolleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(self.view);
//        make.top.equalTo(self.view).with.offset(IsiPhoneX?88:64);
//    }];
//
    
    [self.view addSubview:self.cycleView];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(0);
        make.top.right.left.bottom.equalTo(self.view);
//        make.height.mas_equalTo(240);
    }];
    [self.cycleView setImageURLStringsGroup:[introImages copy]];
    // Do any additional setup after loading the view.
}

////代理方法，告诉ScrollView要缩放的是哪个视图
//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return imgV;
//}
//
////指定宽度按比例缩放
//-(UIImage *) imageCompressForWidthScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
//
//    UIImage *newImage = nil;
//    CGSize imageSize = sourceImage.size;
//    CGFloat width = imageSize.width;
//    CGFloat height = imageSize.height;
//    CGFloat targetWidth = defineWidth;
//    CGFloat targetHeight = height / (width / targetWidth);
//    CGSize size = CGSizeMake(targetWidth, targetHeight);
//    CGFloat scaleFactor = 0.0;
//    CGFloat scaledWidth = targetWidth;
//    CGFloat scaledHeight = targetHeight;
//    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
//
//    if(CGSizeEqualToSize(imageSize, size) == NO){
//
//        CGFloat widthFactor = targetWidth / width;
//        CGFloat heightFactor = targetHeight / height;
//
//        if(widthFactor > heightFactor){
//            scaleFactor = widthFactor;
//        }
//        else{
//            scaleFactor = heightFactor;
//        }
//        scaledWidth = width * scaleFactor;
//        scaledHeight = height * scaleFactor;
//
//        if(widthFactor > heightFactor){
//
//            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
//
//        }else if(widthFactor < heightFactor){
//
//            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
//        }
//    }
//
//    UIGraphicsBeginImageContext(size);
//
//    CGRect thumbnailRect = CGRectZero;
//    thumbnailRect.origin = thumbnailPoint;
//    thumbnailRect.size.width = scaledWidth;
//    thumbnailRect.size.height = scaledHeight;
//
//    [sourceImage drawInRect:thumbnailRect];
//
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    if(newImage == nil){
//
//        NSLog(@"scale image fail");
//    }
//    UIGraphicsEndImageContext();
//    return newImage;
//}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    //    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}


- (SDCycleScrollView*)cycleView
{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, 180) shouldInfiniteLoop:YES imageNamesGroup:@[[UIImage imageNamed:@"bk"]]];
        _cycleView.delegate = self;
        _cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleView.showPageControl = NO;
        [_cycleView setAutoScroll:NO];
    }
    return _cycleView;
}
@end
