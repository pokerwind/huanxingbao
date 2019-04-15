//
//  DZSellerTabBarVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/24.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSellerTabBarVC.h"
#import "LNNavigationController.h"

#import "DZHomeVC.h"                    // 首页
#import "DZFindViewController.h"                  // 圈子
#import "DZCreateGoodVC.h"              //上传新产品
#import "DZFindVC.h"                    // 找货
#import "DZSellerMeVC.h"
#import "DZCartVC.h"
#import "DZMeVC.h"
#import "JSSucceedTipViewController.h"
#import "JSShopListViewController.h"
#import "DeviceTypeTableViewController.h"

@interface DZSellerTabBarVC ()<UIAlertViewDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UINavigationController *flagVC;

@end

@implementation DZSellerTabBarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setupSubviews];
    self.selectedIndex = 0;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == self.flagVC) {
        DZCreateGoodVC *vc = [DZCreateGoodVC new];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.flagVC presentViewController:nvc animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

}

#pragma mark - private

- (void)setupSubviews
{
//    // 设置标题的颜色
//    //    NSDictionary * dict=[NSDictionary dictionaryWithObject:TextGoldColor forKey:NSForegroundColorAttributeName];
//    NSDictionary * dict = @{
//                            NSForegroundColorAttributeName:NaviBarTitleColor,
//                            NSFontAttributeName:[UIFont systemFontOfSize:16]
//                            };
//    [[UINavigationBar appearance] setTitleTextAttributes:dict];
//    // 设置left right NavItem 颜色
//    [[UINavigationBar appearance] setTintColor:NaviBarItemColor];
//    // 设置 UINavigationBar 背景色
//    [[UINavigationBar appearance] setBarTintColor:ThemeColor];
//
//    // 去掉黑线 不透明 NavigationBar
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:ThemeColor]
//                                      forBarPosition:UIBarPositionAny
//                                          barMetrics:UIBarMetricsDefault];
//    //    // 去掉阴影
//    //    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
//
//    // 自定义返回按钮 图片
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"icon_back"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"icon_back"]];
//
//    //     把返回按钮的 文字设置到屏幕外
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0)
//                                                         forBarMetrics:UIBarMetricsDefault];
//
//    if (true) { // 不隐藏全局的 TabBar
//        // 设置 TabBar 不透明
//        [UITabBar appearance].translucent = NO;
//    } else {    // 隐藏全局的 TabBar
//        // 因为要隐藏 TabBar 所以 TabBar 大小要到底 所以 UITabBar 不能不透明
//        [UITabBar appearance].translucent = YES;
//        [self.tabBar setHidden:YES];
//    }
//
//    // 设置 TabBar 颜色为黑色
//    [[UITabBar appearance] setBarTintColor:ThemeColor];
//
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TextLightColor}
//                                             forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TextGoldColor}
//                                             forState:UIControlStateSelected];
    
    
//    DZHomeVC *home            = [[DZHomeVC alloc] init];
//    LNNavigationController *homeNav     = [[LNNavigationController alloc] initWithRootViewController:home];
//    homeNav.tabBarItem = [self tabBarWithTitle:@"首页" image:@"tab_icon_home_n" selectedImage:@"tab_icon_home_s"];
//
//    DZCircleVC *message = [[DZCircleVC alloc] init];
//    LNNavigationController *messageNav     = [[LNNavigationController alloc] initWithRootViewController:message];
//    messageNav.tabBarItem = [self tabBarWithTitle:@"圈子" image:@"tab_icon_group_n" selectedImage:@"tab_icon_group_s"];
//
//    DZFindVC *send = [[DZFindVC alloc] init];
//    LNNavigationController *sendNav = [[LNNavigationController alloc] initWithRootViewController:send];
//    sendNav.tabBarItem = [self tabBarWithTitle:@"找货" image:@"tab_icon_class_n" selectedImage:@"tab_icon_class_s"];
//
//    UIViewController *vc = [[UIViewController alloc] init];
//    self.flagVC = [[LNNavigationController alloc] initWithRootViewController:vc];
//    self.flagVC.tabBarItem = [self tabBarWithTitle:nil image:nil selectedImage:nil];
//
//    DZSellerMeVC *me              = [[DZSellerMeVC alloc]  init];
//    LNNavigationController *meNav       = [[LNNavigationController alloc] initWithRootViewController:me];
//    meNav.tabBarItem = [self tabBarWithTitle:@"我的" image:@"tab_icon_me_n" selectedImage:@"tab_icon_me_s"];
//
//    self.viewControllers                = @[homeNav,messageNav,self.flagVC,sendNav,meNav];
    
    DZHomeVC *home            = [[DZHomeVC alloc] init];
    LNNavigationController *homeNav     = [[LNNavigationController alloc] initWithRootViewController:home];
    homeNav.tabBarItem = [self tabBarWithTitle:@"首页" image:@"tab_icon_home_n" selectedImage:@"tab_icon_home_s"];
    
    DZFindViewController *message = [[DZFindViewController alloc] init];
    LNNavigationController *messageNav     = [[LNNavigationController alloc] initWithRootViewController:message];
    messageNav.tabBarItem = [self tabBarWithTitle:@"发现" image:@"tab_icon_group_n" selectedImage:@"tab_icon_group_s"];
    
    JSShopListViewController *send = [[JSShopListViewController alloc] init];
    LNNavigationController *sendNav = [[LNNavigationController alloc] initWithRootViewController:send];
    sendNav.tabBarItem = [self tabBarWithTitle:@"店铺" image:@"tab_icon_class_n" selectedImage:@"tab_icon_class_s"];
    
