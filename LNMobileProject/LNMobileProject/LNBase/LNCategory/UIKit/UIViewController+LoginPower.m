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

#import "UIViewController+LoginPower.h"

static const void *kLoginPower = @"lnLoginPower";

@implementation UIViewController (LoginPower)

#pragma mark - BOOL类型的动态绑定
- (BOOL)lnLoginPower {
    return [objc_getAssociatedObject(self, kLoginPower) boolValue];
}

- (void)setLnLoginPower:(BOOL)lnLoginPower {
    objc_setAssociatedObject(self, kLoginPower, [NSNumber numberWithBool:lnLoginPower], OBJC_ASSOCIATION_ASSIGN);
}

@end
