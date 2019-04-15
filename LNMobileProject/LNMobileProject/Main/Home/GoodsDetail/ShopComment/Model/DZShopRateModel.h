//
// DZShopRateModel.h(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/13. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "LNNetBaseModel.h"

@interface DZShopRateModel : NSObject
@property (nonatomic, copy) NSString *goods_rank;
@property (nonatomic, copy) NSString *express_rank;
@property (nonatomic, copy) NSString *service_rank;
@property (nonatomic, copy) NSString *favorableRate;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *likeCount;
@property (nonatomic, copy) NSString *medCount;
@property (nonatomic, copy) NSString *lowCount;
@property (nonatomic, copy) NSString *imgCount;
@property (nonatomic, copy) NSString *reviewCount;
@end

@interface DZShopRateNetModel : LNNetBaseModel
@property (nonatomic, strong) DZShopRateModel *data;
@end
