//
//  LNetWorkAPI.m
//  MobileProject
//
//  Created by 云网通 on 2017/1/13.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "LNetWorkAPI.h"
@interface LNetWorkAPI ()
@property (strong , nonatomic) NSString *url;
@property (assign , nonatomic) LCRequestMethod method;
@property (assign , nonatomic) BOOL ignoreUnified;
@property (assign , nonatomic) BOOL isuseCustomApiMethodName;
@end
@implementation LNetWorkAPI

-(instancetype) initWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
        self.url = url;
        self.method = LCRequestMethodPost;
        self.ignoreUnified = NO;
        self.isuseCustomApiMethodName = NO;
       
    }
    return self;
}
-(instancetype) initWithUrl:(NSString *)url parameters:(NSDictionary *) param {
    self = [super init];
    if (self) {
        
        NSMutableDictionary *par = [param mutableCopy];
        [par setObject:[DPMobileApplication sharedInstance].loginUser.token forKey:@"token"];
        NSMutableDictionary *dict;
        if (param != nil) {
            NSLog(@">>>>>>>==%@",[NSString convertToJsonData:par]);
            dict = [NSMutableDictionary dictionaryWithObject:[NSString convertToJsonData:par] forKey:@"code"];
        }
        self.requestArgument = dict;
        self.url = url;
        self.ignoreUnified = NO;
        self.method = LCRequestMethodPost;
        self.isuseCustomApiMethodName = NO;
        
    }
    return self;
}
-(instancetype) initWithUrl:(NSString *)url parameters:(NSDictionary *) param method:(LCRequestMethod )method{
    self = [super init];
    if (self) {
        NSMutableDictionary *par = [param mutableCopy];
        [par setObject:[DPMobileApplication sharedInstance].loginUser.token forKey:@"token"];
        NSMutableDictionary *dict;
        if (param != nil) {
            dict = [NSMutableDictionary dictionaryWithObject:[NSString convertToJsonData:par] forKey:@"code"];
        }
        self.requestArgument = dict;
        self.url = url;
        self.method = (method);
        self.ignoreUnified = NO;
        self.isuseCustomApiMethodName = NO;
    }
    return self;

}
-(instancetype) initWithUrl:(NSString *)url parameters:(NSDictionary *) param method:(LCRequestMethod )method ignoreUnified :(BOOL)ignoreUnified{
    self = [super init];
    if (self) {
        NSMutableDictionary *par = [param mutableCopy];
        [par setObject:[DPMobileApplication sharedInstance].loginUser.token forKey:@"token"];
        NSMutableDictionary *dict;
        if (param != nil) {
            dict = [NSMutableDictionary dictionaryWithObject:[NSString convertToJsonData:par] forKey:@"code"];
        }
        self.requestArgument = dict;
        self.url = url;
        self.method = (method);
        self.ignoreUnified = ignoreUnified;
        self.isuseCustomApiMethodName = NO;
    }
    return self;
}

-(instancetype) initWithUrl:(NSString *)url parameters:(NSDictionary *) param method:(LCRequestMethod )method isuseCustomApiMethodName :(BOOL)isuseCustomApiMethodName {
    self = [super init];
    if (self) {
        NSMutableDictionary *par = [param mutableCopy];
        [par setObject:[DPMobileApplication sharedInstance].loginUser.token forKey:@"token"];
        NSMutableDictionary *dict;
        if (param != nil) {
             dict = [NSMutableDictionary dictionaryWithObject:[NSString convertToJsonData:par] forKey:@"code"];
        }
        self.requestArgument = dict;
        self.url = url;
        self.method = (method);
        self.ignoreUnified = NO;
        self.isuseCustomApiMethodName = isuseCustomApiMethodName;
    }
    
    return self;

}
// 接口地址
- (NSString *)apiMethodName{
    return [NSString stringWithFormat:@"%@",self.url];
}

// 请求方式
- (LCRequestMethod)requestMethod{
    return self.method;
}

// 是否缓存数据
- (BOOL)cacheResponse{
    return NO;
}

- (id)responseProcess:(id)responseObject{
    //BaseModel *baseModel = [BaseModel mj_objectWithKeyValues:responseObject];
    return responseObject;
}

// 忽略统一的 Response 加工
- (BOOL)ignoreUnifiedResponseProcess{
    return self.ignoreUnified;
}

- (BOOL)useCustomApiMethodName{
    return self.isuseCustomApiMethodName;
}

- (BOOL)removesKeysWithNullValues{
    return YES;
}

- (void)dealloc{
//    [super dealloc];
    NSLog(@"%s", __func__);
}
@end
