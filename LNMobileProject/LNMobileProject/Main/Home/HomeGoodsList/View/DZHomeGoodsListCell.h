//
//  DZHomeGoodsListCell.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZHomeGoodsListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *xiaoshouLabel;

- (void)fillPic:(NSString *)picUrl title:(NSString *)title pack_price:(NSString *)pack_price shop_price:(NSString *)shop_price;

- (void)setEditingState:(NSInteger)state;

- (void)configView:(id)model;
@end
