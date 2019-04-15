//
//  DZCustomerServiceModel.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZCustomerServiceModel : NSObject
@property (nonatomic, copy) NSString *chat_username;
@property (nonatomic, copy) NSString *chat_nickname;
@property (nonatomic, copy) NSString *chat_headpic;
@property(nonatomic,assign) NSInteger has_shop;
@property(nonatomic,strong) NSString *shop_id;
@end

@interface DZCustomerServiceNetModel : LNNetBaseModel
@property (nonatomic, strong) DZCustomerServiceModel *data;
@end
