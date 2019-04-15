//
// DZFilterModel.h(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/14. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import <Foundation/Foundation.h>

@interface DZFilterModel : NSObject
@property (nonatomic, assign) NSInteger cat_id;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *attr;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, assign) NSInteger shop_type;
@property (nonatomic, copy) NSString *goods_size;
@property (nonatomic, copy) NSString *min_price;
@property (nonatomic, copy) NSString *max_price;
@property (nonatomic, copy) NSString *pack_num;
@end
