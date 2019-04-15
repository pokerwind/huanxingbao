//
//  DZMeVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMeVC.h"
#import "DZSettingVC.h"
#import "DZMessageVC.h"
#import "DZPersonalInfoVC.h"
#import "DZMyOrderVC.h"
#import "DZProblemOrderVC.h"
#import "DZGoodsCollectionVC.h"
#import "DZShopCollectionVC.h"
#import "DZMyHistoryVC.h"
#import "DZMyBalanceVC.h"
#import "DZMyAddressVC.h"
#import "DZHelpCenterVC.h"
#import "DZCustomerServiceVC.h"
#import "DZOpenSTShopVC.h"
#import "DZOpenGCShopVC.h"
#import "DZOpenWPShopVC.h"
#import "DZSellerTabBarVC.h"
#import "JSMessageListViewController.h"
#import "DZMeHeaderView.h"
#import "DZMeCell.h"
#import "DZOpenShopSelectionView.h"

#import "DPMobileApplication.h"
#import "DZCustomerServiceModel.h"
#import "ChatViewController.h"
//#import "DZSellerMeVC.h"
#import "MainTabBarController.h"
#import "DZOpenGCShopVC.h"
#import "AFreeTrialVC.h"

#import "DZLexzViewController.h"
#import "THTeamVC.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import<ShareSDKUI/SSUIShareActionSheetStyle.h>

#import <LinkedME_iOS/LMLinkProperties.h>
#import <LinkedME_iOS/LMUniversalObject.h>
#define H5_LIVE_URL @""

@interface DZMeVC ()<UITableViewDelegate, UITableViewDataSource, DZMeHeaderDelegate, DZOpenShopSelectionViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DZMeHeaderView *headerView;
@property (nonatomic, strong) UIImageView *switchImageView;
@property (nonatomic, strong) UILabel *switchLabel;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *settingButton;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) DZOpenShopSelectionView *shopSelectionView;

@property (nonatomic, strong) DZCustomerServiceModel *customerService;

@property(nonatomic,strong) LMUniversalObject *linkedUniversalObject;

@end

@implementation DZMeVC
static  NSString  *CellIdentiferId = @"DZMeCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.switchImageView];
    [self.view addSubview:self.switchLabel];
    [self.view addSubview:self.settingButton];
    [self.view addSubview:self.messageButton];
    [self.view addSubview:self.numLabel];
    [self.view addSubview:self.switchButton];
    
    [self updateMessageCount];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReceiveMessage" object:nil] subscribeNext:^(id x) {
        [self updateMessageCount];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:USERINFOUPDATEDNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewData) name:USERORDERINFOUPDATEDNOTIFICATION object:nil];

    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadCustomerServiceInfo];
}

