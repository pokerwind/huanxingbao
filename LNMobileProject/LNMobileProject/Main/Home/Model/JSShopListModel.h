//
//Created by ESJsonFormatForMac on 19/01/29.
//

#import <Foundation/Foundation.h>

@class JSShopListData;
@interface JSShopListModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) NSArray *data;

@end
@interface JSShopListData : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *shop_real_pic;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *distance;

@property (nonatomic, copy) NSString *address_detail;

@property (nonatomic, copy) NSString *shop_id;

@property (nonatomic, copy) NSString *shop_name;

@property (nonatomic, copy) NSString *shop_logo;

@end

