//
//  DZDZSellerProblemOrderDetailVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/28.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZSellerProblemOrderDetailVCDelegate <NSObject>

- (void)didDeleteOrder:(NSString *)orderSn;
- (void)didChangeStatus;

@end

@interface DZSellerProblemOrderDetailVC : LNBaseVC

@property (strong, nonatomic) NSString *order_sn;
@property (strong, nonatomic) NSString *order_goods_id;
@property (strong, nonatomic) NSString *shop_state;
@property (strong, nonatomic) NSString *refund_type;
@property (nonatomic) id <DZSellerProblemOrderDetailVCDelegate>delegate;

@end
