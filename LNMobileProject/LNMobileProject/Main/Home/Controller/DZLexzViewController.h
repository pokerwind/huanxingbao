//
//  DZLexzViewController.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/24.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface DZLexzViewController : LNBaseVC
/*
 * source 1.为乐享赚  2.礼包兑换  3.会员权益 4.免费试用 5.限时活动
 */
@property (nonatomic,assign)NSInteger source;
@property(nonatomic,strong) NSString *order_sn;
@end

NS_ASSUME_NONNULL_END
