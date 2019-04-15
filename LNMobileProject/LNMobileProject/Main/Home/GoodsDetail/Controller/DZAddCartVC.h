//
//  DZAddCartVC.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"
#import "DZGoodsDetailNetModel.h"

@interface DZAddCartVC : LNBaseVC
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, strong) DZGoodsDetailModel *model;
@property (nonatomic, assign) BOOL isActivity;
@property (nonatomic, assign) NSString *activityPrice;
@end
