/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "MainTabBarController.h"
#import "LNNavigationController.h"
#import "JSSucceedTipViewController.h"
// 子 ViewController
//#import "ViewController.h"

#import "DZHomeVC.h"                    // 首页
#import "DZFindViewController.h"                  // 圈子
#import "DZFindVC.h"                    // 找货
#import "DZCartVC.h"                    // 进货车
#import "DZMeVC.h"                      // 我的

#import "DZLoginVC.h"
#import "JSShopListViewController.h"
#import "DeviceListViewController.h"
#import "CustomNaviViewController.h"
#import "HomeViewController.h"
#import "DeviceTypeTableViewController.h"


@interface MainTabBarController () <UIAlertViewDelegate, UITabBarControllerDelegate>
//@property (nonatomic,strong) MeViewController *me;
@end

@implementation MainTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    self.delegate = self;

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){
    if (![DPMobileApplication sharedInstance].isLogined){
        UIViewController *vc = ((UINavigationController *)viewController).topViewController;
        if ([vc isKindOfClass:[DZCartVC class]] || [vc isKindOfClass:[DZMeVC class]]){            
            DZLoginVC *vc = [DZLoginVC new];
            LNNavigationController *nvc = [[LNNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nvc animated:YES completion:nil];
            return NO;
        }
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
//    HomeViewController *homeVc = [HomeViewController new];
//    CustomNaviViewController *dNavi = [[CustomNaviViewController alloc]initWithRootViewController:homeVc];
    
    DeviceTypeTableViewController *dvc = [DeviceTypeTableViewController new];
    CustomNaviViewController *dNavi = [[CustomNaviViewController alloc]initWithRootViewController:dvc];
    dNavi.tabBarItem = [self tabBarWithTitle:@"设备" image:@"tab_icon_cart_n" selectedImage:@"tab_icon_cart_s"];

    DZMeVC *me              = [[DZMeVC alloc]  init];
    LNNavigationController *meNav       = [[LNNavigationController alloc] initWithRootViewController:me];
    meNav.tabBarItem = [self tabBarWithTitle:@"我的" image:@"tab_icon_me_n" selectedImage:@"tab_icon_me_s"];

    self.viewControllers                = @[homeNav,messageNav,sendNav,dNavi,meNav];
    
//    UIImageView *calendar_img= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
//    calendar_img.image= [UIImage imageNamed:@"tabBar_add"];
//    calendar_img.center = CGPointMake(SCREEN_WIDTH*0.5, 25);
//    [self.tabBar addSubview:calendar_img];

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

-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    /*
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14], UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor,
                                        nil] forState:UIControlStateNormal];
     */
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    /*
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14],
                                        UITextAttributeFont,RGBACOLOR(0x00, 0xac, 0xff, 1),UITextAttributeTextColor,
                                        nil] forState:UIControlStateSelected];
     */
}

@end
