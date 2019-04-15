//
//  JSMessageTableViewCell.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/29.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessageListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JSMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

+ (JSMessageTableViewCell *)cellWithTableView:(UITableView *)tableView;

/*
 * JSMessageListData
 */
@property (nonatomic,strong)JSMessageListData *list;

@end

NS_ASSUME_NONNULL_END
