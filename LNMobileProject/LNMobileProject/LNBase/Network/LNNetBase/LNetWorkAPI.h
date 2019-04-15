//
//  LNetWorkAPI.h
//  MobileProject
//
//  Created by 云网通 on 2017/1/13.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCNetwork.h"

@interface LNetWorkAPI : LCBaseRequest<LCAPIRequest>
-(instancetype) initWithUrl:(NSString *)url;
-(instancetype) initWithUrl:(NSString *)url parameters:(NSDictionary *) param ;
-(instancetype) initWithUrl:(NSString *)url parameters:(NSDictionary *) param method:(LCRequestMethod )method;
-(instancetype) initWithUrl:(NSString *)url parameters:(NSDictionary *) param method:(LCRequestMethod )method ignoreUnified :(BOOL)ignoreUnified;
-(instancetype) initWithUrl:(NSString *)url parameters:(NSDictionary *) param method:(LCRequestMethod )method isuseCustomApiMethodName :(BOOL)isuseCustomApiMethodName;
@end
