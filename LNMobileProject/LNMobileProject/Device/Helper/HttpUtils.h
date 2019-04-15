//
//  HttpUtils.h
//  EOPGentrule
//
//  Created by hahaha on 2017/7/7.
//  Copyright © 2017年 RX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void( ^ LXResponseSuccess)(id response);
typedef void( ^ LXResponseFail)(NSError *error);

typedef void( ^ LXUploadProgress)(int64_t bytesProgress,
int64_t totalBytesProgress);

typedef void( ^ LXDownloadProgress)(int64_t bytesProgress,
int64_t totalBytesProgress);

/**
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 */
typedef NSURLSessionTask LXURLSessionTask;

@interface HttpUtils : NSObject

+ (HttpUtils *)sharedInstance;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formDataArray  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
//+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求(上传表情图片)
 *
 *  @param url     请求路径
 *  @param parame  请求参数
 *  @param image  图片数组
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)uploadImageUrl:(NSString *)url Parameters:(NSDictionary *)parame Images:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;



+ (NSDictionary *)intoDictionary:(NSDictionary *)dic;


+ (void)postWithURL:(NSString *)url jsonParams:(NSString *)jsonParams success:(void (^)(id json))success failure:(void (^)(NSError * error))failure;

//参数添加到httpbody里面    冠维用
+ (void)postWithURL:(NSString *)url datas:(NSData *)jsonParams success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)postWithURL:(NSString *)url jsonData:(NSString *)jsonParams success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)downLoadWithURL:(NSString *)urlStr params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)downloadFileWithURL:(NSString*)url
                  savedPath:(NSString*)savedPath
            downloadSuccess:(void (^)(NSURL *filePath))success
            downloadFailure:(void (^)(NSError *error))failure;

@end
