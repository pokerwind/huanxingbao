//
//  DZTimeLimitDetailModel.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/12.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZTimeLimitDetailGoodsModel : NSObject
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *shop_price;
@property (nonatomic, copy) NSString *goods_img;
@property (nonatomic, copy) NSString *goods_stock;
@property (nonatomic, copy) NSString *goods_sale;
@property (nonatomic, copy) NSString *activity_price;
@property (nonatomic, copy) NSString *discount;
@property (nonatomic, copy) NSString *act_id;
@property (nonatomic, copy) NSString *retail_amount;
@property (nonatomic, copy) NSString *basic_amount;
@property (nonatomic, strong) RACSubject *buySubject;
@end

@interface DZTimeLimitDetailInfoModel : NSObject
@property (nonatomic, copy) NSString *act_id;
@property (nonatomic, copy) NSString *act_name;
@property (nonatomic, copy) NSString *act_desc;
@property (nonatomic, copy) NSString *act_img;
@property (nonatomic, copy) NSString *act_type;
@property (nonatomic, assign) NSInteger start_time;
@property (nonatomic, assign) NSInteger end_time;
@property (nonatomic, copy) NSString *is_finished;
@property (nonatomic, copy) NSString *discount;
@property (nonatomic, assign) NSInteger now;
@end

@interface DZTimeLimitDetailModel : NSObject
@property (nonatomic, strong) DZTimeLimitDetailInfoModel *info;
@property (nonatomic, strong) NSArray *list;
@end

@interface DZTimeLimitDetailNetModel : LNNetBaseModel
@property (nonatomic, strong) DZTimeLimitDetailModel *data;
@end
