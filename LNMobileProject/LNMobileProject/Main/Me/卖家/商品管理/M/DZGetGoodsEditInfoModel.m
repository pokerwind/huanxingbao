//
//  DZGetGoodsEditInfoModel.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/13.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGetGoodsEditInfoModel.h"

@implementation DZGoodsEditImgModel

@end

@implementation DZGoodsEditAttrModel

@end

@implementation DZGoodsEditSizeModel

@end

@implementation DZGoodsEditColorModel

@end

@implementation DZGoodsEditInfoModel

+ (NSDictionary *)objectClassInArray{
    return @{@"selected_color":@"DZGoodsEditColorModel", @"selected_size":@"DZGoodsEditSizeModel", @"selected_attr":@"DZGoodsEditAttrModel", @"img_list":@"DZGoodsEditImgModel"};
}

@end

@implementation DZGetGoodsEditInfoModel

@end
