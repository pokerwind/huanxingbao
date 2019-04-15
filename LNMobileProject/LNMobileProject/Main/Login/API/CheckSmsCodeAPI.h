//
//  CheckSmsCode.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/15.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LCBaseRequest.h"

@interface CheckSmsCodeAPI : LCBaseRequest<LCAPIRequest>

- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code;

@end
