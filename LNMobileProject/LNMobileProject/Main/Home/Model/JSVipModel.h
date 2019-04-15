//
//Created by ESJsonFormatForMac on 19/01/28.
//

#import <Foundation/Foundation.h>

@class JSVipData,JSVipList;
@interface JSVipModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) JSVipData *data;

@end
@interface JSVipData : NSObject

@property (nonatomic, copy) NSString *my_vip_level;

@property (nonatomic, strong) NSArray *list;

@end

@interface JSVipList : NSObject

@property (nonatomic, copy) NSString *act_id;

@property (nonatomic, copy) NSString *allow_vip;

@property (nonatomic, copy) NSString *shop_price;

@property (nonatomic, copy) NSString *goods_price;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, assign) NSInteger btn;

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic,copy)NSString *goods_img;

@end

