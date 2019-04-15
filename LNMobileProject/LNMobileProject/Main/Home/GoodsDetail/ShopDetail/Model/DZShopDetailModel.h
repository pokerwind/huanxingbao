//
// DZShopDetailModel.h(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/12. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "LNNetBaseModel.h"
#import "DZShopFileModel.h"
@class DZCatInfoModel;
@interface DZShopDetailModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *buy_again_rate;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *collect_num;
@property (nonatomic, copy) NSString *comment_count;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *express_rank;
@property (nonatomic, copy) NSString *express_rank_num;
@property (nonatomic, copy) NSString *good_comment_rate;
@property (nonatomic, copy) NSString *goods_rank;
@property (nonatomic, copy) NSString *goods_rank_num;
@property (nonatomic, copy) NSString *goods_sale_num;
@property (nonatomic, copy) NSString *is_favorite;
@property (nonatomic, copy) NSString *month_goods_count;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *service_rank;
@property (nonatomic, copy) NSString *service_rank_num;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *shop_logo;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *shop_real_pic;
@property (nonatomic, copy) NSString *shop_type;
@property (nonatomic, copy) NSString *user_mobile;
@property (nonatomic, copy) NSString *allow_return;
@property(nonatomic,assign) CGFloat shop_like_rate;
//@property(nonatomic,assign) NSInteger comment_count;


@property (nonatomic,copy)NSString *has_focus;
@property (nonatomic, copy) NSString *frozen_bond;
@property (nonatomic, strong) DZShopGradeModel *shop_grade;

/*
 * 分类
 */
@property (nonatomic,strong)NSArray *cat_info;

@end

@interface DZCatInfoModel : NSObject
@property (nonatomic, copy) NSString *cat_id;
@property (nonatomic, copy) NSString *cat_name;
@end

@interface DZShopDetailNetModel : LNNetBaseModel
@property (nonatomic, strong) DZShopDetailModel *data;
@end
