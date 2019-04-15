//
//  DZGetBalanceModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZBalanceModel : NSObject

@property (strong, nonatomic) NSString *available_money;
@property (strong, nonatomic) NSString *income;
@property (strong, nonatomic) NSString *consume;
@property(nonatomic,strong) NSString *warehouse_money;
@end

@interface DZGetBalanceModel : LNNetBaseModel

@property (nonatomic, strong) DZBalanceModel *data;

@end
