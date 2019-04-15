//
// DZGoodsSpecModel.h(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/18. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "LNNetBaseModel.h"

@interface DZGoodsSpecModel : NSObject
@property (nonatomic, copy) NSString *spec_name;
@property (nonatomic, copy) NSString *store_count;
@property (nonatomic, copy) NSString *spec_key;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *pack_price;
@property (nonatomic, assign) NSInteger buyCount;
//@property (nonatomic, assign) NSInteger has_number;
@end

@interface DZGoodsSpecNetModel : LNNetBaseModel
@property (nonatomic, strong) NSArray *data;
@end
