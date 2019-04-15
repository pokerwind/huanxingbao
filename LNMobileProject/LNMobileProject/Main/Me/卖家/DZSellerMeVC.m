//
//  DZSellerMeVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/24.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSellerMeVC.h"
#import "DZSettingVC.h"
#import "DZMessageVC.h"
#import "DZPersonalInfoVC.h"
#import "DZMyOrderVC.h"
#import "DZSellerProblemOrderVC.h"
#import "DZGoodManagmentVC.h"
#import "DZCurrentDataVC.h"
#import "DZMoneyManagementVC.h"
#import "DZCommentManagementVC.h"
#import "DZHelpCenterVC.h"
#import "DZCustomerServiceVC.h"
#import "MainTabBarController.h"
#import "DZFreightTemplateVC.h"
#import "DZBailVC.h"
#import "DZShopDetailVC.h"
#import "DZBailIntroVC.h"
#import "DZSTInfoVC.h"
#import "DZGCInfoVC.h"
#import "DZWPInfoVC.h"
#import "JSMessageListViewController.h"
#import "DZSellerMeHeaderView.h"
#import "DZMeCell.h"

#import "DPMobileApplication.h"
#import "DZOpenGCShopVC.h"

#import "DZGetOrderListModel.h"
#import "DZCustomerServiceModel.h"
#import "ChatViewController.h"

@interface DZSellerMeVC ()<UITableViewDelegate, UITableViewDataSource, DZSellerMeHeaderDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DZSellerMeHeaderView *headerView;
@property (nonatomic, strong) UIImageView *switchImageView;
@property (nonatomic, strong) UILabel *switchLabel;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIButton *settingButton;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *tipView;

@property (strong, nonatomic) DZGetOrderListModel *model;

@property (nonatomic, strong) DZCustomerServiceModel *customerService;

@property (nonatomic, strong) NSDictionary *shopInfoDict;

@end

@implementation DZSellerMeVC

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
    [self.view addSubview:self.tipView];
    
    [self updateMessageCount];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReceiveMessage" object:nil] subscribeNext:^(id x) {
        [self updateMessageCount];
    }];
    
//    [self loadCustomerServiceInfo];
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
    [self.tableView.mj_header beginRefreshing];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewData) name:SELLERMEVCREFRESHNOTIFICATION object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNewData];

}
- (void)viewDidLayoutSubviews{
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
}

#pragma mark - ---- 代理相关 ----

