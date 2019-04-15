//
// DZShopCommentModel.m(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/14. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "DZShopCommentModel.h"

@implementation DZShopCommentReviewModel

@end

@implementation DZShopCommentImageModel

@end


@implementation DZShopCommentModel
+(NSDictionary *)objectClassInArray {
    return @{@"comment_img":@"DZShopCommentImageModel"};
}
@end

@implementation DZShopCommentNetModel
+(NSDictionary *)objectClassInArray {
    return @{@"data":@"DZShopCommentModel"};
}
@end
