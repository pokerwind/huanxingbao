//
//  DZGetBalanceDetailsModel.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGetBalanceDetailsModel.h"

@implementation DZBalancLogModel

@end

@implementation DZBalanceDetailModel

+ (NSDictionary *)objectClassInArray{
    return @{@"log_list":@"DZBalancLogModel"};
}

@end

@implementation DZGetBalanceDetailsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data":@"DZBalanceDetailModel"};
}

@end
