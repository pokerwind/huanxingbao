//
//  DZGetAddressListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/18.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZGetAddressListModel : LNNetBaseModel

@property (nonatomic, strong) NSArray *data;

@end

@interface DZMyAddressItemModel : NSObject

@property (nonatomic, strong) NSString *address_id;
@property (nonatomic, strong) NSString *consignee;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *mobile;
@property (strong, nonatomic) NSString *zipcode;
@property (nonatomic) NSInteger is_default;

@property (nonatomic) BOOL isSelected;

@end
