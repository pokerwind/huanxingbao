//
// DZShopCateModel.h(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/12. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "LNNetBaseModel.h"

@interface DZShopCateModel : NSObject
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *cat_name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *cat_id;
@end

@interface DZShopCateNetModel : LNNetBaseModel
@property (nonatomic, strong) NSArray *data;
@end
