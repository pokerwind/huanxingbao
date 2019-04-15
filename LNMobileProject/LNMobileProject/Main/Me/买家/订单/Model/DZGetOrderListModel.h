//
//  DZGetOrderListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/16.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZOrderDetailSpecModel : NSObject

@property (nonatomic, strong) NSString *spec;
@property (nonatomic, strong) NSString *buy_number;

@end

@interface DZGoodInfoModel : NSObject

@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *goods_img;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *total_buy_number;
@property (strong, nonatomic) NSString *total_money;

@property (strong, nonatomic) NSString *after_money;

@property (strong, nonatomic) NSString *is_comment;//订单详情页接口返回数据包含该字段
@property (strong, nonatomic) NSString *order_goods_id;

@property (strong, nonatomic) NSString *order_return_status;//状态 0正常订单 1退货退款中 3申请驳回 4退款完成，状态伟0和3时，可重新申请
@property (strong, nonatomic) NSString *order_return_msg;

@property (strong, nonatomic) NSString *refund_state;//退款状态 1退款中 2退货退款中

@property (strong, nonatomic) NSArray *spec_list;

@property (strong, nonatomic) NSString *allow_return;

@end

@interface DZOrderListItemModel : NSObject

@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_sn;
@property (nonatomic, strong) NSString *order_status;
@property (nonatomic, strong) NSString *pay_status;
@property (nonatomic, strong) NSString *total_amount;
@property (nonatomic, strong) NSString *express_amount;
@property (nonatomic, strong) NSString *real_pay_amount;
@property (nonatomic, strong) NSString *total_buy_number;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *shop_name;
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSArray *goods_info;
@property (nonatomic) NSInteger is_evaluation;

@end


@interface DZOrderListModel : NSObject

@property (nonatomic, strong) NSDictionary *order_count;
@property (nonatomic, strong) NSArray *order_list;

@end


@interface DZGetOrderListModel : LNNetBaseModel

@property (nonatomic, strong) DZOrderListModel *data;

@end




