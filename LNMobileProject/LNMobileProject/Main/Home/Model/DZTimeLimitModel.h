//
//  DZTimeLimitModel.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"
@interface DZTimeLimitModel : NSObject
@property (nonatomic, assign) NSInteger start_time;
@property (nonatomic, assign) NSInteger end_time;
@property (nonatomic, copy) NSString *goods_img;
/*
 * goods_name
 */
@property (nonatomic,copy)NSString *goods_name;

@property (nonatomic, assign) NSInteger now_time;

/*
 * act_id
 */
@property (nonatomic,copy)NSString *act_id;

/*
 * shop_price
 */
@property (nonatomic,copy)NSString *shop_price;

/*
 * goods_id
 */
@property (nonatomic,copy)NSString *goods_id;

/*
 * now_price
 */
@property (nonatomic,copy)NSString *now_price;


@end

@interface DZTimeLimitNetModel : LNNetBaseModel
@property (nonatomic, strong) NSArray *data;
@end
