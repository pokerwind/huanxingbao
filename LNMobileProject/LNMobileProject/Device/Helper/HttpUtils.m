//
//  HttpUtils.m
//  EOPGentrule
//
//  Created by hahaha on 2017/7/7.
//  Copyright © 2017年 RX. All rights reserved.
//

#import "HttpUtils.h"
#import "AFNetworking.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "StringUtils.h"
#import "JSONKit.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"";

static NSMutableArray *tasks;
@implementation HttpUtils

+ (HttpUtils *)sharedInstance
{
    static HttpUtils *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[HttpUtils alloc] init];
    });
    return handler;
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [self addDidForHeader:mgr];
    mgr.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [mgr.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Accept"];
    mgr.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval=600.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSLog(@"%@---%@",url,params);
    
    //    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    if ([[params allKeys]containsObject:@"id"]) {
        if (dx_isNullOrNilWithObject(params[@"id"])) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil]; //取消登录超时自动退出的方式
        }
    }
    
    
    [mgr POST:[NSString stringWithFormat:@"%@%@",AFAppDotNetAPIBaseURLString,url] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if([[responseObject objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                NSError * _Nonnull error = [[NSError alloc]init];
                failure(error);
            }
            else
            {
                success(responseObject);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
        if (failure) {
            failure(error);
        }
    }];
    
}

//参数添加到httpbody里面    冠维用
+ (void)postWithURL:(NSString *)url jsonParams:(NSString *)jsonParams success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonParams dataUsingEncoding:NSUTF8StringEncoding]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //        NSDictionary *temp = (NSDictionary*)responseObject;
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dx_isNullOrNilWithObject(dict)) {
                NSString * string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                if([string containsString:@"err"])
                {
                    if ([string containsString:@"登录超时"]) {
                        [SVProgressHUD showInfoWithStatus:@"登录超时"];
                        //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil]; //取消登录超时自动退出的方式
                        //超时登录时根据保存的登录信息重新执行登录方法
                        
                    }
                    NSError *err = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:991 userInfo:@{@"msg":string}];
                    failure(err);
                }
                else if([string isEqualToString:@""])
                {
                    NSError *err = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:991 userInfo:@{@"msg":@"操作成功"}];
                    success(err);
                }
                
            }else
            {
                success(dict);
            }
            
        } else {
            NSError *err;
            NSString * string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([@""isEqualToString:string]) {
                err = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:990 userInfo:@{@"msg":@"操作成功"}];
            }
            else if([string containsString:@"err"])
            {
                err = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:991 userInfo:@{@"msg":string}];
            }
            else{
                err = error;
            }
            
            failure(err);
        }
    }] resume];
}




//恢复session的登录方法
-(void)Login
{
//    [UserInfoDBHelper clearUserInfo];  //首先清空保存的用户信息
    NSDictionary *loginDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginDic"];
    
    [HttpUtils postWithURL:@"" jsonParams:[loginDic JSONString] success:^(id json) {
        
        if (!dx_isNullOrNilWithObject(json)) {
//            [UserInfoDBHelper saveCurrentUserInfo:json];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_SUCCESS_NOTIFICATION" object:nil ];
            //保存登录信息
            //            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"loginDic"];
            //userInfo:@{@"ADDRESS":address,@"LOCATION":[NSString stringWithFormat:@"%f,%f",coor.latitude,coor.longitude]}
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"登陆失败"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil];
        }
        
    } failure:^(NSError *error) {
        if (990 == error.code || 991 == error.code) {
            NSDictionary * dic= error.userInfo;
            [SVProgressHUD showInfoWithStatus:[dic objectForKey:@"msg"]];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }
    }];
}



