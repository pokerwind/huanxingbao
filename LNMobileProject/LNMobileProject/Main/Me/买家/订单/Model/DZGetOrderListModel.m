//
//  DZGetOrderListModel.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/16.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGetOrderListModel.h"

@implementation DZGetOrderListModel

/*
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID":@"id",
             @"desc":@"description"};
    
}
*/

@end

@implementation DZOrderListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"order_list" : @"DZOrderListItemModel"};
}

@end

@implementation DZOrderListItemModel

+ (NSDictionary *)objectClassInArray{
    return @{@"goods_info" : @"DZGoodInfoModel"};
}

@end

@implementation DZGoodInfoModel

+ (NSDictionary *)objectClassInArray{
    return @{@"spec_list":@"DZOrderDetailSpecModel"};
}

@end

@implementation DZOrderDetailSpecModel

@end

