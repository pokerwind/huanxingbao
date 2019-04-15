//
//  CommodityLikeCell.h
//  ShopMobile
//
//  Created by net apa on 2017/5/18.
//  Copyright © 2017年 liuniukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityLikeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *commodityImage;
@property (weak, nonatomic) IBOutlet UILabel *commodityName;
@property (weak, nonatomic) IBOutlet UILabel *commodityPrice;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end
