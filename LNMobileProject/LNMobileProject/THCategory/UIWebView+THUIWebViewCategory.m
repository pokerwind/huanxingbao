//
//  UIWebView+THUIWebViewCategory.m
//  TadpoleYun
//
//  Created by iOSMac on 2018/5/16.
//  Copyright © 2018年 iOSMac. All rights reserved.
//

#import "UIWebView+THUIWebViewCategory.h"
#import "UIColor+THColorCategpry.h"

@implementation UIWebView (THUIWebViewCategory)
#pragma mark -
#pragma mark 获取网页中的数据
/// 获取某个标签的结点个数
- (int)nodeCountOfTag:(NSString *)tag
{
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('%@').length", tag];
    int len = [[self stringByEvaluatingJavaScriptFromString:jsString] intValue];
    return len;
}
/// 获取当前页面URL
- (NSString *)getCurrentURL
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.location.href"];
}
/// 获取标题
- (NSString *)getTitle
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}
/// 获取所有图片链接
- (NSArray *)getImgs
{
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
        [arrImgURL addObject:[self stringByEvaluatingJavaScriptFromString:jsString]];
    }
    return arrImgURL;
}
/// 获取当前页面所有点击链接
- (NSArray *)getOnClicks
{
    NSMutableArray *arrOnClicks = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self nodeCountOfTag:@"a"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('a')[%d].getAttribute('onclick')", i];
        NSString *clickString = [self stringByEvaluatingJavaScriptFromString:jsString];
//        NSLog(@"%@", clickString);
        [arrOnClicks addObject:clickString];
    }
    return arrOnClicks;
}
#pragma mark -
#pragma mark 改变网页样式和行为
/// 改变背景颜色
- (void)setBackgroundColor:(UIColor *)color
{
    NSString * jsString = [NSString stringWithFormat:@"document.body.style.backgroundColor = '%@'",[color webColorString]];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/// 为所有图片添加点击事件(网页中有些图片添加无效,需要协议方法配合截取)
- (void)addClickEventOnImg
{
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        //利用重定向获取img.src，为区分，给url添加'img:'前缀
        NSString *jsString = [NSString stringWithFormat:
                              @"document.getElementsByTagName('img')[%d].onclick = \
                              function() { document.location.href = 'img' + this.src; }",i];
        [self stringByEvaluatingJavaScriptFromString:jsString];
    }
}
/// 改变所有图像的宽度
- (void) setImgWidth:(int)size
{
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].width = '%d'", i, size];
        [self stringByEvaluatingJavaScriptFromString:jsString];
        jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].style.width = '%dpx'", i, size];
        [self stringByEvaluatingJavaScriptFromString:jsString];
    }
}
/// 改变所有图像的高度
- (void) setImgHeight:(int)size
{
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].height = '%d'", i, size];
        [self stringByEvaluatingJavaScriptFromString:jsString];
        jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].style.height = '%dpx'", i, size];
        [self stringByEvaluatingJavaScriptFromString:jsString];
    }
}
/// 改变指定标签的字体颜色
- (void)setFontColor:(UIColor *)color withTag:(NSString *)tagName
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var nodes = document.getElementsByTagName('%@'); \
                          for(var i=0;i<nodes.length;i++){\
                          nodes[i].style.color = '%@';}", tagName, [color webColorString]];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/// 改变指定标签的字体大小
- (void)setFontSize:(int)size withTag:(NSString *)tagName
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var nodes = document.getElementsByTagName('%@'); \
                          for(var i=0;i<nodes.length;i++){\
                          nodes[i].style.fontSize = '%dpx';}", tagName, size];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/**
 *  @brief  清空cookie
 */
- (void)clearCookies
{
    NSHTTPCookieStorage *storage = NSHTTPCookieStorage.sharedHTTPCookieStorage;
    
    for (NSHTTPCookie *cookie in storage.cookies)
        [storage deleteCookie:cookie];
    
    [NSUserDefaults.standardUserDefaults synchronize];
}
/**
 *  @brief  是否显示阴影
 *
 *  @param b 是否显示阴影
 */
- (void)setShadowViewHidden:(BOOL)b{
    for (UIView *aView in [self subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)aView setShowsHorizontalScrollIndicator:NO];
            for (UIView *shadowView in aView.subviews)
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                {
                    shadowView.hidden = b;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                }
            }
        }
    }
}
/**
 *  @brief  是否显示水平滑动指示器
 *
 *  @param b 是否显示水平滑动指示器
 */
- (void)setShowsHorizontalScrollIndicator:(BOOL)b{
    for (UIView *aView in [self subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)aView setShowsHorizontalScrollIndicator:b];
        }
    }
}
/**
 *  @brief  是否显示垂直滑动指示器
 *
 *  @param b 是否显示垂直滑动指示器
 */
- (void)setShowsVerticalScrollIndicator:(BOOL)b{
    for (UIView *aView in [self subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)aView setShowsVerticalScrollIndicator:b];
        }
    }
}
/**
 *  @brief  网页透明
 */
-(void) makeTransparent
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
}
/**
 *  @brief  网页透明移除阴影
 */
-(void) makeTransparentAndRemoveShadow
{
    [self makeTransparent];
    [self setShadowViewHidden:YES];
}
@end
