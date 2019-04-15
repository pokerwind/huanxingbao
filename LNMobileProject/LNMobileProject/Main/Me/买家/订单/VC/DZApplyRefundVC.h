//
//  DZApplyRefundVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZApplyRefundVCDelegate <NSObject>

- (void)didSubmitRefund;

@end

@interface DZApplyRefundVC : LNBaseVC

@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *order_goods_id;
@property (strong, nonatomic) NSString *order_sn;
@property (nonatomic) BOOL canReturnGood;

@property (nonatomic) id <DZApplyRefundVCDelegate>delegate;

@end
