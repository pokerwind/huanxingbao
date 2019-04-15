/**
 * Copyright (c) 山东六牛网络科技有限公司 https://liuniukeji.com
 *
 * @Description
 * @Author         yulianbo   tel:  15269966441
 * @Copyright      Copyright (c) 山东六牛网络科技有限公司 保留所有版权(https://www.liuniukeji.com)
 * @Date
 * @IDE/Editor
 * @Modified By
 */

#import "LNBaseVC.h"

@interface LNStatusInfoVC : LNBaseVC
@property (copy, nonatomic) NSString *statusInfo;
@property (weak, nonatomic) IBOutlet UILabel *statusInfoLabel;

@property (assign, nonatomic) NSInteger removeIndex;    // 删除几个 默认一个



@end
