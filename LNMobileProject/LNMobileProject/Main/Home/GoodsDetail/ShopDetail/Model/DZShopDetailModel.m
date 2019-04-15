//
// DZShopDetailModel.m(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/12. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "DZShopDetailModel.h"

@implementation DZShopDetailModel
+(NSDictionary *)replacedKeyFromPropertyName {
    return @{@"desc":@"description"};
}
+ (NSDictionary *)objectClassInArray {
    return @{@"cat_info":@"DZCatInfoModel"};
}
@end

@implementation DZShopDetailNetModel

@end

@implementation DZCatInfoModel

@end


