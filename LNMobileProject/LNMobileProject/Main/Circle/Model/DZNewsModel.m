/**
 * Copyright (c) 山东六牛网络科技有限公司 https://liuniukeji.com
 *
 * @Description
 * @Author         yulianbo   tel:  15269966441
 * @Copyright      Copyright (c) 山东六牛网络科技有限公司 保留所有版权(https://www.liuniukeji.com)
 * @Date
 * @IDE/Editor
 * @Modified By
 */

#import "DZNewsModel.h"
#import "DZGoodsModel.h"

@implementation DZNewsShopInfoModel

@end

@implementation DZNewsModel
+(NSDictionary *)objectClassInArray {
    return @{@"goods_list":@"DZGoodsModel"};
}
@end

@implementation DZNewsNetModel
+(NSDictionary *)objectClassInArray {
    return @{@"data":@"DZNewsModel"};
}
@end
