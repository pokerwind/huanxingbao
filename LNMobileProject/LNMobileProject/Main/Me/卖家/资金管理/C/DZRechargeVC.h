//
//  DZRechargeVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/25.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZRechargeVCDelegate <NSObject>

- (void)didRechargeSuccess;

@end

@interface DZRechargeVC : LNBaseVC

@property (nonatomic) id <DZRechargeVCDelegate>delegate;

@end
