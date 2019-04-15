//
//  DZWithdrawCardCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetUserBankCardListModel.h"

@interface DZWithdrawCardCell : UITableViewCell

- (void)fillData:(DZUserBankCardModel *)model;

@end