- (void)viewDidLayoutSubviews{
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZOpenShopSelectionViewDelegate ----
- (void)didSelectShopType:(NSInteger)type{
    [self hideShopSelectionView];
    DZOpenSTShopVC *vc = [DZOpenSTShopVC new];
    [self.navigationController pushViewController:vc animated:YES];
//    switch (type) {
//        case 0:{
//            DZOpenSTShopVC *vc = [DZOpenSTShopVC new];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 1:{
//            DZOpenGCShopVC *vc = [DZOpenGCShopVC new];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 2:{
//            DZOpenWPShopVC *vc = [DZOpenWPShopVC new];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        default:
//            break;
//    }
}

#pragma mark - ---- DZMeHeaderDelegate ----
- (void)didClickHeaderAtIndex:(NSInteger)index{
    switch (index) {
        case 0://个人信息
            [self.navigationController pushViewController:[DZPersonalInfoVC new] animated:YES];
            break;
        case 1:{//我的订单
            DZMyOrderVC *vc = [DZMyOrderVC new];
            vc.currentSelection = 0;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{//待付款
            DZMyOrderVC *vc = [DZMyOrderVC new];
            vc.currentSelection = 1;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:{//待发货
            DZMyOrderVC *vc = [DZMyOrderVC new];
            vc.currentSelection = 2;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:{//待收货
            DZMyOrderVC *vc = [DZMyOrderVC new];
            vc.currentSelection = 3;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:{//待评价
            DZMyOrderVC *vc = [DZMyOrderVC new];
            vc.currentSelection = 4;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6:{//退货退款
            DZProblemOrderVC *vc = [DZProblemOrderVC new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self.navigationController pushViewController:[AFreeTrialVC new] animated:YES];
                break;
            case 1:
                [self.navigationController pushViewController:[DZGoodsCollectionVC new] animated:YES];
                break;
            case 2:
                [self.navigationController pushViewController:[DZShopCollectionVC new] animated:YES];
                break;
//            case 2:
//                [self.navigationController pushViewController:[DZMyHistoryVC new] animated:YES];
//                break;
            case 3:
                [self.navigationController pushViewController:[DZMyBalanceVC new] animated:YES];
                break;
            case 4:
                [self.navigationController pushViewController:[DZMyAddressVC new] animated:YES];
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                [SVProgressHUD show];
                LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/DeepLinkApi/share" parameters:@{@"token":[DPMobileApplication sharedInstance].loginUser.token}];
                __weak typeof(self) weakSelf = self;
                [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                    [SVProgressHUD dismiss];
                    NSDictionary *dict = request.responseJSONObject;
                    if ([dict[@"status"] integerValue] == 1) {
                        [weakSelf shudutuiguangAction:dict[@"data"]];
                    }else{
                        [SVProgressHUD showErrorWithStatus:dict[@"info"]];
                    }
                } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"网络获取失败"];
                }];
            }
                break;
            case 1:
            {
                //获取当前时间
                NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *comps = [[NSDateComponents alloc] init];
                NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
                comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
                NSInteger year=[comps year];
                NSInteger month=[comps month];
                THTeamVC *team = [[THTeamVC alloc]init];
                team.dateStr = [NSString stringWithFormat:@"%.2ld-%.2ld",year,month];
                [self.navigationController pushViewController:team animated:YES];
            }
//                [self.navigationController pushViewController:[DZHelpCenterVC new] animated:YES];
                break;
//            case 2:
//                [self.navigationController pushViewController:[DZHelpCenterVC new] animated:YES];
//                break;
            case 2:
                //[self.navigationController pushViewController:[DZCustomerServiceVC new] animated:YES];
                //直接与客服聊天
                [self contactCustomerService];
                break;
            default:
                break;
        }
    }
}
- (void)shudutuiguangAction:(NSDictionary *)dic{
    //分享
    self.linkedUniversalObject = [[LMUniversalObject alloc] init];
    self.linkedUniversalObject.title = @"标题";//标题
    LMLinkProperties *linkProperties = [[LMLinkProperties alloc] init];
    linkProperties.channel = @"微信";//渠道(微信,微博,QQ,等...)
    linkProperties.feature = @"Share";//特点
    linkProperties.tags=@[@"LinkedME",@"Demo"];//标签
    linkProperties.stage = @"Live";//阶段
    [linkProperties addControlParam:@"parent_id" withValue:dic[@"parent_id"]];//自定义参数，用于在深度链接跳转后获取该数据，这里代表页面唯一标识
//    [linkProperties addControlParam:@"LinkedME" withValue:@"Demo"];//自定义参数，用于在深度链接跳转后获取该数据，这里标识是Demo
    //开始请求短链
    
    [self.linkedUniversalObject getShortUrlWithLinkProperties:linkProperties andCallback:^(NSString *url, NSError *err) {
        NSString *liveURLStr = @"";
        if (url) {
            NSLog(@"[LinkedME Info] SDK creates the url is:%@", url);
            //拼接连接1
            //            [H5_LIVE_URL stringByAppendingString:arr[page][@"form"]];
            //            [H5_LIVE_URL stringByAppendingString:@"?linkedme="];
            liveURLStr = [NSString stringWithFormat:@"%@?linkedme=%@&parent_id=%@",dic[@"url"],url,dic[@"parent_id"]];
            //前面是Html5页面,后面拼上深度链接https://xxxxx.xxx (html5 页面地址) ?linkedme=(深度链接)
            //https://www.linkedme.cc/h5/feature?linkedme=https://lkme.cc/AfC/mj9H87tk7
//            liveURLStr = [liveURLStr stringByAppendingString:];
//            liveURLStr = url;
//            liveURLStr = url;
        } else {
            liveURLStr = dic[@"url"];
            //            LINKEDME_SHORT_URL = H5_LIVE_URL;
        }
        
        /*分享分享*/
        //1、创建分享参数
        NSArray* imageArray = @[dic[@"icon"]];
        //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:dic[@"content"]
                                             images:imageArray
                                                url:[NSURL URLWithString:liveURLStr]
                                              title:dic[@"title"]
                                               type:SSDKContentTypeAuto];
            //有的平台要客户端分享需要加此方法，例如微博
            //[shareParams SSDKEnableUseClientShare];
            //设置简介版UI 需要  #import <ShareSDKUI/SSUIShareActionSheetStyle.h>
            [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            NSArray *items = nil;
            items = @[@(SSDKPlatformTypeQQ),
                      @(SSDKPlatformTypeWechat),
                      ];
            [ShareSDK showShareActionSheet:self.view //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:items
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];}
        
        
        
    }];
}
#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZMeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZMeCell" owner:nil options:nil] lastObject];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [cell fillIcon:@"免费试用" title:@"我的试用" hasNew:NO     subTitle:nil];
                break;
            case 1:
                [cell fillIcon:@"my_icon_collection" title:@"商品收藏" hasNew:NO     subTitle:nil];
                break;
            case 2:
                [cell fillIcon:@"my_icon_follow" title:@"店铺关注" hasNew:NO subTitle:nil];
                break;
//            case 2:
//                [cell fillIcon:@"my_icon_foot" title:@"我的足迹" hasNew:NO subTitle:nil];
//                break;
            case 3:
                [cell fillIcon:@"my_icon_balance" title:@"我的余额" hasNew:NO subTitle:nil];
                break;
            case 4:
                [cell fillIcon:@"my_icon_address" title:@"收货地址" hasNew:NO subTitle:nil];
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                [cell fillIcon:@"tuiguang" title:@"我要推广" hasNew:NO subTitle:nil];
                break;
            case 1:
                [cell fillIcon:@"tuandui" title:@"我的团队" hasNew:NO subTitle:nil];
                break;
//            case 2:
//                [cell fillIcon:@"my_icon_help" title:@"帮助中心" hasNew:NO subTitle:nil];
//                break;
            case 2:
                [cell fillIcon:@"my_icon_service" title:@"联系客服" hasNew:NO subTitle:nil];
                break;
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)switchButtonAction{
    if ([self.switchLabel.text isEqualToString:@"切换为卖家"] || [self.switchLabel.text isEqualToString:@"我要开店"]) {
        NSLog(@"切换为卖家");
        if (self.customerService.has_shop == 0) {
            DZLexzViewController *lexVC = [[DZLexzViewController alloc]init];
            lexVC.source = 2;
            [self.navigationController pushViewController:lexVC animated:YES];
//            DZOpenGCShopVC *dzvc = [[DZOpenGCShopVC alloc]init];
//            [self.navigationController pushViewController:dzvc animated:YES];
//            NSDictionary *params = @{@"token":[DPMobileApplication sharedInstance].loginUser.token};
//            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/ShopEditApi/apply_start_shop" parameters:params];
//
////            __weak typeof(self) weakSelf = self;
//            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//
//                NSDictionary *dict = request.responseJSONObject;
//                if ([dict[@"status"] integerValue] == 1) {
//                    NSDictionary *dic = request.rawJSONObject;
//                    NSArray *array = dic[@"data"];
//                    self.shopSelectionView.dataArray = array;
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self showShopSelectionView];
//                    });
//                }else{
//                    [SVProgressHUD showErrorWithStatus:dict[@"info"]];
//                }
//            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//
//                [SVProgressHUD showErrorWithStatus:error.domain];
//            }];
        }else {
            DZSellerTabBarVC *vc = [DZSellerTabBarVC new];
            vc.selectedIndex = 4;
            [UIApplication sharedApplication].delegate.window.rootViewController = vc;
        }
    }else if ([self.switchLabel.text isEqualToString:@"切换为买家"]){
        MainTabBarController *vc = [MainTabBarController new];
         vc.selectedIndex = 4;
        [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    }
}

