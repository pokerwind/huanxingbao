//
//  DZGetBalanceDetailsModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZBalancLogModel : NSObject

@property (strong, nonatomic) NSString *user_money;
@property (strong, nonatomic) NSString *change_type;
@property (strong, nonatomic) NSString *change_desc;
@property (strong, nonatomic) NSString *change_sign;

@end

@interface DZBalanceDetailModel : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSArray *log_list;
@property(nonatomic,strong) NSString *amount;
@property(nonatomic,strong) NSString *direct;
@property(nonatomic,strong) NSString *money_type;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *add_time;
@property(nonatomic,strong) NSString *direct_str;
@property(nonatomic,strong) NSString *money_type_str;
@property(nonatomic,strong) NSString *type_str;

@end

@interface DZGetBalanceDetailsModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
