//
//  DZGoodsModel.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZGoodsModel : NSObject
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *pack_price;
@property (nonatomic, copy) NSString *shop_price;
@property (nonatomic, copy) NSString *user_price;
@property (nonatomic, copy) NSString *goods_img;
@property (nonatomic, copy) NSString *sale_num;
@property (nonatomic, copy) NSString *from_shop_id;
@property (nonatomic, copy) NSString *basic_amount;
@property (nonatomic, assign) BOOL isSelected;
@end


@interface DZGoodsNetModel : LNNetBaseModel
@property (nonatomic, strong) NSArray *data;
@end
