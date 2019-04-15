#import <Foundation/Foundation.h>

#import "DZUserModel.h"

#import "DZCustomerServiceModel.h"

/**
 *  ShopMobile应用管理单例类
 */
@interface DPMobileApplication : NSObject
/**
 *  是否已经显示了启动页广告
 */
@property (nonatomic,assign) BOOL isStartAdShown;

/**
 *  是否有新消息
 */
@property (nonatomic,assign) BOOL hasNewChatMessage;

/**
 *  是否正在弹出某个界面中
 */
@property (nonatomic,assign) BOOL isShowing;

/**
 *  是否是登录状态
 */
@property (nonatomic,assign,readonly) BOOL isLogined;

/**
 *  当前登录用户
 */
@property (nonatomic,strong) DZUserModel *loginUser;

@property (nonatomic) BOOL isSellerMode;//当前是否为卖家模式

@property (nonatomic, strong) DZCustomerServiceModel *customerService;

/**
 *  获取静态模型实例
 *
 *  @return return value description
 */
+ (DPMobileApplication*)sharedInstance;

/**
 *  退出登录
 */
- (void)logout;

/**
 *  获取设备ID
 *
 *  @return return value description
 */
-(NSString*)getPhoneDeviceID;

- (void)updateUserInfo;

@end
