//
// DZGoodsAttrModel.m(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/14. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "DZGoodsAttrModel.h"

@implementation DZGoodsAttrValueModel

@end

@implementation DZGoodsAttrModel
+ (NSDictionary *)objectClassInArray {
    return @{@"value_list":@"DZGoodsAttrValueModel"};
}
@end

@implementation DZGoodsAttrNetModel
+ (NSDictionary *)objectClassInArray {
    return @{@"data":@"DZGoodsAttrModel"};
}
@end
