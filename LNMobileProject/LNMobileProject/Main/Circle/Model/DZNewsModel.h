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

#import <Foundation/Foundation.h>
#import "LNNetBaseModel.h"

@interface DZNewsShopInfoModel : NSObject
@property(nonatomic,copy) NSString *shop_id;
@property(nonatomic,copy) NSString *shop_name;
@property(nonatomic,copy) NSString *shop_logo;
@end

@interface DZNewsModel : NSObject
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *shop_id;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *add_time;
@property(nonatomic,strong) NSArray *goods_list;
@property(nonatomic,strong) DZNewsShopInfoModel *shop_info;
@property(nonatomic,copy) NSString *favorite_shop;
@property(nonatomic,assign) BOOL isShowAll;
@end


@interface DZNewsNetModel : LNNetBaseModel
@property (nonatomic, strong) NSArray *data;
@end
