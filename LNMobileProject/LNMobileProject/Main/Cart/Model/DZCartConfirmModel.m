//
//  DZCartConfirmModel.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCartConfirmModel.h"

@implementation DZCartConfirmSizeModel

@end

@implementation DZCartConfirmSpecModel

+ (NSDictionary *)objectClassInArray{
    return @{@"size":@"DZCartConfirmSizeModel"};
}

@end

@implementation DZCartConfirmGoodModel

+ (NSDictionary *)objectClassInArray{
    return @{@"spec":@"DZCartConfirmSpecModel"};
}

@end

@implementation DZCartConfirmShopModel

+ (NSDictionary *)objectClassInArray{
    return @{@"goods":@"DZCartConfirmGoodModel",@"goods_list":@"DZCartConfirmGoodModel"};
}


@end

@implementation DZCartConfirmInfoModel

+ (NSDictionary *)objectClassInArray{
    return @{@"goods_list":@"DZCartConfirmShopModel",@"list":@"DZCartConfirmShopModel"};
}

@end

@implementation DZCartConfirmModel

@end
