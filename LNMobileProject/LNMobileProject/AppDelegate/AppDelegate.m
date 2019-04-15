//
//  AppDelegate.m
//  LNMobileProject
//
//  Created by LiuYanQiMini on 2017/5/16.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <Dibaqu/DibaquFramework.h>
#import <JPUSHService.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "LNNavigationController.h"

#import "LCNetworkConfig.h"
#import "DPMobileApplication.h"
#import <IQKeyboardManager.h>


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <LinkedME_iOS/LinkedME.h>
#import "DZGoodsDetailVC.h"


@interface AppDelegate ()<JPUSHRegisterDelegate,EMClientDelegate,EMChatManagerDelegate, WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //启动更新检查SDK
    [[DibaquFramework sharedInstance] startFrameworkWithAppKey:@"075dc18723a63b5deb7c2fcf81ceabaa"];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    [DPMobileApplication sharedInstance];
    [self configureAPIKey];
    // 基本网络设置
    LCNetworkConfig *config = [LCNetworkConfig sharedInstance];
    config.mainBaseUrl = DEFAULT_HTTP_HOST;
    LCProcessFilter *filter = [[LCProcessFilter alloc] init];
    config.processRule = filter;

    //全局UI
    [self configAppearance];
    
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    //清空badge
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = 0|1|2;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            [application registerUserNotificationSettings:settings];
        }
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"1a1bb0dbdd31422bdd38b662"
                          channel:@"4e869142b8897493ee6e2742"
                 apsForProduction:0
            advertisingIdentifier:nil];
    
    // 注册环信 1104190104157503#jyl
    EMOptions *options = [EMOptions optionsWithAppkey:@"1117170918115153#sirendingzhi"];
    
    //options.apnsCertName = @"akimoto_publish";
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //    options.apnsCertName = @"istore_dev";
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (error == nil) {
        NSLog(@"注册环信服务成功");
        [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    }
    
    if ([DPMobileApplication sharedInstance].isLogined) {
        DZUserModel *user = [DPMobileApplication sharedInstance].loginUser;
        [JPUSHService setTags:[[NSSet alloc] initWithObjects:user.user_id, nil] alias:user.user_id fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
           NSLog(@"%@%@",iTags,iAlias);
        }];
        // 登录环信
        [[EMClient sharedClient] loginWithUsername:user.emchat_username
                                          password:user.emchat_password
                                        completion:^(NSString *aUsername, EMError *aError) {
                                            if (!aError) {
                                                NSLog(@"登陆成功");
                                            } else {
                                                NSLog(@"登陆失败");
                                            }
                                        }];
    }
    
    EMPushOptions *pushOptions = [[EMClient sharedClient] pushOptions];
    //pushOptions.displayStyle = EMPushDisplayStyleMessageSummary; // 显示消息内容
    pushOptions.displayStyle = EMPushDisplayStyleSimpleBanner; // 显示“您有一条新消息”
    error = [[EMClient sharedClient] updatePushOptionsToServer]; // 更新配置到服务器，该方法为同步方法，如果需要，请放到单独线程
    if(!error) {
        // 成功
    }else {
        // 失败
    }

    //设置ShareSDK
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)                                       ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
                 //wx4868b35061f87885 64020361b8ec4c99936c0e3999a9f249
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxd565152807ee4297"
                                       appSecret:@"9eeab5f7c8e26f508036ecb06c59025e"];
                 break;
             case SSDKPlatformTypeQQ:
                 //100371282 aed9b0303e3ed1e27bae87c33761161d
                 [appInfo SSDKSetupQQByAppId:@"101529809"
                                      appKey:@"2310bfc36d93af4d303ded3d6bb6309b"
                                    authType:SSDKAuthTypeBoth];
                 break;
                                                 default:
                   break;
                   }
                   }];
    
    //注册微信
    [WXApi registerApp:@"wxd565152807ee4297"];
    
    //设置根视图控制器
    [self setupRootViewController];
    [self shendulianjieapplication:application Options:launchOptions];
    return YES;
}
- (void)shendulianjieapplication:(UIApplication *)application Options:(NSDictionary *)launchOptions {
    //初始化及实例
    LinkedME* linkedme = [LinkedME getInstance];
    
    //    //注册需要跳转的viewController
//    UIStoryboard * storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    /*
        
     */
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:@"parent_id"];
    [userDefaults synchronize];
    //获取跳转参数
    [linkedme initSessionWithLaunchOptions:launchOptions automaticallyDisplayDeepLinkController:NO deepLinkHandler:^(NSDictionary* params, NSError* error) {
        if (!error) {
            //防止传递参数出错取不到数据,导致App崩溃这里一定要用try catch
            @try {
                NSLog(@"LinkedME finished init with params = %@",[params description]);
                //获取标题
                NSString *title = [params objectForKey:@"$og_title"];
                NSString *tag = params[@"$control"][@"parent_id"];
                NSString *goods_id = params[@"$control"][@"goods_id"];
                NSString *sglid = params[@"$control"][@"sglid"];
                if (title.length > 0 && goods_id.length > 0) {
                    DZGoodsDetailVC *goodsDetailVC = [[DZGoodsDetailVC alloc] init];//WithGoodsID:[NSString stringWithFormat:@"%@",dic[@"commodityID"]]];
                    goodsDetailVC.goodsId = [NSString stringWithFormat:@"%@",goods_id];
                    [[LinkedME getViewController] showViewController:goodsDetailVC sender:nil];
                }
                if (title.length > 0 && sglid.length > 0) {
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:sglid forKey:@"sglid"];
                    [userDefaults synchronize];
                }
                if (title.length >0 && tag.length >0) {
//                    dvc.openUrl = tag;
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:tag forKey:@"parent_id"];
                    [userDefaults synchronize];
                    
//                    NSLog(@"=======%@======",dvc.openUrl);
                    //如果app需要登录或者注册后，才能打开详情页，这里可以先把值存起来，登录/注册完成后，再使用
                    //[自动跳转]使用自动跳转
                    //SDK提供的跳转方法
                    /**
                     *  pushViewController : 类名
                     *  storyBoardID : 需要跳转的页面的storyBoardID
                     *  animated : 是否开启动画
                     *  customValue : 传参
                     *
                     *warning  需要在被跳转页中实现次方法 - (void)configureControlWithData:(NSDictionary *)data;
                     */
                    
                    //  [LinkedME pushViewController:title storyBoardID:@"detailView" animated:YES customValue:@{@"tag":tag} completion:^{
                    ////
                    //  }];
                    
                    //自定义跳转
                    
                }
            } @catch (NSException *exception) {
                
            } @finally {
            }
        } else {
            NSLog(@"LinkedME failed init: %@", error);
        }
    }];
    
    //[自动跳转]如果使用自动跳转需要注册viewController
    //    [linkedme registerDeepLinkController:featureVC forKey:@"LMFeatureViewController"];

}
//Universal Links 通用链接实现深度链接技术
- (BOOL)application:(UIApplication*)application continueUserActivity:(NSUserActivity*)userActivity restorationHandler:(void (^)(NSArray*))restorationHandler{
    
    //判断是否是通过LinkedME的Universal Links唤起App
    if ([[userActivity.webpageURL description] rangeOfString:@"lkme.cc"].location != NSNotFound) {
        return  [[LinkedME getInstance] continueUserActivity:userActivity];
    }
    return YES;
}
//URI Scheme 实现深度链接技术
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    NSLog(@"opened app from URL %@", [url description]);
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
//    return YES;
    //判断是否是通过LinkedME的UrlScheme唤起App
    if ([[url description] rangeOfString:@"click_id"].location != NSNotFound) {
        return [[LinkedME getInstance] handleDeepLink:url];
    }
    return YES;
}

