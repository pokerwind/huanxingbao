#import "DPMobileApplication.h"
#import "SSKeychain.h"
#import "SPCommonUtils.h"
#import "DZGetUserInfoModel.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"

static DPMobileApplication *sharedManager = nil;

@implementation DPMobileApplication

/**Begin**/
- (id)init{
    if(self = [super init]){
        NSString *string = [SSKeychain passwordForService:kServiceKey account:kAccountKey];
        
        if(!string) {
            string = [self uuid];
            string = [[string stringByReplacingOccurrencesOfString:@"-" withString:@""]
                      lowercaseStringWithLocale:[NSLocale currentLocale]];
            //保存标识符
            [SSKeychain setPassword: [NSString stringWithFormat:@"%@", string]
                         forService:kServiceKey account:kAccountKey];
        }
        
        NSString *filePath = [SPCommonUtils buildArchivePath:kArchiveUserInfo];
        
        //解档, 读取缓存数据
        _loginUser = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        _isLogined = YES;
        if(!_loginUser) {
            _isLogined = NO;
        }
    }
    return self;
}

+(DPMobileApplication*)sharedInstance{
    @synchronized(self){
        if(!sharedManager)
        {
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if(!sharedManager){
            //确保使用同一块内存地址
            sharedManager = [super allocWithZone:zone];
            return sharedManager;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone*)zone{
    return self;
}

/**End**/

//获取uuid，用来识别设备
- (NSString *)uuid
{
    NSString *_uuid = nil;
    
    if (_uuid == nil) {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        _uuid = (__bridge NSString *)string ;
        
    }
    return _uuid;
}

/**
 *  获取设备ID
 *
 *  @return return value description
 */
-(NSString*)getPhoneDeviceID{
    
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *deviceUID = [[NSString alloc] initWithString:[[device identifierForVendor] UUIDString]];
    if ([deviceUID length] == 0) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        if (uuid)
        {
            deviceUID = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
            CFRelease(uuid);
        }
    }
    
    return deviceUID;
}

-(void)setLoginUser:(DZUserModel *)loginUser{
    
    //用户信息缓存到本地
    _loginUser = loginUser;
    
    NSString *filePath = [SPCommonUtils buildArchivePath:kArchiveUserInfo];
    
    //归档
    if (_loginUser) {
        //归档, 将用户信息缓存起来
        [NSKeyedArchiver archiveRootObject:_loginUser toFile:filePath];
        _isLogined = YES;
        
    }else{
        //删除归档文件
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        if ([defaultManager isDeletableFileAtPath:filePath]) {
            [defaultManager removeItemAtPath:filePath error:nil];
        }
        _isLogined = NO ;
    }
}

- (BOOL)isSellerMode{
    if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
        return NO;
    }else{
        return YES;
    }
    
}

- (void)updateUserInfo{
    NSDictionary *params = @{@"token":self.loginUser.token};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getUserInfo" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZGetUserInfoModel *model = [DZGetUserInfoModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.loginUser.nickname = model.data.nickname;
            self.loginUser.head_pic = model.data.head_pic;
            self.loginUser.register_time = model.data.register_time;
            self.loginUser.points = model.data.points;
            self.loginUser.user_level = model.data.user_level;
            self.loginUser.audit_status = model.data.audit_status;
            self.loginUser.is_shop = [model.data.is_openShop integerValue];
            self.loginUser.pay_password = model.data.has_set_pay_password;
            
            
            [self setLoginUser:self.loginUser];
            
            //发送通知，更新展示的用户信息
            [[NSNotificationCenter defaultCenter] postNotificationName:USERINFOUPDATEDNOTIFICATION object:nil];
        }
    } failure:nil];
}

-(void)logout{
    
    NSString *filePath = [SPCommonUtils buildArchivePath:kArchiveUserInfo];
    //删除归档文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:filePath]) {
        [defaultManager removeItemAtPath:filePath error:nil];
    }
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    _isLogined = NO;
    _loginUser = nil;
}

@end
