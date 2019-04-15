//
//  DZGetShopInfoModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/28.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZShopInfoModel : NSObject

@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *shop_type;
@property (strong, nonatomic) NSString *shop_logo;
@property (strong, nonatomic) NSString *shop_real_pic;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *collect_num;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *is_favorite;
@property (strong, nonatomic) NSString *month_goods_count;
@property (strong, nonatomic) NSString *goods_rank;
@property (strong, nonatomic) NSString *goods_rank_num;
@property (strong, nonatomic) NSString *express_rank;
@property (strong, nonatomic) NSString *express_rank_num;
@property (strong, nonatomic) NSString *service_rank;
@property (strong, nonatomic) NSString *service_rank_num;
@property (strong, nonatomic) NSString *good_comment_rate;
@property (strong, nonatomic) NSString *goods_sale_num;
@property (strong, nonatomic) NSString *comment_count;
@property (strong, nonatomic) NSString *buy_again_rate;

@end

@interface DZGetShopInfoModel : LNNetBaseModel

@property (strong, nonatomic) DZShopInfoModel *data;

@end
