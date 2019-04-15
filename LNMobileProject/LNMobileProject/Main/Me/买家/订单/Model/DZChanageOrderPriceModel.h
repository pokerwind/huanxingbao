//
//  DZChanageOrderPriceModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZOrderPriceModel : LNNetBaseModel

@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *order_sn;
@property (strong, nonatomic) NSString *pay_status;
@property (strong, nonatomic) NSString *order_status;
@property (strong, nonatomic) NSString *consignee;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *district;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *express_amount;
@property (strong, nonatomic) NSString *total_amount;
@property (strong, nonatomic) NSString *real_pay_amount;
@property (strong, nonatomic) NSString *before_pay_amount;//优惠前金额
@property (strong, nonatomic) NSString *add_time;
@property (strong, nonatomic) NSArray *order_goods;

@end

@interface DZChanageOrderPriceModel : LNNetBaseModel

@property (strong, nonatomic) DZOrderPriceModel *data;

@end
