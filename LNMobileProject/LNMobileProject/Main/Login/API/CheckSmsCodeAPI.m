//
//  CheckSmsCode.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/15.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "CheckSmsCodeAPI.h"

@implementation CheckSmsCodeAPI

- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code{
    self = [super init];
    if (self) {
        NSDictionary *dict = @{@"mobile":mobile,
                               @"sms_code":code};
        self.requestArgument = dict;
    }
    return self;
}

- (id)responseProcess:(id)responseObject {
    return [LNNetBaseModel objectWithKeyValues:responseObject];
}

- (NSString *)apiMethodName{
    return @"/Api/PublicApi/checkSmsCode";
}

- (LCRequestMethod)requestMethod{
    return LCRequestMethodPost;
}

@end
