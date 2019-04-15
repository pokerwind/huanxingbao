//
//  DZGetCartListModel.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/31.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGetCartListModel.h"

@implementation DZCartListGoodSpecSizeModel

@end

@implementation DZCartListGoodSpecModel

+ (NSDictionary *)objectClassInArray{
    return @{@"size":@"DZCartListGoodSpecSizeModel"};
}

@end

@implementation DZCartListGoodModel

+ (NSDictionary *)objectClassInArray{
    return @{@"spec":@"DZCartListGoodSpecModel"};
}

@end

@implementation DZCartListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"goods":@"DZCartListGoodModel"};
}

@end

@implementation DZGetCartListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data":@"DZCartListModel"};
}

@end
