//
//  DZGetCartListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/31.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZCartListGoodSpecSizeModel : NSObject

@property (strong, nonatomic) NSString *size_name;
@property (strong, nonatomic) NSString *storage;
@property (strong, nonatomic) NSString *buy_number;
@property (strong, nonatomic) NSString *goods_spec_key;

@end

@interface DZCartListGoodSpecModel : NSObject

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSArray *size;

@end

@interface DZCartListGoodModel : NSObject

@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *goods_img;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *is_valid;
@property (strong, nonatomic) NSString *buy_total_number;
@property (strong, nonatomic) NSArray *spec;
@property (nonatomic) BOOL isSelected;

@end

@interface DZCartListModel : NSObject

@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSArray *goods;

@end

@interface DZGetCartListModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