#pragma mark - ---- DZMeHeaderDelegate ----
- (void)didClickHeaderAtIndex:(NSInteger)index{
    switch (index) {
        case 0://个人信息
//            [self.navigationController pushViewController:[DZPersonalInfoVC new] animated:YES];
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
        case 5:{//退货退款
            DZSellerProblemOrderVC *vc = [DZSellerProblemOrderVC new];
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
                [self.navigationController pushViewController:[DZGoodManagmentVC new] animated:YES];
                break;
            case 1:
                [self.navigationController pushViewController:[DZCurrentDataVC new] animated:YES];
                break;
            case 2:{
                DZMoneyManagementVC *vc = [DZMoneyManagementVC new];
                if ([[NSString stringWithFormat:@"%@", self.shopInfoDict[@"data"][@"audlt_status"]] integerValue] == 0) {
                    vc.isPayBond = YES;//审核期间不展示缴纳保证金入口
                }else{
                    vc.isPayBond = [self.shopInfoDict[@"data"][@"is_pay_bond"] boolValue];
                }
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 3:
                [self.navigationController pushViewController:[DZCommentManagementVC new] animated:YES];
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                if (!self.shopInfoDict) {
                    break;
                }
                NSDictionary *dataDict = self.shopInfoDict[@"data"];
                if ([[NSString stringWithFormat:@"%@", dataDict[@"url_type"]] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@", dataDict[@"url_type"]] isEqualToString:@"3"]) {//跳转到缴纳保证金
                    DZBailIntroVC *vc = [DZBailIntroVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([[NSString stringWithFormat:@"%@", dataDict[@"url_type"]] isEqualToString:@"1"]){
                    
                }else{
//                    NSString *shopType = [NSString stringWithFormat:@"%@", dataDict[@"shop_type"]];
//                    if ([shopType isEqualToString:@"1"]) {//实体
//                        DZSTInfoVC *vc = [DZSTInfoVC new];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }else if ([shopType isEqualToString:@"2"]){//工厂
//                        DZGCInfoVC *vc = [DZGCInfoVC new];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }else if ([shopType isEqualToString:@"3"]){//网批
//                    DZWPInfoVC *vc = [DZWPInfoVC new];
//                    [self.navigationController pushViewController:vc animated:YES];
////                    }
                    DZOpenGCShopVC *vc = [DZOpenGCShopVC new];
                    vc.guanlidianpu = @"yes";
                    [self.navigationController pushViewController:vc animated:YES];
                }
                break;
            }
            case 1:{
                DZShopDetailVC *vc = [DZShopDetailVC new];
                vc.hideContact = YES;
                vc.isziji = @"YES";
                vc.shopId = [DPMobileApplication sharedInstance].loginUser.shop_id;
//                vc.shopId = [DPMobileApplication sharedInstance].loginUser.shop_id;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
//            case 0:
//                [self.navigationController pushViewController:[DZHelpCenterVC new] animated:YES];
//                break;
            case 0:
                //[self.navigationController pushViewController:[DZCustomerServiceVC new] animated:YES];
                //直接与客服聊天
                [self contactCustomerService];
                break;
            default:
                break;
        }
    }
}
#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        if (section == 1) {
            return 2;
        }
        return 1;
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
                [cell fillIcon:@"my_icon_good" title:@"商品管理" hasNew:NO subTitle:nil];
                break;
            case 1:
                [cell fillIcon:@"my_icon_data" title:@"本月实况" hasNew:NO subTitle:nil];
                break;
            case 2:
                [cell fillIcon:@"my_icon_balance" title:@"资金管理" hasNew:NO subTitle:nil];
                break;
            case 3:
                [cell fillIcon:@"my_icon_evaluation" title:@"评价管理" hasNew:NO subTitle:nil];
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                    if (self.shopInfoDict && [self.shopInfoDict.allKeys containsObject:@"data"]) {
                        NSDictionary *dataDict = self.shopInfoDict[@"data"];
                        if ([[NSString stringWithFormat:@"%@", dataDict[@"url_type"]] isEqualToString:@"0"]) {
                            [cell fillIcon:@"my_icon_manage" title:@"管理店铺" hasNew:NO subTitle:@"缴纳保证金"];
                        }else if ([[NSString stringWithFormat:@"%@", dataDict[@"url_type"]] isEqualToString:@"1"]){
                            [cell fillIcon:@"my_icon_manage" title:@"管理店铺" hasNew:NO subTitle:@"审核中"];
                        }else if([[NSString stringWithFormat:@"%@", dataDict[@"url_type"]] isEqualToString:@"2"]) {
                                [cell fillIcon:@"my_icon_manage" title:@"管理店铺" hasNew:NO subTitle:@""];
                        }else if ([[NSString stringWithFormat:@"%@", dataDict[@"url_type"]] isEqualToString:@"3"]){
                            [cell fillIcon:@"my_icon_manage" title:@"管理店铺" hasNew:NO subTitle:@"审核失败"];
                        }else{
                            [cell fillIcon:@"my_icon_manage" title:@"管理店铺" hasNew:NO subTitle:@""];
                        }
                    }else{
                        [cell fillIcon:@"my_icon_manage" title:@"管理店铺" hasNew:NO subTitle:@""];
                    }
                break;
            }
            case 1:
                [cell fillIcon:@"my_icon_follow" title:@"进入店铺" hasNew:NO subTitle:nil];
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
//            case 0:
//                [cell fillIcon:@"my_icon_help" title:@"帮助中心" hasNew:NO subTitle:nil];
//                break;
            case 0:
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
    MainTabBarController *vc = [MainTabBarController new];
    vc.selectedIndex = 4;
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
}

- (void)settingButtonAction{
    DZSettingVC *vc = [DZSettingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageButtonAction{
    JSMessageListViewController *vc = [JSMessageListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tipViewAction{
    DZFreightTemplateVC *vc = [DZFreightTemplateVC new];
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
    __block NSInteger flag = 0;
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/getOrderStatusCount" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        if (flag) {
            [weakSelf.tableView.mj_header endRefreshing];
        }else{
            flag = 1;
        }
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"status"] integerValue] == 1) {
            weakSelf.headerView.unPaidCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"data"][@"status_1"]];
            weakSelf.headerView.unSendCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"data"][@"status_2"]];
            weakSelf.headerView.unRecCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"data"][@"status_3"]];
            weakSelf.headerView.unSuccessCountLabel.text = [NSString stringWithFormat:@"%@", dict[@"data"][@"status_5"]];
        }else{
            [SVProgressHUD showErrorWithStatus:dict[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        if (flag) {
            [weakSelf.tableView.mj_header endRefreshing];
        }else{
            flag = 1;
        }
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
    
    NSDictionary *infoParams = nil;
    LNetWorkAPI *infoApi = [[LNetWorkAPI alloc] initWithUrl:@"/Api/shopCenterApi/getShopInfo" parameters:infoParams];
    [infoApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        if (flag) {
            [weakSelf.tableView.mj_header endRefreshing];
        }else{
            flag = 1;
        }
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            
            weakSelf.shopInfoDict = request.responseJSONObject;
            NSString *shop_name = request.responseJSONObject[@"data"][@"shop_name"];
            if (shop_name.length == 0) {
                weakSelf.headerView.nickNameLabel.text = @"暂未设置店铺名称";
            }else {
                weakSelf.headerView.nickNameLabel.text = request.responseJSONObject[@"data"][@"shop_name"];
            }
            NSString *shopLogo = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"data"][@"shop_logo"]];
            if (shopLogo.length) {
                [weakSelf.headerView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, shopLogo]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
            }else {
                weakSelf.headerView.avatarImageView.image = [UIImage imageNamed:@"avatar_grey"];
            }
            if ([request.responseJSONObject[@"data"][@"is_set_template"] integerValue] == 1) {
                weakSelf.tipView.hidden = YES;
            }else{
                weakSelf.tipView.hidden = NO;
            }
            
            [weakSelf.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        if (flag) {
            [weakSelf.tableView.mj_header endRefreshing];
        }else{
            flag = 1;
        }
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)loadCustomerServiceInfo {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexApi/getServiceInfo"];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZCustomerServiceNetModel *model = [DZCustomerServiceNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.customerService = model.data;
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
        make.top.mas_equalTo(KStatusBarH + 5);
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
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(28);
        make.right.bottom.left.mas_equalTo(0);
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

- (DZSellerMeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"DZSellerMeHeaderView" owner:self options:nil] lastObject];
        _headerView.delegate = self;
        if ([DPMobileApplication sharedInstance].loginUser.head_pic.length) {        
            [_headerView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, [DPMobileApplication sharedInstance].loginUser.head_pic]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
        }
        _headerView.nickNameLabel.text = [DPMobileApplication sharedInstance].loginUser.nickname;
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
        _switchLabel.text = @"切换为买家";
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

- (UIView *)tipView{
    if (!_tipView) {
        _tipView = [[[NSBundle mainBundle] loadNibNamed:@"DZSellerMeTip" owner:self options:nil] firstObject];
        [_tipView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipViewAction)]];
        _tipView.hidden = YES;
    }
    return _tipView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
