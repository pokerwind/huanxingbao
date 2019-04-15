//
//  DZMyOrderInnerCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetOrderListModel.h"

@interface DZMyOrderInnerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


- (void)fillData:(DZGoodInfoModel *)model;

@end
