//
//  DZGetGoodListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/28.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZGoodModel : NSObject

@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *goods_img;
@property (strong, nonatomic) NSString *pack_price;
@property (strong, nonatomic) NSString *shop_price;
@property (strong, nonatomic) NSString *click_count;
@property (strong, nonatomic) NSString *sale_num;

@property (nonatomic) BOOL isSelected;//编辑时用作标记

@end

@interface DZGoodListModel : NSObject

@property (strong, nonatomic) NSDictionary *goods_count;
@property (strong, nonatomic) NSArray *goods_list;

@end

@interface DZGetGoodListModel : LNNetBaseModel

@property (strong, nonatomic) DZGoodListModel *data;

@end
