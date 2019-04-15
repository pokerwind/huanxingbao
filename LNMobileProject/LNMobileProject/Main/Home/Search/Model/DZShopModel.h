//
// DZShopModel.h(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/15. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "LNNetBaseModel.h"

@interface DZShopModel : NSObject
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *shop_type;
@property (nonatomic, copy) NSString *shop_logo;
@property (nonatomic, copy) NSString *shop_real_pic;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *market_name;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *is_owner;
@property (nonatomic, copy) NSString *click_count;
@property (nonatomic, copy) NSString *month_goods_count;
@property (nonatomic, copy) NSString *goods_counts;
@property (nonatomic, copy) NSString *supplement;
@property (nonatomic, copy) NSString *adress;
@end

@interface DZShopDataModel : NSObject
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *keyword;
@end


@interface DZShopNetModel : LNNetBaseModel
@property (nonatomic, strong) DZShopDataModel *data;
@end
