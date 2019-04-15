//
//  DZGetEditShopInfoModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/10/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZGradeModel : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *num;

@end

@interface DZEditShopInfoModel : NSObject

@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *shop_type;
@property (nonatomic, strong) NSString *shop_type_name;
@property (nonatomic, strong) NSString *shop_logo;
@property (nonatomic, strong) NSString *shop_real_pic;
@property (nonatomic, strong) NSString *shop_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *contacts_name;
@property (nonatomic, strong) NSString *user_mobile;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *basic_amount;
@property (nonatomic, strong) NSString *allow_mixture;
@property (nonatomic, strong) NSString *allow_return;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *retail_amount;
@property (nonatomic, strong) NSString *is_bond;
@property (nonatomic, strong) NSString *shop_score;
@property (nonatomic, strong) NSString *category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *market_name;
@property (nonatomic, strong) NSString *floor_number;
@property (nonatomic, strong) NSString *room_number;
@property (nonatomic, strong) NSString *company_name;
@property (nonatomic, strong) NSString *company_website;
@property (nonatomic, strong) NSString *reg_number;
@property (nonatomic, strong) NSString *factory_pic;
@property (nonatomic, strong) NSString *plant_pic;
@property (nonatomic, strong) NSString *license;
@property (nonatomic, strong) DZGradeModel *shop_grade;

@end

@interface DZGetEditShopInfoModel : LNNetBaseModel

@property (nonatomic, strong) DZEditShopInfoModel *data;

@end
