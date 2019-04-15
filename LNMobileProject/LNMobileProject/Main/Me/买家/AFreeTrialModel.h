//
//  AFreeTrialModel.h
//  LNMobileProject
//
//  Created by 童浩 on 2019/3/2.
//  Copyright © 2019 Liuniu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AFreeTrialModel : NSObject
@property(nonatomic,strong) NSString *order_goods_id;
@property(nonatomic,strong) NSString *order_sn;
@property(nonatomic,strong) NSString *goods_id;
@property(nonatomic,strong) NSString *act_id;
@property(nonatomic,strong) NSString *order_return_id;
@property(nonatomic,strong) NSString *order_return_status;
@property(nonatomic,strong) NSString *final_price;
@property(nonatomic,strong) NSString *goods_img;
@property(nonatomic,strong) NSString *goods_name;

@property(nonatomic,strong) NSString *goods_spec_value;
@property(nonatomic,strong) NSString *order_id;
@property(nonatomic,strong) NSString *order_status;
@property(nonatomic,strong) NSString *pay_status;
@property(nonatomic,strong) NSString *is_show_cunliu;
@end

