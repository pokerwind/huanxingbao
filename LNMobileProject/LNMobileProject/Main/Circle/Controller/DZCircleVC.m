//
//  DZCircleVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCircleVC.h"
#import "HMSegmentedControl.h"
#import "DZCircleNavTitleView.h"
#import "DZNewsVC.h"
#import "DZChatroomVC.h"
#import "DZNewsPublishVC.h"
#import "DZGoodsDetailVC.h"
#import "DZShopCollectModel.h"
#import "DZShopDetailVC.h"
#import "DZMessageVC.h"
#import "DZEMChatUserModel.h"
#import "ChatViewController.h"
#import "JSMessageListViewController.h"

@interface DZCircleVC ()
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) DZCircleNavTitleView *navView;
@property (nonatomic, strong) DZNewsVC *newsVC;
@property (nonatomic, strong) DZChatroomVC *chatVC;
@end

@implementation DZCircleVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setupNavigationBar];
    [self.view addSubview:self.navView];
    [self.navView.segmentContainerView addSubview:self.segmentedControl];
    [self addChildViewController:self.newsVC];
    [self addChildViewController:self.chatVC];
    
    [self.view addSubview:self.containerView];
    
    [self setupChildController:[self.childViewControllers firstObject]];
    //[self.view addSubview:self.segmentedControl];

    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSubViewsFrame];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark - ---- 代理相关 ----

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----
- (void)setupChildController:(UIViewController *)viewController{
    [[self.containerView.subviews firstObject] removeFromSuperview];
    if (viewController) {
        [self.containerView addSubview:viewController.view];
        [viewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    
}
//- (void)chat:(NSString *)shopId {
//    if(![self checkLogin]) {
//        return;
//    }
//
//    if ([DPMobileApplication sharedInstance].isShowing) {
//        return;
//    }
//
//    //[DPMobileApplication sharedInstance].isShowing = YES;
//
//    if ([DPMobileApplication sharedInstance].isLogined) {
//
//        if ([EMClient sharedClient].currentUsername) {
//            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/getShopEmchat" parameters:@{@"shop_id":shopId}];
//            //self.model.shop_info.shop_id
//            [SVProgressHUD show];
//            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//                [SVProgressHUD dismiss];
//                DZEMChatUserNetModel *model = [DZEMChatUserNetModel objectWithKeyValues:request.responseJSONObject];
//                if (model.isSuccess) {
//                    DZEMChatUserModel *em = model.data;
//                    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:em.emchat_username conversationType:0];
//                    //                    [[ChatViewController alloc] initWithConversationChatter:@"" conversationType:EMConversationTypeChatRoom];
//                    chatController.real_name = em.nickname;
//                    chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,em.head_pic];
//                    chatController.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:chatController animated:YES];
//                } else {
//                    [SVProgressHUD showInfoWithStatus:model.info];
//
//                }
//            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//                [SVProgressHUD dismiss];
//                [SVProgressHUD showErrorWithStatus:error.domain];
//            }];
//
//            //            SupportEmchatAPI *api = [[SupportEmchatAPI alloc] init];
//            //            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//            //                SupportEmchatModel *model = [SupportEmchatModel objectWithKeyValues:request.responseJSONObject];
//            //                if (model.status == 1) {
//            //
//            //                    Result *result = [Result objectWithKeyValues:model.result];
//            //                    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:result.emchat_username conversationType:0];
//            //                    chatController.real_name = result.nickname;
//            //                    chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_HOST,result.head_pic];
//            //                    chatController.hidesBottomBarWhenPushed = YES;
//            //                    // 传递产品信息
//            //                    chatController.isFromProductDetail = YES;
//            //                    chatController.commodityID = self.model.goods.goods_id;
//            //                    chatController.commodityName = self.model.goods.goods_name;
//            //                    chatController.commodityPrice = self.model.goods.shop_price;
//            //                    //NSString *urlString = [SPCommonUtils getThumbnailWithHost:FLEXIBLE_THUMBNAIL goodsID:Str(self.model.goods.goods_id)];
//            //                    NSString *urlString = self.model.goods.original_img;
//            //                    chatController.commodityImage = urlString;
//            //                    [self.navigationController pushViewController:chatController animated:YES];
//            //
//            //                }
//            //            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//            //            }];
//        }else {
//            //            GGUserModel *user = [SPMobileApplication sharedInstance].loginUser;
//            //            // 登录环信
//            //            [[EMClient sharedClient] loginWithUsername:user.emchat_username
//            //                                              password:user.emchat_password
//            //                                            completion:^(NSString *aUsername, EMError *aError) {
//            //                                                if (!aError) {
//            //                                                    SupportEmchatAPI *api = [[SupportEmchatAPI alloc] init];
//            //                                                    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//            //                                                        SupportEmchatModel *model = [SupportEmchatModel objectWithKeyValues:request.responseJSONObject];
//            //                                                        if (model.status == 1) {
//            //                                                            Result *result = [Result objectWithKeyValues: model.result];
//            //                                                            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:result.emchat_username conversationType:0];
//            //                                                            chatController.real_name = result.nickname;
//            //                                                            chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_HOST,result.head_pic];
//            //                                                            [self.navigationController pushViewController:chatController animated:YES];
//            //
//            //                                                        }
//            //                                                    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//            //                                                    }];
//            //                                                }else {
//            //                                                    [self showTextOnly:@"客服正忙，请稍后尝试"];
//            //                                                }
//            //                                            }];
//        }
//    }else {
//        //[[NSNotificationCenter defaultCenter] postNotificationName:NotificationTokenExpire object:nil];
//    }
//
//}
//
#pragma mark - ---- 布局代码 ----
- (void)setupNavigationBar {
    DZCircleNavTitleView *titleView = [DZCircleNavTitleView viewFormNib];
    self.navigationItem.titleView = titleView;
    
    [titleView.segmentContainerView addSubview:self.segmentedControl];
}

- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(KNavigationBarH);
    }];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.right.bottom.mas_offset(0);
    }];
    
    
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.bottom.left.right.mas_offset(0);
    }];
}

