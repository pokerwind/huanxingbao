//
//  DZGetUserInfoModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/22.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZUserInfoModel : NSObject

@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *head_pic;
@property (strong, nonatomic) NSString *register_time;
@property (strong, nonatomic) NSString *points;
@property (strong, nonatomic) NSString *user_level;
@property (strong, nonatomic) NSString *audit_status;//开店状态
@property (strong, nonatomic) NSString *credit;
@property (strong, nonatomic) NSString *is_openShop;
@property (strong, nonatomic) NSString *pay_password;
/*
 * has_set_pay_password
 */
@property (nonatomic,copy)NSString *has_set_pay_password;

@end

@interface DZGetUserInfoModel : LNNetBaseModel

@property (strong, nonatomic) DZUserInfoModel *data;

@end
