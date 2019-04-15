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

@interface UIColor (HDXColor)

/**
 *  16进制转颜色，格式：0xecedec
 *
 *  @param rgbValue 比如：0xecedec
 *  @param alpha    透明度：0.0-1.0
 *
 *  @return <#return value description#>
 */
+ (instancetype)colorWithRGB:(NSInteger)rgbValue alpha:(CGFloat)alpha;
/**
 *  字符串转颜色，格式：#ececec
 *
 *  @param htmlColor 比如：#ecedec
 *  @param alpha     透明度：0.0-1.0
 *
 *  @return <#return value description#>
 */
+ (instancetype)colorWithHexString:(NSString *)htmlColor alpha:(CGFloat)alpha;

@end
