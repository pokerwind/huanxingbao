/**
 * Copyright (c) 山东六牛网络科技有限公司 https://liuniukeji.com
 *
 * @Description
 * @Author         yulianbo   tel:  15269966441
 * @Copyright      Copyright (c) 山东六牛网络科技有限公司 保留所有版权(https://www.liuniukeji.com)
 * @Date
 * @IDE/Editor
 * @Modified By
 */

#ifndef LNMacros_h
#define LNMacros_h

// 正式环境
#define DEFAULT_HTTP_HOST @"http://hzhx999.cn/index.php/"
#define DEFAULT_HTTP_IMG @"http://hzhx999.cn"
// 测试环境
//#define DEFAULT_HTTP_HOST @"http://dingzhi.pro3.liuniukeji.net/"
//#define DEFAULT_HTTP_IMG @"http://dingzhi.pro3.liuniukeji.net/"

#define FULL_URL(url)  [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,url]

#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"noimage_ horizontal"]

#define CARTUPDATENOTIFICATION @"CARTUPDATENOTIFICATION"
#define SELLERMEVCREFRESHNOTIFICATION @"SELLERMEVCREFRESHNOTIFICATION"
#define USERINFOUPDATEDNOTIFICATION @"USERINFOUPDATEDNOTIFICATION"
#define USERORDERINFOUPDATEDNOTIFICATION @"USERORDERINFOUPDATEDNOTIFICATION"
#define WXPAYRESULTNOTIFICATION @"WXPAYRESULTNOTIFICATION"
#define REFRESHMYORDERNOTIFICATION @"REFRESHMYORDERNOTIFICATION"

#define TopBarHeight 64.5
#define ThemeColor HEXCOLOR(0xFFFFFF)

#define NaviBarTitleColor  HEXCOLOR(0x000000)
#define NaviBarItemColor  HEXCOLOR(0xbebebe)

#define BgColor HEXCOLOR(0xF7F7F7)

#define PlaceholderColor  HEXCOLOR(0xc7c7c7)
#define TextBlackColor  HEXCOLOR(0x333333)
#define TextDarkColor  HEXCOLOR(0x585858)

#define BgDarkColor HEXCOLOR(0x1a1a1a)
#define CellBgColor HEXCOLOR(0xFFFFFF)
#define CellSeparatorColor HEXCOLOR(0xaeaeae)
#define AfterColor HEXCOLOR(0x282828)

#define TextDefaultColor HEXCOLOR(0x101010)
#define TextLightColor  HEXCOLOR(0x7d7d7d)
#define TextGoldColor   HEXCOLOR(0x9165F4)
#define TextDarkGoldColor   HEXCOLOR(0xB0A48C)
#define TextRedColor    HEXCOLOR(0xfd6668)
#define TextWhiteColor  HEXCOLOR(0xFFFFFF)
#define BorderColor  HEXCOLOR(0xEBEBEB)

#define OrangeColor  HEXCOLOR(0xFF7722)

#define BannerCurrentDotColor HEXCOLOR(0xFF8903)
#define BannerOtherDotColor HEXCOLOR(0xE6E6E6)

#define DefaultTextBlackColor HEXCOLOR(0x333333)
#define DefaultTextLightBlackColor HEXCOLOR(0x999999)

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define HEXCOLORA(hex) [UIColor colorWithRed:((float)((hex & 0xFF000000) >> 32)) / 255.0 green:((float)((hex & 0xFF0000) >> 16)) / 255.0 blue:((float)(hex & 0xFF00) >> 8) / 255.0 alpha:((float)(hex & 0xFF)) / 255.0]
//我的 -> 用户信息
#define kArchiveUserInfo @"person.user.archive"

//AppDelegate对象
#define AppDelegateInstance [[UIApplication sharedApplication] delegate]

//在keychain中保存device uuid
#define kServiceKey @"com.liuniukej.dplive"
#define kAccountKey @"com.liuniukej.dplive.identifier"

// iOS 10 不打印日志 通过以下方式解决
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#define printf(...)
#endif

#define APP_SCHEME @"SiRenDingZhi"

// 获取屏幕尺寸
#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

// 分辨 不同设备
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
// 分辨不同 手机尺寸
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)// 640*960
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)//640x1136
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)//750x1334
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)//1080x1920

#endif /* LNMacros_h */
