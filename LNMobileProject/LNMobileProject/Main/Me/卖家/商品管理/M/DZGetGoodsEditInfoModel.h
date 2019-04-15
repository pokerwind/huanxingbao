//
//  DZGetGoodsEditInfoModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/13.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZGoodsEditImgModel : NSObject

@property (strong, nonatomic) NSString *img_id;
@property (strong, nonatomic) NSString *image_path;
@property (strong, nonatomic) NSString *is_default;

@end

@interface DZGoodsEditAttrModel : NSObject

@property (strong, nonatomic) NSString *attr_id;
@property (strong, nonatomic) NSString *attr_value;

@end

@interface DZGoodsEditSizeModel : NSObject

@property (strong, nonatomic) NSString *size_id;
@property (strong, nonatomic) NSString *size_name;

@end

@interface DZGoodsEditColorModel : NSObject

@property (strong, nonatomic) NSString *color_id;
@property (strong, nonatomic) NSString *color_name;

@end

@interface DZGoodsEditInfoModel : NSObject

@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *pack_price;
@property (strong, nonatomic) NSString *shop_price;
@property (strong, nonatomic) NSString *cat_id;
@property (strong, nonatomic) NSString *goods_description;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *cat_name;
@property (strong, nonatomic) NSArray *selected_color;
@property (strong, nonatomic) NSArray *selected_size;
@property (strong, nonatomic) NSArray *selected_attr;
@property (strong, nonatomic) NSMutableArray *img_list;
@property (strong, nonatomic) NSString *is_made;

@end

@interface DZGetGoodsEditInfoModel : LNNetBaseModel

@property (strong, nonatomic) DZGoodsEditInfoModel *data;

@end
