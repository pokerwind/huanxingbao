//
//Created by ESJsonFormatForMac on 19/01/17.
//

#import "DZGoodsDetailNetModel.h"
@implementation DZGoodsDetailNetModel

@end

@implementation DZGoodsDetailModel

+ (NSDictionary *)objectClassInArray{
    return @{@"goods_spec" : [DZGoodsShopSpecModel class], @"goods_gallery" : [DZGoodsGalleryItemModel class], @"goods_attr" : [DZGoodsAttrItemModel class], @"goods_desc" : [DZGoodsShopDescModel class]};
}

@end


@implementation DZGoodsShopInfoModel

@end


@implementation DZGoodsInfoModel

@end


@implementation DZGoodsShopSpecModel

+ (NSDictionary *)objectClassInArray{
    return @{@"item_array" : [GoodsItem_Array class]};
}

@end


@implementation GoodsItem_Array

@end


@implementation DZGoodsGalleryItemModel

@end


@implementation DZGoodsAttrItemModel

@end


@implementation DZGoodsShopDescModel

@end


