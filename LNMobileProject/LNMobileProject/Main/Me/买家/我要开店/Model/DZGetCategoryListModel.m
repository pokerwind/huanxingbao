//
//  DZGetCategoryListModel.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/23.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGetCategoryListModel.h"

//@implementation DZCategoryModel
//
//@end

@implementation DZCategoryListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"child":@"DZCategoryListModel"};
}

@end

@implementation DZGetCategoryListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data":@"DZCategoryListModel"};
}

@end
