//
//  JSHospitalInformationCell.h
//  iOSMedical
//
//  Created by 高盛通 on 2018/12/3.
//  Copyright © 2018年 ZJXxiaoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCircleListModel.h"
//#import "JSHospitalInfomationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JSHospitalInformationCell : UITableViewCell

/*
 * JSHospitalInfomationNewslist
 
 @property (nonatomic,strong)JSHospitalInfomationNewslist *list;

 */

/*
 * 昵称label
 */
@property (nonatomic,strong)UILabel *nameL;


/*
 * 备注
 */
@property (nonatomic,strong)UILabel *contentL;


/*
 *
 */
@property (nonatomic,strong)UIImageView *imageV;


/*
 * 查看详情
 */
@property (nonatomic,strong)UILabel *seeDetailL;


/*
 * 箭头
 */
@property (nonatomic,strong)UIImageView *arrowImageV;




+ (instancetype)cellWithTableView:(UITableView *)tableView;

/*
 * JSCircle
 */
@property (nonatomic,strong)JSCircleListData *model;

@end

NS_ASSUME_NONNULL_END
