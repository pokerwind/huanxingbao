//
//  DZFavoriteGoodsListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/17.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZFavoriteGoodsListModel : LNNetBaseModel

@property (nonatomic, strong) NSArray *data;

@end

@interface DZGoodsCollectionModel : NSObject

@property (nonatomic, assign) NSInteger favorite_id;
@property (nonatomic, assign) NSInteger goods_id;
@property (nonatomic, strong) NSString *goods_img;
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *pack_price;
@property (nonatomic, strong) NSString *shop_price;

@property (nonatomic, assign) BOOL selected;

@end
