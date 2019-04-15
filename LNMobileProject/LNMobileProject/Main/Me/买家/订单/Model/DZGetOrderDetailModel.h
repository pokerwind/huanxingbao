//
//  DZGetOrderDetailModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"
#import "DZGetOrderListModel.h"
#import "DZEMChatUserModel.h"

@interface DZOrderDetailModel : NSObject

@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSString *order_sn;
@property (strong, nonatomic) NSString *order_status;
@property (strong, nonatomic) NSString *pay_status;
@property (strong, nonatomic) NSString *total_amount;
@property (strong, nonatomic) NSString *express_amount;
@property (strong, nonatomic) NSString *real_pay_amount;
@property (strong, nonatomic) NSString *total_buy_number;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *add_time;
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSString *consignee;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *zipcode;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *shop_mobile;
@property (strong, nonatomic) NSArray *order_goods;
@property (strong, nonatomic) DZEMChatUserModel *echat;
@end

@interface DZGetOrderDetailModel : LNNetBaseModel

@property (nonatomic, strong) DZOrderDetailModel *data;

@end
