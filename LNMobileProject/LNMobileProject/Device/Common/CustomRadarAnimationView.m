//
//  CustomRadarAnimationView.m
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/11.
//  Copyright © 2019 rx. All rights reserved.
//

#import "CustomRadarAnimationView.h"
@interface CustomRadarAnimationView ()
@property (nonatomic,weak)CALayer * animationLayer;//动画图层
@end
@implementation CustomRadarAnimationView

-(instancetype)initWithFrame:(CGRect)frame andThumbnail:(NSString *)thumbnailUrl{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resume) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        self.backgroundColor = [UIColor clearColor];
        self.thumbnailImage = [UIImage imageNamed:thumbnailUrl];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor clearColor] setFill];//view的背景色
    
    UIRectFill(rect);
    
    //     _pulsingCount = 3;//雷达上波纹的条数
    //    _animationDuration = 2;//一组动画持续的时间，直接决定了动画运行快慢。
    
    CALayer * animationLayer = [[CALayer alloc]init];
    self.animationLayer = animationLayer;
    
    for (int i = 0; i < _pulsingCount; i++) {
        CALayer * pulsingLayer = [[CALayer alloc]init];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.backgroundColor = _circleColor.CGColor;//圈圈背景颜色，不设置则为透明。
        pulsingLayer.borderColor = self.borderColor.CGColor;
        pulsingLayer.borderWidth = 1.0;
        pulsingLayer.cornerRadius = rect.size.height/2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.fillMode = kCAFillModeBoth;
        //因为雷达中每个圈圈的大小不一致，故需要他们在一定的相位差的时刻开始运行。
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * _animationDuration/(double)_pulsingCount;
        animationGroup.duration = _animationDuration;//每个圈圈从生成到消失使用时常，也即动画组每轮动画持续时常
        animationGroup.repeatCount = HUGE_VAL;//表示动画组持续时间为无限大，也即动画无限循环。
        animationGroup.timingFunction = defaultCurve;
        
        //雷达圆圈初始大小以及最终大小比率。
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fromValue = [NSNumber numberWithDouble:0.4];
        scaleAnimation.toValue = [NSNumber numberWithDouble:1.0];
        
        //雷达圆圈在n个运行阶段的透明度，n为数组长度。
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        //雷达运行四个阶段不同的透明度。
        opacityAnimation.values = @[[NSNumber numberWithDouble:1.0],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:0.3],[NSNumber numberWithDouble:0.0]];
        //雷达运行的不同的四个阶段，为0.0表示刚运行，0.5表示运行了一半，1.0表示运行结束。
        opacityAnimation.keyTimes = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:0.25],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:1.0]];
        //将两组动画（大小比率变化动画，透明度渐变动画）组合到一个动画组。
        animationGroup.animations = @[scaleAnimation,opacityAnimation];
        
        [pulsingLayer addAnimation:animationGroup forKey:@"pulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:self.animationLayer];
    
    
}

- (void)resume{
    
    if (self.animationLayer) {
        [self.animationLayer removeFromSuperlayer];
        [self setNeedsDisplay];
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
