//
// Created by Chenyu Lan on 8/27/14.
// Copyright (c) 2014 Fenbi. All rights reserved.
//

#import "LCProcessFilter.h"
#import "LCBaseRequest.h"
#import "AppDelegate.h"

@implementation LCProcessFilter
/**
 *  统一添加提交参数 统一加工key,lang
 *  统一加工
 *  @param argument NSDictionary
 *  @param queryArgument NSDictionary
 *
 *  @return NSDictionary
 */
- (NSDictionary *)processArgumentWithRequest:(NSDictionary *)argument query:(NSDictionary *)queryArgument{
    // 判断改请求是否忽略 加密
    if([argument objectForKey:@"noAES"]){
        return argument;
    }
    NSMutableDictionary *argumentMutableDict = [[NSMutableDictionary alloc] initWithDictionary:argument];
    if([DPMobileApplication sharedInstance].isLogined)
    {
        DZUserModel *loginUser = [DPMobileApplication sharedInstance].loginUser;
        //[argumentMutableDict setValue:loginUser.userID forKey:@"user_id"];
        if (loginUser.token) {
            [argumentMutableDict setValue:loginUser.token forKey:@"token"];
        }
    }
    return argumentMutableDict;
}
/**
 *  用于统一加工返回数据
 *
 *  @param response response
 *
 *  @return 处理后的response
 */
- (id)processResponseWithRequest:(id)response{
    return response;
//    // 数据解密
//    if (![response isKindOfClass:[NSDictionary class]]) {
//        NSAssert(@"返回数据不是字典",@"");
//    }
//    NSDictionary *responseObject = response ;
//    if ([responseObject objectForKey:@"status"]) {
//        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
//        if ((status == RESPONSE_CODE_TOKENN_LOST ||
//             status == RESPONSE_CODE_TOKENN_INALIDE ||
//             status == RESPONSE_CODE_TOKENN_EXPIRE))
//        {
//            //token过期的接口统一设置超时提示
//            NSString *msg = @"登录超时,请重新登录";
//            if ([responseObject objectForKey:@"msg"]) {
//                msg = [responseObject objectForKey:@"msg"];
//            }
//            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//            [dict setValue:msg forKey:@"msg"];
//            responseObject = dict;
//        }
//    }
//    return responseObject;
}

@end
