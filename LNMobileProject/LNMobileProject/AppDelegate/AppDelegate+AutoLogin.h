//
//  AppDelegate+AutoLogin.h
//  MobileProject
//
//  Created by LiuNiu-MacMini-YQ on 16/9/12.
//  Copyright © 2016年 wujunyang. All rights reserved.
//  自动登录

#import "AppDelegate.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate (AutoLogin)
-(void)autoLogin:(void(^)(void))didSuccess failure:(void(^)(NSError *error))didFailure;
- (void)saveUserNameAndPassword:(NSString *)userName password:(NSString *)password;
- (void)logout;
@end