- (void)configureAPIKey
{
     NSString *reason = [NSString stringWithFormat:@"ad23bcea540c6c84959a4b73229f665e"];
     [AMapServices sharedServices].apiKey = (NSString *)reason;
}


- (void)setupRootViewController {
    //判断是否已登录
    self.window.rootViewController = [[MainTabBarController alloc] init];
    
    if ([DPMobileApplication sharedInstance].isLogined) {
        //用户已登录，每次启动更新用户信息
        [[DPMobileApplication sharedInstance] updateUserInfo];
        [JPUSHService setAlias:[DPMobileApplication sharedInstance].loginUser.user_id callbackSelector:nil object:nil];
    }
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication]endBackgroundTask:UIBackgroundTaskInvalid];
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)configAppearance{
    NSDictionary * dict = @{
                            NSForegroundColorAttributeName:NaviBarTitleColor,
                            NSFontAttributeName:[UIFont systemFontOfSize:16]
                            };
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    // 设置left right NavItem 颜色
    [[UINavigationBar appearance] setTintColor:NaviBarItemColor];
    // 设置 UINavigationBar 背景色
    [[UINavigationBar appearance] setBarTintColor:ThemeColor];
    // 去掉黑线 不透明 NavigationBar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:ThemeColor]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    // 自定义返回按钮 图片
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"icon_back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"icon_back"]];
    // 设置 TabBar 不透明
    [UITabBar appearance].translucent = NO;
    
    // 设置 TabBar 颜色为黑色
    [[UITabBar appearance] setBarTintColor:ThemeColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TextLightColor}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TextGoldColor}
                                             forState:UIControlStateSelected];
}


//极光推送
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    //也要传给环信
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
}

#pragma mark - ---- EMChatManagerDelegate ----
// 受到即时消息
- (void)messagesDidReceive:(NSArray *)aMessages {
    
//    self.hasUnreadMessage = YES;

//    [SPMobileApplication sharedInstance].hasNewChatMessage = YES;
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushMessage object:nil];
//
//    if ([SPMobileApplication sharedInstance].isStartByHuanxinNotification) {
//        [SPMobileApplication sharedInstance].isStartByHuanxinNotification = NO;
//        return;
//    }


    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveMessage" object:nil];
