//
//  DZLoginAPI.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/15.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LoginAPI.h"
#import "DZLoginModel.h"

@implementation LoginAPI

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password{
    self = [super init];
    if (self) {
        NSDictionary *dict = @{@"username":username,
                               @"password":password};
        self.requestArgument = dict;
    }
    
    return self;
}

- (id)responseProcess:(id)responseObject {
    return [DZLoginModel objectWithKeyValues:responseObject];
}

- (NSString *)apiMethodName{
    return @"/Api/PublicApi/login";
}

- (LCRequestMethod)requestMethod{
    return LCRequestMethodPost;
}

@end
