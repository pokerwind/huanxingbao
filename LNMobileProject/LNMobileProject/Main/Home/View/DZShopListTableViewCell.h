//
//  DZShopListTableViewCell.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/29.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSShopListModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface DZShopListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *disL;
+ (DZShopListTableViewCell *)cellWithTableView:(UITableView *)tableView;

/*
 * JSShopListData
 */
@property (nonatomic,strong)JSShopListData *list;
@end

NS_ASSUME_NONNULL_END
