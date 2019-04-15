//
//  DZCartConfirmModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"
#import "DZGetAddressListModel.h"

@interface DZCartConfirmSizeModel : NSObject

@property (strong, nonatomic) NSString *buy_number;
@property (strong, nonatomic) NSString *goods_spec_key;
@property (strong, nonatomic) NSString *size_name;
@property (strong, nonatomic) NSString *storage;

@end

@interface DZCartConfirmSpecModel : NSObject

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSArray *size;
@property(nonatomic,strong) NSString *spec_name;

@end

@interface DZCartConfirmGoodModel : NSObject

@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *goods_img;
@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *is_selected;
@property (strong, nonatomic) NSString *is_valid;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSArray *spec;
@property(nonatomic,strong) NSString *buy_number;
@property(nonatomic,strong) NSString *spec_name;
@property (nonatomic) BOOL isSelected;

@end

@interface DZCartConfirmShopModel : NSObject

@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *shop_express;
@property (strong, nonatomic) NSArray *goods;
@property(nonatomic,strong) NSString *shop_express_price;
@property (strong, nonatomic) NSArray *goods_list;

@end

@interface DZCartConfirmInfoModel : NSObject

@property (strong, nonatomic) DZMyAddressItemModel *addr_info;
@property (strong, nonatomic) NSString *total_amount;
@property (strong, nonatomic) NSString *total_express;
@property (strong, nonatomic) NSString *total_goods_amount;
@property (strong, nonatomic) NSString *total_goods_num;
@property (strong, nonatomic) NSArray *goods_list;
@property (strong, nonatomic) NSArray *list;

@property (strong, nonatomic) NSString *order_buy_counts;
@property (strong, nonatomic) NSString *order_price;
@property (strong, nonatomic) NSString *final_price;


@property (strong, nonatomic) NSString *order_express_price;




@property (nonatomic, strong) NSString *address_id;
@property (nonatomic, strong) NSString *consignee;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *mobile;
@property (strong, nonatomic) NSString *zipcode;
@property (nonatomic) NSInteger is_default;

@property (nonatomic) BOOL isSelected;


@end

@interface DZCartConfirmModel : LNNetBaseModel

@property (strong, nonatomic) DZCartConfirmInfoModel *data;

@end