- (void)settingButtonAction{
    DZSettingVC *vc = [DZSettingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageButtonAction{
    JSMessageListViewController *vc = [JSMessageListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- 私有方法 ----
- (void)updateMessageCount {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    int count = 0;
    for (EMConversation *em in conversations) {
        count += [em unreadMessagesCount];
    }
    if (count > 0) {
        self.numLabel.hidden = NO;
        self.numLabel.text = [NSString stringWithFormat:@"%d",count];
        if (count>99) {
            self.numLabel.text = @"99+";
        }
    } else {
        self.numLabel.hidden = YES;
    }
}

- (void)getNewData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getOrderStatusCount" parameters:params];
    
    __weak typeof(self) weakSelf = self;
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"status"] integerValue] == 1) {
            weakSelf.headerView.unPaidCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"data"][@"status_1"]];
            weakSelf.headerView.unSendCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"data"][@"status_2"]];
            weakSelf.headerView.unRecCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"data"][@"status_3"]];
            weakSelf.headerView.unCommentCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"data"][@"status_4"]];
            weakSelf.headerView.unSuccessCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"data"][@"status_5"]];
        }else{
            [SVProgressHUD showErrorWithStatus:dict[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
    
    [[DPMobileApplication sharedInstance] updateUserInfo];
}

- (void)showShopSelectionView{
    [[UIApplication sharedApplication].delegate.window addSubview:self.maskView];
    [[UIApplication sharedApplication].delegate.window addSubview:self.shopSelectionView];
    [UIView animateWithDuration:.3 animations:^{
        self.shopSelectionView.frame = CGRectMake(0, SCREEN_HEIGHT - self.shopSelectionView.height, self.shopSelectionView.width, self.shopSelectionView.height);
    }];
}

- (void)hideShopSelectionView{
    [self.maskView removeFromSuperview];
    [UIView animateWithDuration:.1 animations:^{
        self.shopSelectionView.frame = CGRectMake(0, SCREEN_HEIGHT, self.shopSelectionView.width, self.shopSelectionView.height);
    } completion:^(BOOL finished) {
        [self.shopSelectionView removeFromSuperview];
    }];
}

- (void)refreshUserInfo{
    self.headerView.nickNameLabel.text = [DPMobileApplication sharedInstance].loginUser.nickname;
    
    if ([DPMobileApplication sharedInstance].loginUser.head_pic.length) {
        [self.headerView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, [DPMobileApplication sharedInstance].loginUser.head_pic]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    }
    self.headerView.vipLabel.text = [DPMobileApplication sharedInstance].loginUser.user_level;
    
//    if ([DPMobileApplication sharedInstance].loginUser.is_shop) {
//        self.switchLabel.text = @"切换为卖家";
//    }else{
//        self.switchLabel.text = @"切换为买家";
//    }
}
- (void)loadCustomerServiceInfo {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/UserCenterApi/getUserInfo"];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZCustomerServiceNetModel *model = [DZCustomerServiceNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.customerService = model.data;
            if (self.customerService.has_shop == 0) {
                self.switchLabel.text = @"我要开店";
            }else {
                self.switchLabel.text = @"切换为卖家";
            }
            [DPMobileApplication sharedInstance].loginUser.shop_id = model.data.shop_id;
            [[DPMobileApplication sharedInstance] setLoginUser:[DPMobileApplication sharedInstance].loginUser];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)contactCustomerService {
    if (!self.customerService) {
        return;
    }
    if (![DPMobileApplication sharedInstance].isLogined) {
        //处理未登录情况
        return;
    }
    
    if ([EMClient sharedClient].currentUsername) {
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.customerService.chat_username conversationType:0];
        chatController.real_name = self.customerService.chat_nickname;
        chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,self.customerService.chat_headpic];
        chatController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatController animated:YES];
    } else {
        //没有环信用户名，重试登录？
        DZUserModel *user = [DPMobileApplication sharedInstance].loginUser;
        [[EMClient sharedClient] loginWithUsername:user.emchat_username
                                          password:user.emchat_password
                                        completion:^(NSString *aUsername, EMError *aError) {
                                            if (!aError) {
                                                ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.customerService.chat_username conversationType:0];
                                                chatController.real_name = self.customerService.chat_nickname;
                                                chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,self.customerService.chat_headpic];
                                                chatController.hidesBottomBarWhenPushed = YES;
                                                [self.navigationController pushViewController:chatController animated:YES];
                                            }else {
                                                [SVProgressHUD showInfoWithStatus:@"客服正忙，请稍后尝试"];
                                            }
                                        }];
    }
    
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.switchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(5 + KStatusBarH);
    }];
    [self.switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.switchImageView);
        make.left.mas_equalTo(self.switchImageView.mas_right);
    }];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_equalTo(self.switchImageView);
        make.right.mas_equalTo(-12);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageButton.mas_right).mas_offset(-10);
        make.bottom.equalTo(self.messageButton.mas_top).mas_offset(10);
        make.height.mas_equalTo(13);
        make.width.mas_greaterThanOrEqualTo(13);
    }];
    
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.mas_equalTo(self.messageButton);
        make.right.mas_equalTo(self.messageButton.mas_left).with.offset(-10);
    }];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.switchLabel);
        make.left.mas_equalTo(self.switchImageView);
    }];
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = self.headerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getNewData];
        }];
        //修复下拉刷新错位
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