//    /*
//     判断消息来源是否在当前的聊天界面
//     */
//    BOOL isCurrentChat = NO;
//    NSInteger index = self.mainTabBarController.selectedIndex;
//    UINavigationController *navi = [self.mainTabBarController.viewControllers objectAtIndex:index];
//    for (UIViewController *vc in navi.viewControllers) {
//        if ([vc isKindOfClass:[EaseMessageViewController class]]) {
//            isCurrentChat = YES;
//            break;
//        }
//    }
//    if (isCurrentChat) {
//        return;
//    }
#if !TARGET_IPHONE_SIMULATOR
//    if (!_lastPlaySoundDate) {
//        _lastPlaySoundDate = [NSDate dateWithTimeIntervalSince1970:0];
//    }
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:_lastPlaySoundDate];
//    if (timeInterval < 3.0) {
//        //如果距离上次响铃和震动时间太短, 则跳过响铃
//        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], _lastPlaySoundDate);
//        return;
//    }
//    //保存最后一次响铃时间
//    _lastPlaySoundDate = [NSDate date];
//    // 收到消息时，播放音频
//    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
//    // 收到消息时，震动
//    [[EMCDDeviceManager sharedInstance] playVibration];

#endif
    // 判断程序处在后台
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
//    if (YES) {
        // 所有回话的未读消息数
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        int count = 0;
        for (EMConversation *em in conversations) {
            count += [em unreadMessagesCount];
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = count;
        // 创建本地通知并设置通知内容
        UILocalNotification *LocalNoti = [[UILocalNotification alloc] init];
        LocalNoti.fireDate = [NSDate new];// 通知发出的时间
        LocalNoti.repeatInterval = 0;
        LocalNoti.soundName = UILocalNotificationDefaultSoundName;// 系统推送声音
        EMMessage *lastMessage = [aMessages firstObject];
        if (lastMessage.direction == 1) {

            NSString *latestMessageTitle = @"";
            EMMessageBody *messageBody = lastMessage.body;
            switch (messageBody.type) {
                case 2:{
                    latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
                } break;
                case 1:{
                    // 表情映射。
                    NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                                convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                    latestMessageTitle = didReceiveText;
                    if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                        latestMessageTitle = @"[动画表情]";
                    }
                } break;
                case 5:{
                    latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
                } break;
                case 4: {
                    latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
                } break;
                case 3: {
                    latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
                } break;
                case 6: {
                    latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
                } break;
                default: {
                } break;
            }
//            NSString *from = lastMessage.from;
//            NSDictionary *dic = [self getUserDetail:from];

            // 创建本地通知并设置通知内容
            UILocalNotification *LocalNoti = [[UILocalNotification alloc] init];
            LocalNoti.fireDate = [NSDate new];// 通知发出的时间
            LocalNoti.repeatInterval = 0;
            LocalNoti.soundName = UILocalNotificationDefaultSoundName;// 系统推送声音
//            if (dic) {
//                LocalNoti.alertBody = [NSString stringWithFormat:@"%@:%@",dic[@"nickname"],latestMessageTitle];// 通知内容
//            }else {
//                LocalNoti.alertBody = @"你有一条新的消息";// 通知内容
//            }
            LocalNoti.alertBody = @"你有一条新的消息";// 通知内容
            LocalNoti.hasAction = YES;// 是否显示提示文字

            NSDictionary *dict = @{@"type":@"4"};
            LocalNoti.userInfo = dict;
            [[UIApplication sharedApplication] scheduleLocalNotification:LocalNoti];
            LocalNoti = nil;
        }

    }
    // 会话列表刷新数据
//        [self.convesationVC refreshDataSource];
    // 显示未读消息标记
//        [self showUnReadMessageSign];
}
//
//
#pragma mark - ---- EMClientDelegate ----
- (void)userAccountDidLoginFromOtherDevice
{
//    if ([SPMobileApplication sharedInstance].isLogined == NO) {
//        return;
//    }
    //    [[SPMobileApplication sharedInstance] logout];
    //    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    delegate.mainTabBarController = [[MainTabBarController alloc] init];
    //    delegate.window.rootViewController = delegate.mainTabBarController;
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前登录账号在其它设备登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alertView show];
    //    alertView.tag = 100;
    //    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    LGAlertView *alert = [LGAlertView alertViewWithTitle:@"消息" message:notification.request.content.body style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil];
    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    LGAlertView *alert = [LGAlertView alertViewWithTitle:@"消息" message:userInfo[@"aps"][@"alert"] style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil];
    [alert show];
}

#pragma mark - scheme url
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    //判断是否是通过LinkedME的UrlScheme唤起App
    if ([[url description] rangeOfString:@"click_id"].location != NSNotFound) {
        return [[LinkedME getInstance] handleDeepLink:url];
    }
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

//// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//
//}

//WXApiDelegate
-(void) onReq:(BaseReq*)req{
    
}

-(void) onResp:(BaseResp*)resp{
    [[NSNotificationCenter defaultCenter] postNotificationName:WXPAYRESULTNOTIFICATION object:@{@"errCode":[NSString stringWithFormat:@"%d", resp.errCode]}];
}

#pragma mark - getter
- (UIWindow *)window
{
    if(!_window)
    {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        [_window makeKeyAndVisible];
    }
    return _window;
}

@end
