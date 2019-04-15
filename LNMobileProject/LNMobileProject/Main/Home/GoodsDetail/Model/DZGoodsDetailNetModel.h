//
//Created by ESJsonFormatForMac on 19/01/17.
//

#import <Foundation/Foundation.h>

@class DZGoodsDetailModel,DZGoodsShopInfoModel,DZGoodsInfoModel,DZGoodsShopSpecModel,GoodsItem_Array,DZGoodsGalleryItemModel,DZGoodsAttrItemModel,DZGoodsShopDescModel;
@interface DZGoodsDetailNetModel : LNNetBaseModel

//@property (nonatomic, assign) NSInteger status;
//
//@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) DZGoodsDetailModel *data;

@end
@interface DZGoodsDetailModel : NSObject

@property (nonatomic, strong) DZGoodsShopInfoModel *shop_info;

@property (nonatomic, strong) NSArray *goods_gallery;

@property (nonatomic, strong) NSArray *goods_attr;

@property (nonatomic, strong) NSArray *goods_spec;

@property (nonatomic, strong) DZGoodsInfoModel *goods_info;

@property (nonatomic, strong) NSArray *goods_desc;
@property (nonatomic, strong) NSDictionary *shop_comment;

@end

@interface DZGoodsShopInfoModel : NSObject

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *express_rank;

@property (nonatomic, copy) NSString *service_rank;

@property (nonatomic, copy) NSString *rank;

@property (nonatomic, copy) NSString *shop_id;

@property (nonatomic, copy) NSString *shop_name;

@property (nonatomic, copy) NSString *shop_logo;

@property (nonatomic, copy) NSString *province;

@end

@interface DZGoodsInfoModel : NSObject

@property (nonatomic, copy) NSString *is_on_sale;

@property (nonatomic, copy) NSString *act_type;

@property (nonatomic, copy) NSString *weight;

@property (nonatomic, assign) NSInteger click_count;

@property (nonatomic, copy) NSString *storage;

@property (nonatomic, copy) NSString *market_price;

@property (nonatomic, assign) NSInteger is_favorite;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *shop_price;

@property (nonatomic, copy) NSString *get_points;

@property (nonatomic, copy) NSString *sale_num;

@property (nonatomic, copy) NSString *cat_id;

@property (nonatomic, copy) NSString *goods_img;

@property (nonatomic, copy) NSString *comment_num;

@property (nonatomic, copy) NSString *act_id;

@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy) NSString *collect_num;

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *update_time;

@property (nonatomic, copy) NSString *is_free_shipping;

@property (nonatomic, assign) NSInteger day_ago;

@property (nonatomic, copy) NSString *goods_sn;

@property (nonatomic, copy) NSString *shop_id;

@end

@interface DZGoodsShopSpecModel : NSObject

@property (nonatomic, copy) NSString *shop_id;

@property (nonatomic, copy) NSString *spec_id;

@property (nonatomic, strong) NSArray *item_array;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *type_id;

@property (nonatomic, copy) NSString *spec_name;

@end

@interface GoodsItem_Array : NSObject

@property (nonatomic, copy) NSString *spec_item_name;

@property (nonatomic, copy) NSString *spec_item_id;

@end

@interface DZGoodsGalleryItemModel : NSObject

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *img_id;

@property (nonatomic, copy) NSString *image_path;

@property (nonatomic, copy) NSString *is_default;

/*
 * isLoaded
 */
@property (nonatomic,assign)BOOL isLoaded;

@end

@interface DZGoodsAttrItemModel : NSObject

@property (nonatomic, copy) NSString *attr_id;

@property (nonatomic, copy) NSString *attr_name;

@property (nonatomic, copy) NSString *attr_value;

@end

@interface DZGoodsShopDescModel : NSObject

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *img_id;

@property (nonatomic, copy) NSString *image_path;

@property (nonatomic, copy) NSString *is_default;

/*
 * isLoaded
 */
@property (nonatomic,assign)BOOL isLoaded;

@end

