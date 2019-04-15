//
//  CustomRadarAnimationView.h
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/11.
//  Copyright © 2019 rx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomRadarAnimationView : UIView
@property (nonatomic,strong)UIImage * thumbnailImage;//中心图标
@property(nonatomic)UIColor *circleColor;
@property(nonatomic)UIColor *borderColor;
@property(assign,nonatomic)NSInteger pulsingCount;
@property(assign,nonatomic)double animationDuration;
-(instancetype)initWithFrame:(CGRect)frame andThumbnail:(NSString *)thumbnailUrl;//必须调用
@end

NS_ASSUME_NONNULL_END
