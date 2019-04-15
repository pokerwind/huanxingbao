//
//  DZShopDetailHeadView.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZShopDetailHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *followNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *rebuyRateLabel;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UILabel *goodRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (nonatomic, copy) NSString *isFavoriteStr;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *descView;

@property (weak, nonatomic) IBOutlet UIImageView *bondImageView;
@property (weak, nonatomic) IBOutlet UILabel *bondLabel;

@property (weak, nonatomic) IBOutlet UILabel *shopTypeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopTypeLabelLeading;

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;

@property (weak, nonatomic) IBOutlet UIImageView *returnImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *returnImageViewLeading;
@property (weak, nonatomic) IBOutlet UILabel *maijiaFuwuLabel;
@property (weak, nonatomic) IBOutlet UILabel *baobeimiaoshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *wuliufuwuLabel;


@end
