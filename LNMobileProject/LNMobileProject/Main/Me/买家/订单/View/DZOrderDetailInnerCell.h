//
//  DZOrderDetailInnerCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetOrderListModel.h"

@interface DZOrderDetailInnerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *refundButton;
@property (weak, nonatomic) IBOutlet UILabel *formatLabel;
@property (nonatomic) BOOL canRefund;

- (void)fillData:(DZGoodInfoModel *)model;

@end
