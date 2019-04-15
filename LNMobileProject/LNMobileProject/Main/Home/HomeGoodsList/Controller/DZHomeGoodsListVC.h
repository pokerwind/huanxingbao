//
//  DZHomeGoodsListVC.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@interface DZHomeGoodsListVC : LNBaseVC
@property (nonatomic, strong) RACSubject *refreshSubject;
@property (nonatomic, strong) RACSubject *clickSubject;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *adArray;
/*
 * souce
 */
@property (nonatomic,assign)NSInteger source;

@end
