//
// DZShopCommentModel.h(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/14. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "LNNetBaseModel.h"

@interface DZShopCommentReviewModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *add_time;
@end

@interface DZShopCommentImageModel : NSObject
@property (nonatomic, copy) NSString *img_url;
@end

@interface DZShopCommentModel : NSObject
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, strong) NSArray *img_comment_array;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *nickname;
@property(nonatomic,strong) NSString *reply_content;

@property (nonatomic, strong) DZShopCommentReviewModel *review;
@end

@interface DZShopCommentNetModel : LNNetBaseModel
@property (nonatomic,strong) NSArray *data;
@end
