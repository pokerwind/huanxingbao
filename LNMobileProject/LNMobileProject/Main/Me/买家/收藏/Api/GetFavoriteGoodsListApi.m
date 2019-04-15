//
//  GetFavoriteGoodsListApi.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/16.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "GetFavoriteGoodsListApi.h"

#import "DPMobileApplication.h"

#import "DZGetOrderListModel.h"

@implementation GetFavoriteGoodsListApi

- (instancetype)initWithPage:(NSInteger)page{
    self = [super init];
    
    if (self) {
        NSDictionary *dict = @{@"p":@(page)};
        self.requestArgument = dict;
    }
    
    return self;
}

- (NSString *)apiMethodName{
    return @"/Api/UserCenterApi/getFavoriteGoodsList";
}

- (LCRequestMethod)requestMethod{
    return LCRequestMethodPost;
}

- (void)setPage:(NSInteger)page{
    NSDictionary *dict = @{@"p":@(page)};
    self.requestArgument = dict;
}

@end
