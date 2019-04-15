//
//  DZGetRefundInfoModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/27.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"
#import "DZEMChatUserModel.h"


@interface DZRefundInfoModel : NSObject

@property (strong, nonatomic) NSString *shop_state;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *refund_id;
@property (strong, nonatomic) NSString *add_time;
@property (strong, nonatomic) NSString *refund_type;
@property (strong, nonatomic) NSString *reason;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSString *shop_mobile;
@property (strong, nonatomic) NSString *refund_state;
@property (strong, nonatomic) DZEMChatUserModel *emchat;
@end

@interface DZGetRefundInfoModel : LNNetBaseModel

@property (strong, nonatomic) DZRefundInfoModel *data;

@end
