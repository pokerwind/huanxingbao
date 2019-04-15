//
//  DZCartPayVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZCartPayVCDelegate <NSObject>

- (void)didPaySuccess;

@end

@interface DZCartPayVC : LNBaseVC

@property (nonatomic) BOOL needRemoveVC;//进货车点击提交订单后，订单提交成功，跳转到支付页面，这时需要移除订单提交vc。而我的订单页面点击“去付款”则不需要
@property (strong, nonatomic) NSString *orderSN;
@property (strong, nonatomic) NSString *goodsCount;
@property (strong, nonatomic) NSString *goodsPrice;
@property (strong, nonatomic) NSString *expressPrice;
@property (strong, nonatomic) NSString *totalPrice;
@property (nonatomic) id <DZCartPayVCDelegate>delegate;

/*
 * source
 */
@property (nonatomic,assign)NSInteger source;

@end
