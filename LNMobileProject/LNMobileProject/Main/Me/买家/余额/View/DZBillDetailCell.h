//
//  DZBillDetailCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/15.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetBalanceDetailsModel.h"

@interface DZBillDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *biandongleixing;

- (void)fillData:(DZBalanceDetailModel *)model;

@end
