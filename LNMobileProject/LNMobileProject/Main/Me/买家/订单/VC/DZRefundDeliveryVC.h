//
//  DZRefundDeliveryVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZRefundDeliveryVCDelegate <NSObject>

- (void)didSendSuccess;

@end

@interface DZRefundDeliveryVC : LNBaseVC

@property (nonatomic) BOOL removeVC;//是否移除nav上一个vc
@property (strong, nonatomic) NSString *order_sn;
@property (nonatomic) id <DZRefundDeliveryVCDelegate>delegate;

@end
