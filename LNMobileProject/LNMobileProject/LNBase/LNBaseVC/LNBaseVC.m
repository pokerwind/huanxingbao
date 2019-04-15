//
//  LNBaseVC.m
//  LNBaseProject
//
//  Created by LiuNiu-MacMini-YQ on 2016/12/23.
//  Copyright © 2016年 LiuNiu-MacMini-YQ. All rights reserved.
//

#import "LNBaseVC.h"
#import "AppDelegate.h"
#import "DZSellerTabBarVC.h"
#import "DZLoginVC.h"
#import "LNNavigationController.h"
#import "DZEMChatUserModel.h"
#import "ChatViewController.h"

@interface LNBaseVC ()

@end

@implementation LNBaseVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"me_null"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

/**
 * 显示某选项卡
 */
-(void)showTabWithIndex:(NSInteger)selectIndex needSwitch:(BOOL)needSwitch showLogin:(BOOL)showLogin{
    
    if (needSwitch) {
        if ([AppDelegateInstance.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
            DZSellerTabBarVC *vc = [DZSellerTabBarVC new];
            [UIApplication sharedApplication].delegate.window.rootViewController = vc;
        }else{
            MainTabBarController *vc = [MainTabBarController new];
            [UIApplication sharedApplication].delegate.window.rootViewController = vc;
        }
    }
    
    ((UITabBarController *)AppDelegateInstance.window.rootViewController).selectedIndex = selectIndex;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    if (showLogin) {
        DZLoginVC *vc = [DZLoginVC new];
        LNNavigationController *nvc = [[LNNavigationController alloc] initWithRootViewController:vc];
        [((UITabBarController *)AppDelegateInstance.window.rootViewController) presentViewController:nvc animated:YES completion:nil];
    }
}

- (BOOL)checkLogin {
    if ([DPMobileApplication sharedInstance].isLogined) {
        return YES;
    }
    DZLoginVC *vc = [DZLoginVC new];
    LNNavigationController *nvc = [[LNNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
    
    return NO;
}

- (void)chat:(NSString *)shopId {
    if(![self checkLogin]) {
        return;
    }
    //检查是不是自己的店
    NSString *myShopId = [DPMobileApplication sharedInstance].loginUser.shop_id;
    if ([shopId isEqualToString:myShopId]) {
        [SVProgressHUD showErrorWithStatus:@"不能和自己聊天"];
        return;
    }
    
    if ([DPMobileApplication sharedInstance].isShowing) {
        return;
    }
    
    [DPMobileApplication sharedInstance].isShowing = YES;
    
    if ([DPMobileApplication sharedInstance].isLogined) {
        
        if ([EMClient sharedClient].currentUsername) {
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/getShopEmchat" parameters:@{@"shop_id":shopId}];
            //self.model.shop_info.shop_id
            [SVProgressHUD show];
            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                [SVProgressHUD dismiss];
                DZEMChatUserNetModel *model = [DZEMChatUserNetModel objectWithKeyValues:request.responseJSONObject];
                if (model.isSuccess) {
                    DZEMChatUserModel *em = model.data;
                    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:em.emchat_username conversationType:0];
                    //                    [[ChatViewController alloc] initWithConversationChatter:@"" conversationType:EMConversationTypeChatRoom];
                    chatController.real_name = em.nickname;
                    chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,em.head_pic];
                    chatController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:chatController animated:YES];
                } else {
                    [SVProgressHUD showInfoWithStatus:model.info];
                    
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:error.domain];
            }];

        }else {

        }
    }else {
        //[[NSNotificationCenter defaultCenter] postNotificationName:NotificationTokenExpire object:nil];
    }
    
}

- (void)chatWithInfo:(DZEMChatUserModel *)em {
    if(![self checkLogin]) {
        return;
    }
    //检查是不是自己
    NSString *emId = [DPMobileApplication sharedInstance].loginUser.emchat_username;
    
    if ([em.emchat_username isEqualToString:emId]) {
        [SVProgressHUD showErrorWithStatus:@"不能和自己聊天"];
        return;
    }
    
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:em.emchat_username conversationType:0];
    //                    [[ChatViewController alloc] initWithConversationChatter:@"" conversationType:EMConversationTypeChatRoom];
    chatController.real_name = em.nickname;
    chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,em.head_pic];
    chatController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark 空视图代理
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:@"me_null"];
//}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"没有数据";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
