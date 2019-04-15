//
//  DZBailVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/25.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZBailVCDelegate <NSObject>

- (void)bailValueDidChange;

@end

@interface DZBailVC : LNBaseVC

@property (nonatomic) NSInteger shop_type;//店铺类型 1实体店  2工厂店  3网批店
@property (nonatomic) NSInteger audlt_status;//审核状态 0待审核 1拒绝 2审核通过
@property (nonatomic) NSInteger is_pay_bond;//是否缴纳保证金 1是 0否

@property (nonatomic) id <DZBailVCDelegate>delagate;

@end
