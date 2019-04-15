//
// DZShopFileModel.h(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/13. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "LNNetBaseModel.h"

@interface DZShopGradeModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger num;
@end

@interface DZShopFileCommentModel : NSObject
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *express_rank;
@property (nonatomic, copy) NSNumber *favorableRate;
@property (nonatomic, copy) NSString *goods_rank;
@property (nonatomic, copy) NSString *imgCount;
@property (nonatomic, copy) NSString *likeCount;
@property (nonatomic, copy) NSString *lowCount;
@property (nonatomic, copy) NSString *medCount;
@property (nonatomic, copy) NSNumber *reviewCount;
@property (nonatomic, copy) NSString *service_rank;
@end


@interface DZShopFileModel : NSObject
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *collect_num;
@property (nonatomic, strong) DZShopFileCommentModel *comment;
@property (nonatomic, copy) NSString *contacts_name;
//@property (nonatomic, copy) NSString *express_rank;
//@property (nonatomic, copy) NSNumber *express_rank_num;
@property (nonatomic, copy) NSString *good_comment_rate;
//@property (nonatomic, copy) NSString *goods_rank;
//@property (nonatomic, copy) NSNumber *goods_rank_num;
@property (nonatomic, copy) NSString *is_favorite;
@property (nonatomic, copy) NSNumber *month_goods_count;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *refund_num;
@property (nonatomic, copy) NSString *fans;
//@property (nonatomic, copy) NSString *service_rank;
//@property (nonatomic, copy) NSNumber *service_rank_num;
@property (nonatomic, copy) NSString *shop_bond;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *shop_logo;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *shop_real_pic;
@property (nonatomic, copy) NSString *shop_type;
@property (nonatomic, copy) NSString *user_mobile;
@property (nonatomic, strong) DZShopGradeModel *shop_grade;
@end

@interface DZShopFileNetModel : LNNetBaseModel
@property (nonatomic, strong) DZShopFileModel *data;
@end