//参数添加到httpbody里面    冠维用
+ (void)postWithURL:(NSString *)url datas:(NSData *)jsonParams success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:jsonParams];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //        NSDictionary *temp = (NSDictionary*)responseObject;
        
        
        
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dx_isNullOrNilWithObject(dict)) {
                NSString * string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                if([string containsString:@"err"])
                {
                    if ([string containsString:@"登录超时"]) {
                        [SVProgressHUD showInfoWithStatus:@"登录超时"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil];
                    }
                    NSError *err = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:991 userInfo:@{@"msg":string}];
                    failure(err);
                }
                else if([string isEqualToString:@""])
                {
                    NSError *err = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:991 userInfo:@{@"msg":@"操作成功"}];
                    success(err);
                }
                else
                {
                    NSError *err = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:991 userInfo:@{@"msg":string}];
                    success(err);
                }
                
            }else
            {
                success(dict);
            }
            
        } else {
            NSError *err;
            NSString * string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([@""isEqualToString:string]) {
                err = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:990 userInfo:@{@"msg":@"操作成功"}];
            }
            else if([string containsString:@"err"])
            {
                err = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:991 userInfo:@{@"msg":string}];
            }
            else{
                err = error;
            }
            
            failure(err);
        }
    }] resume];
}


+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [self addDidForHeader:mgr];
    mgr.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [mgr.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Accept"];
    mgr.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", @"text/json", @"text/javascript",@"application/x-javascript", nil];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval=600.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSLog(@"%@---%@---%@",url,params,url);
    
//    mgr.responseSerializer = [afj serializer];
    
    [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(NSMutableArray *)tasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"创建数组");
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}

+(AFHTTPSessionManager *)getAFManager{
    
    AFHTTPSessionManager *manager = manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];//设置请求数据为json
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval=10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    
    return manager;
    
}

+ (void)uploadImageUrl:(NSString *)url Parameters:(NSDictionary *)parame Images:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把file改成网站开发人员告知的字段名
     */
    
    //AFN3.0+基于封住HTPPSession的句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval=10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    //     for (UIImage *image in images) {
    
    
    
    [manager POST:url parameters:parame constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *data = UIImagePNGRepresentation(image);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
    }progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    //     }
    
    
}


+ (void)downLoadWithURL:(NSString *)urlStr params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [SVProgressHUD showWithStatus:@"加载中....."];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    /* 下载地址 */
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";  
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /* 下载路径 */
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Music"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!(isDir && existed)) {
        // 在Document目录下创建一个archiver目录
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",params[@"id"]]];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    if(result)
    {
        success([NSURL fileURLWithPath:filePath]);
        return;
    }
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"下载中...%f%%", downloadProgress.fractionCompleted * 100]];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果需要进行UI操作，需要获取主线程进行操作
        });
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成");
        [SVProgressHUD showInfoWithStatus:@"下载完成"];
        success(filePath);
    }];
    [downloadTask resume];
    
}

+ (void)downloadFileWithURL:(NSString*)url
                  savedPath:(NSString*)savedPath
            downloadSuccess:(void (^)(NSURL *filePath))success
            downloadFailure:(void (^)(NSError *error))failure {
    
    NSString *escapedPath  = [[NSString stringWithFormat:@"http://%@",url] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:escapedPath parameters:@{} error:nil];
    NSURLSessionDownloadTask *task = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%.1f％", downloadProgress.fractionCompleted * 100);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"下载中...%.1f%%", downloadProgress.fractionCompleted * 100]];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:savedPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(error){
            failure(error);
        }else{
            success(filePath);
        }
    }];
    [task resume];
}


+ (NSDictionary *)intoDictionary:(NSDictionary *)dataDic{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic options:0 error:&error];
    NSString *stringData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"value":stringData};
    return params;
}


// header中添加did
+ (void)addDidForHeader:(AFHTTPSessionManager *)mgr
{
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFHTTPRequestSerializer *requestSerializer = mgr.requestSerializer;
    //mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *headerFieldValueDictionary = @{
                                                 @"Content-Type": @"application/x-www-form-urlencoded",
                                                 @"Accept": @"application/json"
                                                 };
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    //    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    mgr.requestSerializer = requestSerializer;
}

// 更新did
+ (void)updateDid:(id)responseObject
{
    //    if (!dx_isNullOrNilWithObject(responseObject[@"info"][@"did"])) {
    //        [UserInfoDBHelper updateDid:responseObject[@"info"][@"did"]];
    //    }
}


@end

