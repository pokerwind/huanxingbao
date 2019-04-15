//
//  DZProblemOrderDetailVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/27.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DZProblemOrderDetailVCDelegate <NSObject>

- (void)didRevokeOrder;

@end

@interface DZProblemOrderDetailVC : LNBaseVC

@property (strong, nonatomic) NSString *order_sn;
@property (strong, nonatomic) NSString *order_goods_id;
@property (nonatomic) id delegate;

@end
