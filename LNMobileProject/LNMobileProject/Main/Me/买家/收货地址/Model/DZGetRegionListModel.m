//
//  DZGetRegionListModel.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGetRegionListModel.h"

@implementation DZRegionModel

 + (NSDictionary *)replacedKeyFromPropertyName{
 return @{@"uid":@"id"};
 
 }

@end

@implementation DZGetRegionListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data":@"DZRegionModel"};
}

@end
