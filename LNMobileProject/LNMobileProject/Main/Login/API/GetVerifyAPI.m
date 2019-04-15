//
//  GetVerifyAPI.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/5/25.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import "GetVerifyAPI.h"
#import "LNNetBaseModel.h"

@implementation GetVerifyAPI
- (instancetype)initWithPhone:(NSString *)phone type:(NSInteger)type {
    self = [super init];
    if (self) {
        NSDictionary *dict = @{@"mobile":phone,
                               @"type":@(type)};
        self.requestArgument = dict;
//        self.requestArgument = @{@"code":[dict JSONString]};
    }
    
    return self;
}

- (id)responseProcess:(id)responseObject {
    return [LNNetBaseModel objectWithKeyValues:responseObject];
}

- (NSString *)apiMethodName{
    return @"/Api/PublicApi/smsCode";
}

- (LCRequestMethod)requestMethod{
    return LCRequestMethodPost;
}

@end
