//
//  DZShopFileReviewView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopFileReviewView.h"
@interface DZShopFileReviewView()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsRateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceRateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *expressImageView;
@property (weak, nonatomic) IBOutlet UILabel *expressRateLabel;


@property (weak, nonatomic) IBOutlet UIImageView *star11;
@property (weak, nonatomic) IBOutlet UIImageView *star12;
@property (weak, nonatomic) IBOutlet UIImageView *star13;
@property (weak, nonatomic) IBOutlet UIImageView *star14;
@property (weak, nonatomic) IBOutlet UIImageView *star15;
@property (weak, nonatomic) IBOutlet UIImageView *star21;
@property (weak, nonatomic) IBOutlet UIImageView *star22;
@property (weak, nonatomic) IBOutlet UIImageView *star23;
@property (weak, nonatomic) IBOutlet UIImageView *star24;
@property (weak, nonatomic) IBOutlet UIImageView *star25;
@property (weak, nonatomic) IBOutlet UIImageView *star31;
@property (weak, nonatomic) IBOutlet UIImageView *star32;
@property (weak, nonatomic) IBOutlet UIImageView *star33;
@property (weak, nonatomic) IBOutlet UIImageView *star34;
@property (weak, nonatomic) IBOutlet UIImageView *star35;
@end

@implementation DZShopFileReviewView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setGoodsRank:(NSString *)goodsRank {
    _goodsRank = goodsRank;
    self.goodsRateLabel.text = goodsRank;
    NSInteger value = (int)round(goodsRank.floatValue);
    NSString *imageName = [NSString stringWithFormat:@"icon_%ldstar",value];
    self.goodsImageView.image = [UIImage imageNamed:imageName];
}

- (void)setServiceRank:(NSString *)serviceRank {
    _serviceRank = serviceRank;
    self.serviceRateLabel.text = serviceRank;
    NSInteger value = (int)round(serviceRank.floatValue);
    NSString *imageName = [NSString stringWithFormat:@"icon_%ldstar",value];
    self.serviceImageView.image = [UIImage imageNamed:imageName];
}

- (void)setExpressRank:(NSString *)expressRank {
    _expressRank = expressRank;
    self.expressRateLabel.text = expressRank;
    NSInteger value = (int)round(expressRank.floatValue);
    NSString *imageName = [NSString stringWithFormat:@"icon_%ldstar",value];
    self.expressImageView.image = [UIImage imageNamed:imageName];
}

- (void)setQualityStarCount:(CGFloat)count{
    
    self.goodsRateLabel.text = [NSString stringWithFormat:@"%.1f",count];
    NSInteger completeCount = count;
    NSInteger dotCount = (int)(count * 10) % 10;
    switch (completeCount) {
        case 0:{
            self.star12.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star13.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star14.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star15.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star11.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star11.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star11.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 1:{
            self.star13.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star14.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star15.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star12.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star12.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star12.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 2:{
            self.star14.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star15.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star13.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star13.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star13.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 3:{
            self.star15.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star14.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star14.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star14.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 4:{
            if (dotCount <= 2) {
                self.star15.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star15.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star15.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        default:
            break;
    }
}

- (void)setServiceStarCount:(CGFloat)count{
    self.serviceRateLabel.text = [NSString stringWithFormat:@"%.1f",count];
    NSInteger completeCount = count;
    NSInteger dotCount = (int)(count * 10) % 10;
    switch (completeCount) {
        case 0:{
            self.star22.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star23.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star24.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star25.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star21.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star21.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star21.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 1:{
            self.star23.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star24.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star25.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star22.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star22.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star22.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 2:{
            self.star24.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star25.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star23.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star23.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star23.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 3:{
            self.star25.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star24.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star24.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star24.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 4:{
            if (dotCount <= 2) {
                self.star25.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star25.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star25.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        default:
            break;
    }
}

- (void)setExpressStarCount:(CGFloat)count{
    self.expressRateLabel.text = [NSString stringWithFormat:@"%.1f",count];
    NSInteger completeCount = count;
    NSInteger dotCount = (int)(count * 10) % 10;
    switch (completeCount) {
        case 0:{
            self.star32.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star33.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star34.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star35.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star31.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star31.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star31.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 1:{
            self.star33.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star34.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star35.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star32.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star32.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star32.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 2:{
            self.star34.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star35.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star33.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star33.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star33.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 3:{
            self.star35.image = [UIImage imageNamed:@"icon_1star_n"];
            if (dotCount <= 2) {
                self.star34.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star34.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star34.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        case 4:{
            if (dotCount <= 2) {
                self.star35.image = [UIImage imageNamed:@"icon_1star_n"];
            }else if (dotCount <= 7){
                self.star35.image = [UIImage imageNamed:@"icon_halfstar_s"];
            }else{
                self.star35.image = [UIImage imageNamed:@"icon_1star_s"];
            }
            break;
        }
        default:
            break;
    }
}

@end
