//
//  HomeCell.m
//  FoxPlayer
//
//  Created by hahaha on 2018/10/13.
//  Copyright © 2018年 RX. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.coverImageView.tag = 100;
        self.needBorder = YES;
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.playBtn];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playBtn.frame = self.contentView.bounds;
    self.backgroundColor = [UIColor whiteColor];
    
    [self setButtonImageAndTitleWithSpace:8 WithButton:self.playBtn];
//    self.playBtn.frame = CGRectMake(0, 0, 44, 44);
//    self.playBtn.center = self.coverImageView.center;
//    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.contentView);
//    }];
}

//- (void)setData:(ZFTableData *)data {
//    _data = data;
//    [self.coverImageView setImageWithURLString:data.thumbnail_url placeholder:[UIImage imageNamed:@"loading_bgView"]];
//}

-(void)setBorderWithDirection:(IBCellBorderDirection)direction{
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.lineWidth = 0.5;
    layer.borderWidth =0.5;
    CGRect rect = self.contentView.bounds;
    layer.strokeColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0  blue:224.0/255.0  alpha:1].CGColor;
    
    
    UIBezierPath*path = [[UIBezierPath alloc]init];
    
    if (direction & IBCellBorderDirectionTop) {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(rect.size.width, 0)];
        
        layer.path = path.CGPath;
        
        [self.contentView.layer addSublayer:layer];
        
    }
    if (direction & IBCellBorderDirectionBottom) {
        [path moveToPoint:CGPointMake(0, rect.size.height)];
        
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
        
        layer.path = path.CGPath;
        
        [self.contentView.layer addSublayer:layer];
        
    }
    if (direction & IBCellBorderDirectionLeft) {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(0, rect.size.height)];
        
        layer.path = path.CGPath;
        
        [self.contentView.layer addSublayer:layer];
        
    }
    if (direction & IBCellBorderDirectionRight) {
        [path moveToPoint:CGPointMake(rect.size.width, 0)];
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
        
        layer.path = path.CGPath;
        
        [self.contentView.layer addSublayer:layer];
        
    }
    
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (!self.needBorder) {
        return;
    }
//    if ((self.tag/3)==0) {
//        [self setBorderWithDirection:IBCellBorderDirectionTop|IBCellBorderDirectionRight];
//    }if ((self.tag/3)==1) {
//        [self setBorderWithDirection:IBCellBorderDirectionTop|IBCellBorderDirectionRight];
//    }
//    if ((self.tag/3)==2) {
//        [self setBorderWithDirection:IBCellBorderDirectionTop|IBCellBorderDirectionRight|IBCellBorderDirectionBottom];
//    }
    if ((self.tag/3)==0) {
        [self setBorderWithDirection:IBCellBorderDirectionBottom|IBCellBorderDirectionRight|IBCellBorderDirectionTop];
    }if ((self.tag/3)>0) {
        [self setBorderWithDirection:IBCellBorderDirectionBottom|IBCellBorderDirectionRight];
    }
}

//- (UIImageView *)coverImageView {
//    if (!_coverImageView) {
//        _coverImageView = [[UIImageView alloc] init];
//        _coverImageView.userInteractionEnabled = YES;
//        _coverImageView.tag = 100;
//        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _coverImageView.clipsToBounds = YES;
//    }
//    return _coverImageView;
//}


- (void)playBtnClick:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_playBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_playBtn setUserInteractionEnabled:NO];
    }
    return _playBtn;
}

- (void)setButtonImageAndTitleWithSpace:(CGFloat)spacing WithButton:(UIButton *)btn{
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text boundingRectWithSize:btn.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil].size;
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
//    if (selected) {
//        [self.playBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"#D8D8D8" alpha:0.1]];
    }
    else
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
}

@end
