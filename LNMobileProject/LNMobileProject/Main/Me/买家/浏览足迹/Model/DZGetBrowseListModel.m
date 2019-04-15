//
//  DZGetBrowseListModel.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/18.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGetBrowseListModel.h"

@implementation DZGetBrowseListModel

+ (NSDictionary *)objectClassInArray {
    return @{@"data":@"DZBrowseListGroupModel"};
}

@end

@implementation DZBrowseListGroupModel

+ (NSDictionary *)objectClassInArray {
    return @{@"goods_list":@"DZBrowseListItemModel"};
}

@end

@implementation DZBrowseListItemModel

@end