//    JSSucceedTipViewController *find = [[JSSucceedTipViewController alloc] init];
//    find.title = @"敬请期待";
//    find.image = @"JSJingqingqidai";
//    find.tipStr = @"正在开发 敬请期待...";
//    LNNavigationController *findNav = [[LNNavigationController alloc] initWithRootViewController:find];
//    findNav.tabBarItem = [self tabBarWithTitle:@"设备" image:@"tab_icon_cart_n" selectedImage:@"tab_icon_cart_s"];
    DeviceTypeTableViewController *dvc = [DeviceTypeTableViewController new];
    CustomNaviViewController *dNavi = [[CustomNaviViewController alloc]initWithRootViewController:dvc];
    dNavi.tabBarItem = [self tabBarWithTitle:@"设备" image:@"tab_icon_cart_n" selectedImage:@"tab_icon_cart_s"];
    
//    DZMeVC *me              = [[DZMeVC alloc]  init];
//    LNNavigationController *meNav       = [[LNNavigationController alloc] initWithRootViewController:me];
//    meNav.tabBarItem = [self tabBarWithTitle:@"我的" image:@"tab_icon_me_n" selectedImage:@"tab_icon_me_s"];
    
    DZSellerMeVC *me              = [[DZSellerMeVC alloc]  init];
    LNNavigationController *meNav       = [[LNNavigationController alloc] initWithRootViewController:me];
    meNav.tabBarItem = [self tabBarWithTitle:@"我的" image:@"tab_icon_me_n" selectedImage:@"tab_icon_me_s"];
    
    self.viewControllers                = @[homeNav,messageNav,sendNav,dNavi,meNav];
    
    UIImageView *igv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    igv.image = [UIImage imageNamed:@"tab_icon_add"];
    igv.center = CGPointMake(SCREEN_WIDTH * 0.5, 25);
    [self.tabBar addSubview:igv];
}

- (UITabBarItem *)tabBarWithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    UITabBarItem *tabBar = [[UITabBarItem alloc] initWithTitle:title
                                                         image:[self tabBarImage:image]
                                                 selectedImage:[self tabBarImage:selectedImage]];
    [tabBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEXCOLOR(0xff7722),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    return tabBar;
}

- (UIImage *)tabBarImage:(NSString *)imageNamed{
    return [[UIImage imageNamed:imageNamed] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
