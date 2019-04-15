//
//  LEONMacros.h
//  GwadarApp
//
//  Created by stleon on 21/6/18.
//  Copyright © 2018年 iOSMac. All rights reserved.
//

#ifndef LEONMacros_h
#define LEONMacros_h


/** 经常 */
#define ktouchupinside               UIControlEventTouchUpInside
#define ktextcenter                  NSTextAlignmentCenter

/** key */
#define kyes                         @"YES"
#define kno                          @"NO"

/** 字体 */
#define HelveticaNeueMedium          @"HelveticaNeue-Medium"

#define kfont(Size) \
[UIFont fontWithName:@"HelveticaNeue" size:AUTO_MATE_HEIGHT(Size)] \

#define kfontnsize(Font,Size) \
[UIFont fontWithName:Font size:Size] \


/** 尺寸 */
#define kScreenBounds               [[UIScreen mainScreen] bounds]
#define kScreenWidth                kScreenBounds.size.width
#define kScreenHeight               kScreenBounds.size.height
#define AUTOSIZE(Size)              kScreenWidth/750 * Size;


/** 颜色 */

//#define kcolor(Color)               [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
//#define kcolorNalpha(Color,Alpha)               [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:Alpha]

#define kclearcolor                 [UIColor clearColor]
#define kwhitecolor                 [UIColor whiteColor]
#define kblackcolor                 [UIColor blackColor]
#define kgraycolor                  [UIColor grayColor]
#define krawcolor                   [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]


/** 添加本地偏好设置 */
#define ksetUserValueForKey(Object,Key) \
[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:Object] forKey:Key] ;\
[[NSUserDefaults standardUserDefaults] synchronize] \

#define kgetUserValueForKey(Key) \
[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:Key]] \

#define kremoveObjectForKey(Key) \
[[NSUserDefaults standardUserDefaults] removeObjectForKey:Key];\

#endif /* LEONMacros_h */
