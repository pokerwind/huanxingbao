//
// DZShopGoodsModel.h(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/13. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "LNNetBaseModel.h"
@interface DZShopGoodsModel : NSObject
@property (nonatomic, strong) NSArray *goodsList;
@property (nonatomic, copy) NSString *sort;

@end

@interface DZShopGoodsNetModel : LNNetBaseModel
@property (nonatomic, strong) DZShopGoodsModel *data;
@end
