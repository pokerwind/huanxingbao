//
//Created by ESJsonFormatForMac on 19/02/12.
//

#import <Foundation/Foundation.h>

@class JSShopCartData,JSShopCartList,JSShopCartGoods;
@interface JSShopCartModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) JSShopCartData *data;

@end
@interface JSShopCartData : NSObject

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, copy) NSString *all_pirce;

@end

@interface JSShopCartList : NSObject

@property (nonatomic, copy) NSString *shop_id;

@property (nonatomic, copy) NSString *shop_name;

@property (nonatomic, strong) NSArray *goods;

@end

@interface JSShopCartGoods : NSObject

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *shop_id;

@property (nonatomic, copy) NSString *is_valid;

@property (nonatomic, copy) NSString *shop_name;

@property (nonatomic, copy) NSString *from_shop_id;

@property (nonatomic, copy) NSString *act_id;

@property (nonatomic, copy) NSString *goods_img;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *weight;

@property (nonatomic, copy) NSString *act_type;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *is_selected;

@property (nonatomic, copy) NSString *goods_spec_key;

@property (nonatomic, copy) NSString *cart_id;

@property (nonatomic, copy) NSString *spec_name;

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy) NSString *buy_number;

@end

