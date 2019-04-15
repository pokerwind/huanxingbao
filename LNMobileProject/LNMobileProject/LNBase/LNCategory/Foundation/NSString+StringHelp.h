//
//  NSString+StringHelp.h
//  MobileProject
//
//  Created by 云网通 on 16/8/23.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringHelp)
///////////////////////////// 正则表达式相关  ///////////////////////////////

/** 邮箱验证 */
- (BOOL)isValidEmail;

/** 手机号码验证 */
- (BOOL)isValidPhoneNum;

/** 车牌号验证 */
- (BOOL)isValidCarNo;

/** 网址验证 */
- (BOOL)isValidUrl;

/** 邮政编码 */
- (BOOL)isValidPostalcode;

/** 纯汉字 */
- (BOOL)isValidChinese;



/**
 @brief     是否符合IP格式，xxx.xxx.xxx.xxx
 */
- (BOOL)isValidIP;

/** 身份证验证 refer to http://blog.csdn.net/afyzgh/article/details/16965107*/
- (BOOL)isValidIdCardNum;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/** 去掉两端空格和换行符 */
- (NSString *)stringByTrimmingBlank;

/** 去掉html格式 */
- (NSString *)removeHtmlFormat;

/** 工商税号 */
- (BOOL)isValidTaxNo;

/**
 *  判断字符串是否为空 YES为空 NO 不为空
 *
 *  @return YES为空 NO 不为空
 */
- (BOOL) isBlankString;//判断字符串是否为空  YES为空 NO 不为空

/**
 判断字符串 不是空

 @return YES:不为空  NO:空
 */
- (BOOL) notBlank;

/**
 格式化时间 由时间戳 转化成 年月日
 @return yyyy-MM-dd
 */
- (NSString *)timeFormatterYMD;

/**
 格式化时间 由时间戳 转化成 年月日 时分
 @return yyyy-MM-dd HH:mm
 */
- (NSString *)timeFormatterYMDHM;

/**
 格式化时间 由时间戳 转化成 年月日 时分秒
 @return yyyy-MM-dd HH:mm:ss
 */
- (NSString *)timeFormatterYMDHMS;

- (NSString *)timeFormatterHMS;

- (NSString *)stringFormatTwoPoint;

//字典转json
+(NSString *)convertToJsonData:(NSDictionary *)dict;

@end