#pragma mark - --- getters 和 setters ----
- (DZCircleNavTitleView *)navView {
    if(!_navView) {
        _navView = [DZCircleNavTitleView viewFormNib];
        @weakify(self);
        [[_navView.messageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            JSMessageListViewController *vc = [JSMessageListViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _navView;
}

- (HMSegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl=[[HMSegmentedControl alloc] initWithSectionTitles:@[@"最新动态",@"聊天室"]];
        
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectionIndicatorColor=OrangeColor;
        _segmentedControl.selectionIndicatorHeight=1;
        _segmentedControl.borderWidth=1;
        _segmentedControl.borderColor=[UIColor colorWithRed:0.965f green:0.965f blue:0.965f alpha:1.00f];
        
        NSDictionary *selectdefaults = @{
                                         NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                                         NSForegroundColorAttributeName : OrangeColor,
                                         };
        NSMutableDictionary *selectresultingAttrs = [NSMutableDictionary dictionaryWithDictionary:selectdefaults];
        
        NSDictionary *defaults = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                                   NSForegroundColorAttributeName : TextBlackColor,
                                   };
        NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];
        _segmentedControl.selectedTitleTextAttributes=selectresultingAttrs;
        _segmentedControl.titleTextAttributes=resultingAttrs;
        //_segmentedControl.selectedSegmentIndex=0;
        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        @weakify(self);
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            @strongify(self) ;
            NSLog(@"segmentedControl = %zd",index);
            UIViewController *vc = [self.childViewControllers objectAtIndex:index];
            [self setupChildController:vc];
        };
    }
    return _segmentedControl;
}

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (DZNewsVC *)newsVC {
    if(!_newsVC) {
        _newsVC = [[DZNewsVC alloc] init];
        @weakify(self);
        [_newsVC.releaseSubject subscribeNext:^(id x) {
            @strongify(self);
            DZNewsPublishVC *vc = [[DZNewsPublishVC alloc] init];
            [vc.refreshSubject subscribeNext:^(id x) {
                [self.newsVC reload];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [_newsVC.clickSubject subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            RACTupleUnpack(NSString *act,id info) = tuple;
            NSLog(@"do %@ : %@",act,info);
            if ([act isEqualToString: @"goods"]) {
                DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
                vc.goodsId = info;
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([act isEqualToString: @"follow"]) {
                
                if(![self checkLogin]) {
                    return;
                }
                
                NSString *shopId = info;
                //关注店铺
                LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/collectShop" parameters:@{@"shop_id":shopId}];
                
                [SVProgressHUD show];
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    [SVProgressHUD dismiss];
                    DZShopCollectNetModel *model = [DZShopCollectNetModel objectWithKeyValues:request.responseJSONObject];
                    [SVProgressHUD showInfoWithStatus:model.info];
                    if (model.isSuccess) {
                        NSString *isFollow;
                        if ([model.data isEqualToString:@"1"]) {
                            isFollow = @"1";
                        } else if ([model.data isEqualToString:@"2"]) {
                            isFollow = @"0";
                        }
                        //更新数据，将此shopid对应的所有店铺动态，根据返回结果刷新。
                        [self.newsVC updateFollow:shopId status:isFollow];
                    }
                } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:error.domain];
                }];
            } else if ([act isEqualToString: @"shop"]) {
                //查看店铺详情
                DZShopDetailVC *vc = [[DZShopDetailVC alloc] init];
                vc.shopId = info;
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([act isEqualToString: @"show"]) {
                [self.newsVC refresh];
            } else if ([act isEqualToString: @"chat"]) {
                NSString *shopId = info;
                [self chat:shopId];
            }

        }];
    }
    return _newsVC;
}


- (DZChatroomVC *)chatVC {
    if(!_chatVC) {
        _chatVC = [[DZChatroomVC alloc] init];
    }
    return _chatVC;
}

@end
