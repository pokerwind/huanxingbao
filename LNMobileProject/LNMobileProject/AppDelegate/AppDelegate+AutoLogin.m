//
//  AppDelegate+AutoLogin.m
//  MobileProject
//
//  Created by LiuNiu-MacMini-YQ on 16/9/12.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "AppDelegate+AutoLogin.h"
#import "UICKeyChainStore.h"
#import "LoginAPI.h"

@implementation AppDelegate (AutoLogin)

#pragma mark - 自动登录
-(void)autoLogin:(void(^)(void))didSuccess failure:(void(^)(NSError *error))didFailure{
    
    NSString *SERVICE_NAME = [[NSBundle mainBundle] bundleIdentifier];
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:SERVICE_NAME];
    
    NSString *username = [keychain stringForKey:@"username"];
    NSString *password = [keychain stringForKey:@"password"];
    //NSDictionary *data = [[EGOCache globalCache] objectForKey:@"USERMODEL_CACHE"];
    
    if (username && password) {   // 密码和用户名 均不为空执行登录
        
    }else{
        didFailure(nil);
    }
}

- (void)saveUserNameAndPassword:(NSString *)userName password:(NSString *)password{
    NSString *SERVICE_NAME = [[NSBundle mainBundle] bundleIdentifier];
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:SERVICE_NAME];
    NSString *keychainName = [keychain stringForKey:@"username"];
    NSString *keychainPass = [keychain stringForKey:@"password"];
    
    if (![userName isEqualToString:keychainName] ) { //|| keychainName == nil
        [keychain setString:userName forKey:@"username"];
    }
    if(![password isEqualToString:keychainPass] ){ // || keychainPass == nil
        [keychain setString:password forKey:@"password"];
    }
}

- (void)logout {
    NSString *SERVICE_NAME = [[NSBundle mainBundle] bundleIdentifier];
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:SERVICE_NAME];
    [keychain removeItemForKey:@"username"];
    [keychain removeItemForKey:@"password"];
}

@end
