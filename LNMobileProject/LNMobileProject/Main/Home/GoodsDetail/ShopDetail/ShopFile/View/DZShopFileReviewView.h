//
//  DZShopFileReviewView.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZShopFileReviewView : UIView
@property (weak, nonatomic) IBOutlet UILabel *goodRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrorImageView;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (nonatomic, copy) NSString *goodsRank;
@property (nonatomic, copy) NSString *serviceRank;
@property (nonatomic, copy) NSString *expressRank;

- (void)setQualityStarCount:(CGFloat)count;
- (void)setServiceStarCount:(CGFloat)count;
- (void)setExpressStarCount:(CGFloat)count;
@end
