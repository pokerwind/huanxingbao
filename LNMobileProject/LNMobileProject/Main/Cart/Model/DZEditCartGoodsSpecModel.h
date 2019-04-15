//
//  DZEditCartGoodsSpecModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZCartSpecModel : NSObject

@property (strong, nonatomic) NSString *spec_name;
@property (strong, nonatomic) NSString *store_count;
@property (strong, nonatomic) NSString *spec_key;
@property (strong, nonatomic) NSString *has_number;

@end

@interface DZCartGoodModel : NSObject

@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *pack_price;
@property (strong, nonatomic) NSString *shop_price;
@property (strong, nonatomic) NSString *goods_img;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *is_favorite;
@property (strong, nonatomic) NSString *basic_amount;
@property (strong, nonatomic) NSString *retail_amount;
@property (strong, nonatomic) NSString *allow_mixture;

@end

@interface DZCartGoodsSpecModel : NSObject

@property (strong, nonatomic) DZCartGoodModel *goods_info;
@property (strong, nonatomic) NSArray *goods_spec;
@property(nonatomic,strong) NSArray *shop_comment;
@end

@interface DZEditCartGoodsSpecModel : LNNetBaseModel

@property (strong, nonatomic) DZCartGoodsSpecModel *data;

@end
