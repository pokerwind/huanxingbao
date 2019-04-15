//
//  DZPraiseTableViewCell.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/28.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCommentListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DZPraiseTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/*
 * 头像
 */
@property (nonatomic,strong)UIImageView *iconImageV;

/*
 * nameL
 */
@property (nonatomic,strong)UILabel *nameL;

/*
 * timeL
 */
@property (nonatomic,strong)UILabel *timeL;

/*
 * topicLabel
 */
@property (nonatomic,strong)UILabel *topicLabel;

/*
 * JSCommentListData
 */
@property (nonatomic,strong)JSCommentListData *list;
@end

NS_ASSUME_NONNULL_END
