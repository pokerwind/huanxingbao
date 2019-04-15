//
//  DZCardManagementCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetUserBankCardListModel.h"

@interface DZCardManagementCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (void)fillData:(DZUserBankCardModel *)model;

@end
