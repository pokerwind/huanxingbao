//
//  DZGetUserBankCardListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZUserBankCardModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *bank_name;
@property (strong, nonatomic) NSString *bank_num;
@property (strong, nonatomic) NSString *cardholder;

@property (nonatomic) BOOL isSelected;

@end

@interface DZGetUserBankCardListModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
