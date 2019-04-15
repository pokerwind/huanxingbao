//
//  DZPayVC.h
//  LNMobileProject
//
//  Created by ios on 2017/10/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZPayVCDelegate <NSObject>

- (void)didPaySuccess;

@end

@interface DZPayVC : LNBaseVC

@property (nonatomic) CGFloat price;//支付金额

@property (nonatomic) id <DZPayVCDelegate>delegate;
@property (nonatomic) BOOL needSwitch;//是否需要切换到卖家主页

@end
