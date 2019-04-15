//
//  DZGetAllRefundListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/4.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZRefundListGoodModel : NSObject

@property (strong, nonatomic) NSString *order_goods_id;
@property (strong, nonatomic) NSString *order_sn;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *buy_number;
@property (strong, nonatomic) NSString *order_return_id;
@property (strong, nonatomic) NSString *order_return_status;
@property (strong, nonatomic) NSString *is_valid;
@property (strong, nonatomic) NSString *prom_type;
@property (strong, nonatomic) NSString *is_comment;
@property (strong, nonatomic) NSString *goods_img;

@end

@interface DZRefundItemModel : NSObject

@property (strong, nonatomic) NSString *order_sn;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *refund_state;
@property (strong, nonatomic) NSString *refund_type;
@property (strong, nonatomic) NSString *refund_id;
@property (strong, nonatomic) NSString *shop_state;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *express_amount;
@property (strong, nonatomic) NSString *real_pay_amount;
@property (strong, nonatomic) NSArray *goods_list;

@end

@interface DZGetAllRefundListModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
