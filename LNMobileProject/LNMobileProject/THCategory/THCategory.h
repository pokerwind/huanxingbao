//
//  THCategory.h
//  TadpoleYun
//
//  Created by iOSMac on 2018/5/16.
//  Copyright © 2018年 iOSMac. All rights reserved.
//

#ifndef THCategory_h
#define THCategory_h
//#import "THBaseVC.h"
#import "UIView+Utilities.h"
#import "UIColor+THColorCategpry.h"
#import "UILabel+THLabelCategory.h"
#import "NSDate+Extension.h"
#import "UIImage+THImageCategory.h"
#import "UINavigationController+THNVCategory.h"
#import "UIViewController+parentVCCategory.h"
#import "UITextView+THTextViewCategory.h"
#import "UIButton+THCategory.h"
#import "UIImageView+THImageViewCategory.h"
#import "UIWebView+THUIWebViewCategory.h"
#import "NSString+THStringCategory.h"
//#import "IssuerDiscussInputView.h"
#import "NSObject+THObjectCategory.h"
#import "SheetAnimationView.h"
#import "PopupAnimationView.h"
//#import "UIScrollView+EmptyDataSet.h"
#define k_THFont(hexValue) [UIFont fontWithName:@"PingFangSC-Medium" size:(hexValue)]
//屏幕size
#define k_mainSize [UIScreen mainScreen].bounds.size

//比例适配
#define k_OnePx (k_mainSize.width / 750.0)
#define k_oneHeight (k_mainSize.height / 1334.0)
#define k_BuuttonAction UIControlEventTouchUpInside
//设置颜色
#define k_THUIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define k_THUIColorAlpha(hexValue,alphaF) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaF]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//最大view的宽度 相对于父视图
#define k_THViewWitch(hexValue) (hexValue.frame.origin.x + hexValue.frame.size.width)
//最大view的高度 相对于父视图
#define k_THViewHeight(hexValue) (hexValue.frame.origin.y + hexValue.frame.size.height)
// 判断是否是iPhone X
#define iPhoneX (([UIScreen mainScreen].bounds.size.height > 811.5) ? YES : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define k_NavigationHeight (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define k_TabbarHeight (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)
//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
//一些缩写
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow

//#ifdef DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(...)
//#endif
//#define k_THSafeString(string) (![string isKindOfClass:[NSString class]]) || \ ([string isKindOfClass:[NSNull class]]) || \ (!string) || \ (0 == ((NSString *)string).length) \ ? @"" : string

#endif /* THCategory_h */
