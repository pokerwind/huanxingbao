//
//  DZGetAllRefundListModel.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/4.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGetAllRefundListModel.h"

@implementation DZRefundListGoodModel

@end

@implementation DZRefundItemModel

+ (NSDictionary *)objectClassInArray{
    return @{@"goods_list":@"DZRefundListGoodModel"};
}

@end

@implementation DZGetAllRefundListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data":@"DZRefundItemModel"};
}

@end
