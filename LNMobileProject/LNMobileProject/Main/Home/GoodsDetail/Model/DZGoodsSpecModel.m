//
// DZGoodsSpecModel.m(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/18. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "DZGoodsSpecModel.h"

@implementation DZGoodsSpecModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"buyCount":@"has_number"};
}
@end

@implementation DZGoodsSpecNetModel
+ (NSDictionary *)objectClassInArray {
    return @{@"data":@"DZGoodsSpecModel"};
}
@end
