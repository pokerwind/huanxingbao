//
//  DZGoodsDetailShopView.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZGoodsDetailShopView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *suppRateLabel;

@end
