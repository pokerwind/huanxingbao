//
// DZGoodsCateModel.h(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/14. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "LNNetBaseModel.h"

@interface DZGoodsCateModel : NSObject
@property (nonatomic, assign) NSInteger cat_id;
@property (nonatomic, copy) NSString *cat_name;
@property (nonatomic, assign) NSInteger index;
@end

@interface DZGoodsCateNetModel : LNNetBaseModel
@property (nonatomic, strong) NSArray *data;
@end
