//
//  DZGoodManagementEditCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetGoodListModel.h"

@interface DZGoodManagementEditCell : UITableViewCell

+ (NSString *)cellIdentifier;

- (void)fillData:(DZGoodModel *)model;

@end
