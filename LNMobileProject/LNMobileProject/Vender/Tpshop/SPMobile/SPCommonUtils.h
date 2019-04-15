/**
 * ============================================================================
 * * 版权所有 2015-2027 山东六牛网络科技有限公司，并保留所有权利。
 * 网站地址: http://www.liuniukeji.com
 * ----------------------------------------------------------------------------
 * 这不是一个自由软件！您只能在不用于商业目的的前提下对程序代码进行修改和使用 .
 * 不允许对程序代码以任何形式任何目的的再发布。
 * ============================================================================
 * $description: UIColor+HDXColor
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIColor+HDXColor.h"

/**
 *  定义用户操作类型: 注册/找回密码
 */
//typedef enum{
//    actionRegister = 1,   //用户注册
//    actionForget  =  2,   //找回密码
//    actionPhone = 3       //绑定手机号
//}ActionType;

/**
 需要导入的库
 AVFoundation.framework
 AssetsLibrary.framework
 */
@interface SPCommonUtils : NSObject

/**
 *  判断是否有相机访问权限
 *
 *  @return YES 有访问相机权限，NO 没有权限访问相机
 */
+(BOOL)checkCameraPermission;
/**
 *  判断是否有相册访问权限
 *
 *  @return YES 有访问相册权限，NO 没有权限访问相册
 */
+(BOOL)checkPhotoLibraryPermission;
/**
 *  判断定位是否开启
 *
 *  @return YES为开启，NO 没有开启
 */
+(BOOL)checkLocationOpen;
/**
 *  自动计算标签的宽度
 *
 *  @param label UILabel对象
 *
 *  @return 宽度
 */
+(CGFloat)autoLabelWidth:(UILabel*)label;
/**
 *  自动计算标签的高度
 *
 *  @param label UILabel对象
 *
 *  @return 高度
 */
+(CGFloat)autoLabelHeight:(UILabel*)label;
/**
 *  自动计算字符串宽度
 *
 *  @param str NSString 对象字符串
 *
 *  @return 宽度
 */
+(CGFloat)autoStringWidth:(NSString*)str textFont:(UIFont*)font heightShow:(CGFloat)height;
/**
 *  自动计算字符串高度
 *
 *  @param str NSString 对象字符串
 *
 *  @return 高度
 */
+(CGFloat)autoStringHeight:(NSString*)str textFont:(UIFont*)font widthShow:(CGFloat)width;
/**
 *  构建一个带删除线的属性字符串
 *
 *  @param strText strText description
 *
 *  @return return value description
 */
+(NSMutableAttributedString*)buildDeleteLineText:(NSString*)strText;
/**
 *  构建归档目录文件
 *
 *  @param archiveFileName 归档文件名称
 *
 *  @return 归档文件沙盒地址：Caches/Archives/
 */
+(NSString*)buildArchivePath:(NSString*)archiveFileName;
/**
 *  移除所有归档数据
 *
 *  @return return
 */
+(BOOL)removeAllArchives;

/**
 *  生成唯一值, 用于购物车唯一标识.
 *
 *  @return return value description
 */
+(NSString*)getTimeAndRandom;


/**
 *  根据时间戳格式化时间格式
 *
 *  @param dateTimeStr 时间戳
 *
 *  @return yyyy-MM-dd HH:mm:ss
 */
+(NSString*)getDateTime:(NSString*)dateTimeStr;


/**
 *  根据时间戳格式化时间格式
 *
 *  @param dateTimeStr 时间戳
 *
 *  @return yyyy-MM-dd
 */
+(NSString*)getDateShortTime:(NSString*)dateTimeStr;

/**
 *  获取短信验证码
 *
 *  @return 4位短信验证码
 */
+(NSString*)getMessagecode;



/**
 *  计算Cell高度
 *
 *  @param labelHeight 文本高度
 *
 *  @return return 文本所在cell的高度
 */
+(CGFloat)calcHeightOfCell:(CGFloat)labelHeight;

/**
 *  计算文本应该显示几行
 *
 *  @param labelHeight 文本高
 *
 *  @return 文本占用的行数
 */
+(NSInteger)calcLabelNumber:(CGFloat)labelHeight;

/**
 *  将突破转换为文字
 *
 *  @param labelHeight 文本高
 *
 *  @return 文本占用的行数
 */
+(UIImage*)convertImageWithColor:(UIColor*)color;



/**
 *  根据图片获取完整路径
 *
 *  @param partUrl 图片URL后半部分
 *                 例如: partUrl是: /xx.jpg,
 *
 *  @return 图片完整路径
 */
+(NSString*)getFullUrlWithHost:(NSString*)host partUrl:(NSString*)partUrl;

/**
 *  获取商品默认缩略图
 *
 *  @param goodsID 商品ID
 *
 *  @return 缩略图URL
 */
+(NSString*)getThumbnailWithHost:(NSString*)host goodsID:(NSString*)goodsID;

/**
 *  获取自定义大小的商品缩略图
 *
 *  @param goodsID 商品ID
 *
 *  @return 缩略图URL
 */
+(NSString*)getFlexibleThumbnailWithHost:(NSString*)host goodsID:(NSString*)goodsID width:(NSInteger)width height:(NSInteger)height;

/**
 *  验证是否一个有效Array
 *
 *  @param array array description
 *
 *  @return return value description
 */
+(BOOL)verifyArray:(NSArray*)array;

/**
 *  删除子View
 *
 *  @param parentView
 */
+(void)clearSubView:(UIView*)parentView;




#pragma mark - 从document取得图片
/**
 *  从document取得图片
 *
 *  @param urlStr urlStr description
 *
 *  @return return value description
 */
+ (UIImage *)getImage:(NSString *)imageName;

#pragma mark - 头像保持到本地
/**
 *  头像保持到本地
 *
 *  @param tempImage tempImage
 *  @param imageName imageName
 */
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

/**
 *  删除某目录下的文件
 *
 *  @param fielName fielName
 */
+ (void)deleteFileWithName:(NSString *)fielName;


/**
 *  当前系统时间戳
 *
 *  @return 
 */
+(long)getCurrentTime;


/**
 *  MD5 加密算法
 *
 *  @param str
 *
 *  @return
 */
+(NSString *)md5:(NSString *)str;


#pragma mark - 服务器验证签名方法
/**
 *  服务器验证签名方法
 *
 *  @param params
 *  @param time
 *  @param privateKey
 *
 *  @return
 */
+(NSString*)signParameter:(NSDictionary*)params time:(NSString*)time signKey:(NSString*)signKey  url:(NSString*)url;

/**
 *  unicode编码:  unicode -> 中文
 *
 *  @param unicodeStr unicode码
 *
 *  @return 中文
 */
+(NSString *)replaceUnicode:(NSString *)unicodeStr;
@end
