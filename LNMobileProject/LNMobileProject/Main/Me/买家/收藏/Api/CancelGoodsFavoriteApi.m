//
//  CancelGoodsFavoriteApi.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/17.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "CancelGoodsFavoriteApi.h"
#import "DPMobileApplication.h"

@implementation CancelGoodsFavoriteApi

- (instancetype)initWithIds:(NSString *)ids{
    self = [super init];
    
    if (self) {
        NSDictionary *dict = @{@"ids":ids};
        self.requestArgument = dict;
    }
    
    return self;
}

- (id)responseProcess:(id)responseObject {
    return [LNNetBaseModel objectWithKeyValues:responseObject];
}

- (NSString *)apiMethodName{
    return @"/Api/UserCenterApi/cancelGoodsFavorite";
}

- (LCRequestMethod)requestMethod{
    return LCRequestMethodPost;
}

@end
