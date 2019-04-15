//
// DZGoodsAttrModel.h(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/14. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "LNNetBaseModel.h"

@interface DZGoodsAttrValueModel : NSObject
@property (nonatomic, copy) NSString *attr_value;
@end

@interface DZGoodsAttrModel : NSObject
@property (nonatomic, copy) NSString *attr_id;
@property (nonatomic, copy) NSString *attr_name;
@property (nonatomic, strong) NSArray *value_list;
@end

@interface DZGoodsAttrNetModel : LNNetBaseModel
@property (nonatomic, strong) NSArray *data;
@end
