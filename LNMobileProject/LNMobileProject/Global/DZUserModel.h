//
//  DZUserModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/15.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZUserModel : NSObject


/*
 * lat
 */
@property (nonatomic,assign)CGFloat lat;

/*
 * lng
 */
@property (nonatomic,assign)CGFloat lng;


@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *head_pic;
@property (nonatomic, strong) NSString *disabled;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *weixin;
@property (nonatomic, strong) NSString *rank_id;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *user_money;
@property (nonatomic, strong) NSString *frozen_money;
@property (nonatomic, assign) NSString *shop_id;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) NSInteger is_shop;

@property (strong, nonatomic) NSString *register_time;
@property (strong, nonatomic) NSString *points;
@property (strong, nonatomic) NSString *user_level;

@property (strong, nonatomic) NSString *audit_status;//店铺审核状态

@property (strong, nonatomic) NSString *pay_password;

@property (copy, nonatomic) NSString *emchat_username;
@property (copy, nonatomic) NSString *emchat_password;

@end