- (DZMeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"DZMeHeaderView" owner:self options:nil] lastObject];
        _headerView.delegate = self;
        if ([DPMobileApplication sharedInstance].loginUser.head_pic.length) {            
            [_headerView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, [DPMobileApplication sharedInstance].loginUser.head_pic]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
        }
        if ([DPMobileApplication sharedInstance].loginUser.nickname) {
            _headerView.nickNameLabel.text = [DPMobileApplication sharedInstance].loginUser.nickname.length?[DPMobileApplication sharedInstance].loginUser.nickname:@"未设置";
        }
        _headerView.vipLabel.text = [DPMobileApplication sharedInstance].loginUser.user_level;
    }
    return _headerView;
}

- (UIImageView *)switchImageView{
    if (!_switchImageView) {
        _switchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_icon_switch"]];
    }
    return _switchImageView;
}

- (UILabel *)switchLabel{
    if (!_switchLabel) {
        _switchLabel = [UILabel new];
        _switchLabel.textColor = [UIColor whiteColor];
        _switchLabel.font = [UIFont systemFontOfSize:14];
        _switchLabel.text = @"切换为卖家";
    }
    return _switchLabel;
}

- (UIButton *)switchButton{
    if (!_switchButton) {
        _switchButton = [UIButton new];
        [_switchButton addTarget:self action:@selector(switchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UIButton *)settingButton{
    if (!_settingButton) {
        _settingButton = [UIButton new];
        [_settingButton setImage:[UIImage imageNamed:@"my_icon_setting"] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(settingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

- (UIButton *)messageButton{
    if (!_messageButton) {
        _messageButton = [UIButton new];
        [_messageButton setImage:[UIImage imageNamed:@"my_icon_massage"] forState:UIControlStateNormal];
        [_messageButton addTarget:self action:@selector(messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}

- (UILabel *)numLabel {
    if(!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.backgroundColor = HEXCOLOR(0xFF7722);
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.font = [UIFont systemFontOfSize:10];
        _numLabel.layer.masksToBounds = YES;
        _numLabel.layer.cornerRadius = 6;
        _numLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _numLabel;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShopSelectionView)]];
    }
    return _maskView;
}

- (DZOpenShopSelectionView *)shopSelectionView{
    if (!_shopSelectionView) {
        _shopSelectionView = [DZOpenShopSelectionView viewFormNib];
        _shopSelectionView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 255);
        _shopSelectionView.delegate = self;
    }
    return _shopSelectionView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USERINFOUPDATEDNOTIFICATION object:nil];
}

@end
