//
//  DZSubmitOrderVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@interface DZSubmitOrderVC : LNBaseVC

@property (strong, nonatomic) NSArray *goodIds;

/*
 * source 为1则为立即购买 其余为清购物车
 */
@property (nonatomic,assign)NSInteger source;



@property (strong, nonatomic) NSArray *shopIds;

@property (strong, nonatomic) NSArray *cart_ids;

//======================立即购买
/*
 * 商品id
 */
@property (nonatomic,copy)NSString *goodId;

@property (nonatomic,copy)NSString *from_shop_id;

@property (nonatomic,copy)NSString *buy_number;

@property (nonatomic,copy)NSString *goods_spec_key;

@property (nonatomic,copy)NSString *act_id;

@property (nonatomic,copy)NSString *act_type;

@property(nonatomic,strong) NSString *order_sn;

@property(nonatomic,strong) NSString *iswodeshiyong;

@property(nonatomic,strong) NSString *goods_price;

@end
