//
//  DZShopFileVC.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@interface DZShopFileVC : LNBaseVC
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, strong) RACSubject *refreshSubject;
@end
