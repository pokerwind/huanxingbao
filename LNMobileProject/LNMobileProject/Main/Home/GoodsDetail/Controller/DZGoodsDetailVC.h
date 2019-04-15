//
//  DZGoodsDetailVC.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/2.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

#import "DZGoodsDetailBottomView.h"

@interface DZGoodsDetailVC : LNBaseVC

@property (nonatomic, copy) NSString *goodsId;
/*
 * 活动id
 */
@property (nonatomic,copy)NSString *act_id;

/*
 * act_type
 */
@property (nonatomic,copy)NSString *act_type;

@property (nonatomic, strong, readonly) UIButton *backButton;

@property (strong, nonatomic, readonly) DZGoodsDetailBottomView *bottomView;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property(nonatomic,strong) NSString *iswodeshiyong;
@property(nonatomic,strong) NSString *order_sn;
@property(nonatomic,strong) NSString *cash_pledge;
@property(nonatomic,strong) NSString *ismianfeishiyong;

- (void)loadData;

@end
