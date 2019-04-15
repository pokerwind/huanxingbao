//
//  DZModifyOrderCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetOrderDetailModel.h"

@protocol DZModifyOrderCellDelegate <NSObject>

- (void)priceDidUpdate;

@end

@interface DZModifyOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSc;
@property (weak, nonatomic) IBOutlet UITextField *changeMoneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic) id <DZModifyOrderCellDelegate>delegate;

- (void)fillData:(DZGoodInfoModel *)model;

@end
