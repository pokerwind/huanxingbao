//
//  DZMessageDetaiTableViewCell.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/30.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessageListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DZMessageDetaiTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/*
 * JSMessageList
 */
@property (nonatomic,strong)JSMessageListData *list;

/*
 * timeL
 */
@property (nonatomic,strong)UILabel *timeL;

/*
 * topicLabel
 */
@property (nonatomic,strong)UILabel *topicLabel;

@end

NS_ASSUME_NONNULL_END
