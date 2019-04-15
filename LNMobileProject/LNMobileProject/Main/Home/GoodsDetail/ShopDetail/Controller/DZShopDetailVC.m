//
//  DZShopDetailVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopDetailVC.h"
#import "DZGoodsDetailNavView.h"
#import "DZShopDetailHeadView.h"
#import "HMSegmentedControl.h"
#import "DZHomeGoodsListVC.h"
#import "DZGoodsDetailVC.h"
#import "DZShopDetailBottomView.h"
#import "DZShopFileVC.h"
#import "DZShopCateVC.h"
#import "DZShopDetailModel.h"
#import "DZShopCollectModel.h"
#import "DZGoodsModel.h"
#import "DZShopGoodsModel.h"
#import "DZShopCommentVC.h"
#import "FTPopOverMenu.h"
#import "DZMessageVC.h"
#import "DZEMChatUserModel.h"
#import "ChatViewController.h"
#import "DZGoodCatagoryModel.h"
#import "JSMessageListViewController.h"
#import "DZCartVC.h"

@interface DZShopDetailVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (strong, nonatomic) DZGoodsDetailNavView *navView;
@property (strong, nonatomic) DZShopDetailHeadView *headView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *cartButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *numLabel2;
@property (nonatomic, strong) FTPopOverMenuView *popMenuView;

@property (nonatomic, strong) UIView *segmentControlContainer;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) DZHomeGoodsListVC *goodsVC;
@property (strong, nonatomic) DZShopDetailBottomView *bottomView;

@property (nonatomic, strong) DZShopDetailModel *model;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) CGFloat headHeight;
@property (nonatomic, assign) CGFloat minHeight;

/*
 * goodsIndex
 */
@property (nonatomic,assign)NSInteger goodsIndex;
@end

@implementation DZShopDetailVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodsIndex = 0;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.navView.titleLabel.text = @"店铺详情";
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.navView];
//    [self.view addSubview:self.bottomView];
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.cartButton];
    [self.view addSubview:self.moreButton];
    [self.view addSubview:self.numLabel];
    
    self.popMenuView = [FTPopOverMenu getPopMenuView];
    if (![self.popMenuView viewWithTag:1234]) {
        [self.popMenuView addSubview:self.numLabel2];
    } else {
        _numLabel2 = [self.popMenuView viewWithTag:1234];
    }
    
    [self updateMessageCount];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReceiveMessage" object:nil] subscribeNext:^(id x) {
        [self updateMessageCount];
    }];
    
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.segmentControlContainer];
    [self.segmentControlContainer addSubview:self.segmentedControl];
    [self addChildViewController:self.goodsVC];
    [self.scrollView addSubview:self.goodsVC.view];
    
    self.sort = nil;
    self.page = 1;
    [self loadData];
    self.minHeight = SCREEN_HEIGHT - (64 + 37 + 50);
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY>0) {
        CGFloat alpha = offsetY/(SCREEN_WIDTH * 500 / 750);
        self.navView.alpha = alpha;
        [self.backButton setImage:[UIImage imageNamed:@"gooddetail_icon_back_b"] forState:UIControlStateNormal];
        [self.moreButton setImage:[UIImage imageNamed:@"gooddetail_icon_other_b"] forState:UIControlStateNormal];
        [self.cartButton setImage:[UIImage imageNamed:@"gooddetail_icon_cart_b"] forState:UIControlStateNormal];
    } else {
        self.navView.alpha = 0;
        [self.backButton setImage:[UIImage imageNamed:@"gooddetail_icon_back"] forState:UIControlStateNormal];
        [self.moreButton setImage:[UIImage imageNamed:@"gooddetail_icon_other"] forState:UIControlStateNormal];
        [self.cartButton setImage:[UIImage imageNamed:@"gooddetail_icon_cart"] forState:UIControlStateNormal];
    }
    NSLog(@"offsetY: %f",offsetY);
    static BOOL isOver = NO;
    
    CGFloat topHeight = self.headHeight - 84;
    
    if (offsetY > topHeight) {
        if(!isOver) {
            NSLog(@"over");
            isOver = YES;
            [self.segmentedControl removeFromSuperview];
            [self.view addSubview:self.segmentedControl];
            
            [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.navView.mas_bottom);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(37);
            }];
        }
        
    } else {
        if(isOver) {
            NSLog(@"below");
            isOver = NO;
            [self.segmentedControl removeFromSuperview];
            [self.segmentControlContainer addSubview:self.segmentedControl];
            [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.mas_offset(0);
            }];
        }
    }
}
#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----
- (void)loadData {
    NSDictionary *dicparameters = @{@"shop_id":self.shopId};
    if (self.isziji.length != 0) {
        dicparameters = @{@"shop_id":self.shopId};
    }
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopEditApi/goToShop" parameters:dicparameters];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZShopDetailNetModel *model = [DZShopDetailNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.model = model.data;
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < self.model.cat_info.count; i++) {
                DZCatInfoModel *catagory = self.model.cat_info[i];
                [items addObject:catagory.cat_name];
            }
            self.segmentedControl.sectionTitles = items;
            [self setupViews];
            [self loadGoods];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
    
   
    

}

- (void)loadGoods {
    //@"cat_id":catagory.cat_id
    //还需要加载店铺商品
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    if (self.self.model.cat_info.count != 0) {
        DZCatInfoModel *catagory = self.self.model.cat_info[self.goodsIndex];
        [dict setObject:catagory.cat_id forKey:@"cat_id"];
    }

    if (self.sort) {
        [dict setObject:self.sort forKey:@"sort"];
    }
    [dict setObject:self.shopId forKey:@"shop_id"];
    [dict setObject:@(self.page) forKey:@"p"];
    [dict setObject:[DPMobileApplication sharedInstance].loginUser.token forKey:@"token"];
//    [dict addEntriesFromDictionary:@{@"shop_id":self.shopId,@"p":@(self.page),@"token":[DPMobileApplication sharedInstance].loginUser.token}];
    
//    dict = [@{@"code":dict} mutableCopy];
    
    LNetWorkAPI *api2;
    if (self.sort && [self.sort isEqualToString:@"vip"]) {
        api2 = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/userVipPrice" parameters:dict method:LCRequestMethodPost];
        [api2 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            DZGoodsNetModel *model = [DZGoodsNetModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                if(self.page == 1) {
                    [self.dataArray removeAllObjects];
                } else {
                    [self.scrollView.mj_footer endRefreshing];
                }
                [self.dataArray addObjectsFromArray:model.data];
//                self.goodsVC.source = 2;
                self.goodsVC.dataArray = self.dataArray;
            } else {
                [SVProgressHUD showInfoWithStatus:model.info];
                
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    } else {
        api2 = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopEditApi/getGoodsListByCategoryId" parameters:dict method:LCRequestMethodPost];
        [api2 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            DZGoodsNetModel *model = [DZGoodsNetModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                if(self.page == 1) {
                    [self.dataArray removeAllObjects];
                    [self.scrollView.mj_header endRefreshing];
                } else {
                    [self.scrollView.mj_footer endRefreshing];
                }
                [self.dataArray addObjectsFromArray:model.data];
                self.goodsVC.source = 2;
                self.goodsVC.dataArray = self.dataArray;
            }else{
                [self.scrollView.mj_header endRefreshing];
                [self.scrollView.mj_footer endRefreshing];
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [self.scrollView.mj_header endRefreshing];
            [self.scrollView.mj_footer endRefreshing];
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
    //[SVProgressHUD show];
}

- (void)setupViews {
//    [self setupInfo];
    
    [self.headView.bgImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(self.model.shop_real_pic)]];
    
    [self.headView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(self.model.shop_logo)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    NSLog(@">>>>>>>>>=====%@",self.model.is_favorite);
    self.headView.isFavoriteStr = self.model.has_focus;
    
    self.headView.nameLabel.text = self.model.shop_name;
    
    //效果图格式化应该为 省·市·区
    NSArray *addrs = @[self.model.province,self.model.city,self.model.address];
    self.headView.addressLabel.text = [addrs componentsJoinedByString:@"·"];
    
//    self.headView.followNumLabel.text = [NSString stringWithFormat:@"关注 %@",self.model.collect_num];
//    NSString *buy_again = nil;
//    if (self.model.buy_again_rate.length == 0) {
//        buy_again = @"0";
//    }else{
//        buy_again = self.model.buy_again_rate;
//    }
//    self.headView.rebuyRateLabel.text = [NSString stringWithFormat:@"补货率 %@%%",buy_again];
//    self.headView.saleNumLabel.text = [NSString stringWithFormat:@"销量 %@",self.model.goods_sale_num];
//
    if (self.model.shop_like_rate == 0.0) {
        self.headView.goodRateLabel.text = @"0.0%";
    }else {
        self.headView.goodRateLabel.text = [NSString stringWithFormat:@"%.0lf%%",self.model.shop_like_rate];
    }
//
    if (self.model.comment_count.length == 0) {
        self.headView.commentNumLabel.text = @"0条评论";
    }else {
        self.headView.commentNumLabel.text = [NSString stringWithFormat:@"%@条评论",self.model.comment_count];
    }
    self.headView.baobeimiaoshuLabel.text = self.model.goods_rank;
    self.headView.maijiaFuwuLabel.text = self.model.service_rank;
    self.headView.wuliufuwuLabel.text = self.model.express_rank;
    //self.model.desc = @"一段文字，试试看看，店铺简介。一段文字，试试看看，店铺简介。";
    
    self.headView.descTextView.text = self.model.desc.length?self.model.desc:@"暂无公告";

    //需要根据文字内容高度 进行适配
    if (self.model.desc) {
        CGSize size = [self.model.desc sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 16, MAXFLOAT)];
        CGFloat height = size.height;
        if (height > 14.5) {
            self.headHeight = 295 + 32 + (height - 14.5);

            [self.headView.descView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
    
            [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.headHeight);
            }];
        }
    }
}

- (void)setupInfo {
    //缴纳保证金图标，如果两千以下则不显示。
    NSInteger bond = self.model.frozen_bond.integerValue;
    if(self.model.frozen_bond && bond >= 2000) {
        self.headView.bondLabel.hidden = NO;
        self.headView.bondImageView.hidden = NO;
        self.headView.shopTypeLabelLeading.constant = 59;
        
        if (bond < 3000) {
            self.headView.bondLabel.text = @"两千";
        } else if (bond < 5000) {
            self.headView.bondLabel.text = @"三千";
        } else if (bond < 10000) {
            self.headView.bondLabel.text = @"五千";
        } else if (bond < 20000) {
            self.headView.bondLabel.text = @"一万";
        } else if (bond < 50000) {
            self.headView.bondLabel.text = @"两万";
        } else {
            self.headView.bondLabel.text = @"五万";
        }
        
    } else {
        self.headView.bondLabel.hidden = YES;
        self.headView.bondImageView.hidden = YES;
        self.headView.shopTypeLabelLeading.constant = 8;
    }
    
    //商城类型 1实体店 2工厂店 3网批店
    if ([self.model.shop_type isEqualToString:@"1"]) {
        self.headView.shopTypeLabel.text = @"实";
    } else if ([self.model.shop_type isEqualToString:@"2"]) {
        self.headView.shopTypeLabel.text = @"工";
    } else if([self.model.shop_type isEqualToString:@"3"]) {
        self.headView.shopTypeLabel.text = @"网";
    }
    
    //设置星级图标
//    [self setupIcons];
    
    NSLog(@"allow_return: %@",self.model.allow_return);
    
    if ([self.model.allow_return isEqualToString:@"1"]) {
        self.headView.returnImageView.hidden = NO;
    } else {
        self.headView.returnImageView.hidden = YES;
    }
    
}

- (void)setupIcons {
    NSInteger num = self.model.shop_grade.num;
    NSString *type = self.model.shop_grade.type;
    NSString *imageName = @"";
    NSArray *images = @[self.headView.image1,self.headView.image2,self.headView.image3,self.headView.image4,self.headView.image5];
    for (UIImageView *iv in images) {
        iv.hidden = YES;
    }
    
    if(num > 5) {
        num = 5;
    }
    if ([type isEqualToString:@"G1"]) {
        imageName = @"icon_heart";
    } else if ([type isEqualToString:@"G2"]) {
        imageName = @"icon_dimon";
    } if ([type isEqualToString:@"G3"]) {
        imageName = @"icon_silvercrown";
    } if ([type isEqualToString:@"G4"]) {
        imageName = @"icon_goldcrown";
    }
    
    for (int i = 0; i < num; i++) {
        UIImageView *iv = images[i];
        iv.image = [UIImage imageNamed:imageName];
        iv.hidden = NO;
    }
    NSInteger leading = 8;
    if (num > 0) {
        leading += 8;
    }
    leading += 15 *num;
    self.headView.returnImageViewLeading.constant = leading;
}

- (void)popMenu:(UIButton *)button {
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    //configuration.textColor = HEXCOLOR(0xfffff);
    //configuration.menuIconMargin = 12;
    // configuration.borderColor = HEXCOLOR(0x333333);
    // configuration.menuRowHeight = 35;
    configuration.tintColor = [UIColor colorWithWhite:0 alpha:0.8];
    configuration.textAlignment = NSTextAlignmentCenter;
    
    
    [FTPopOverMenu showForSender:button withMenuArray:@[@"消息",@"首页",@"分享商品"] doneBlock:^(NSInteger selectedIndex) {
        switch (selectedIndex) {
            case 0:
            {
                if (![self checkLogin]) {
                    return;
                }
                JSMessageListViewController *vc = [JSMessageListViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 1:
                [self showTabWithIndex:0 needSwitch:NO showLogin:NO];
                break;
            case 2:
                break;
                
            default:
                break;
        }
    } dismissBlock:^{
        
    }];
    
}

- (void)chat{
    if(![self checkLogin]) {
        return;
    }
    
    if ([DPMobileApplication sharedInstance].isShowing) {
        return;
    }
    
    [DPMobileApplication sharedInstance].isShowing = YES;
    
    if ([DPMobileApplication sharedInstance].isLogined) {
        
        if ([EMClient sharedClient].currentUsername) {
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/getShopEmchat" parameters:@{@"shop_id":self.shopId}];
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
            
            //            SupportEmchatAPI *api = [[SupportEmchatAPI alloc] init];
            //            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            //                SupportEmchatModel *model = [SupportEmchatModel objectWithKeyValues:request.responseJSONObject];
            //                if (model.status == 1) {
            //
            //                    Result *result = [Result objectWithKeyValues:model.result];
            //                    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:result.emchat_username conversationType:0];
            //                    chatController.real_name = result.nickname;
            //                    chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_HOST,result.head_pic];
            //                    chatController.hidesBottomBarWhenPushed = YES;
            //                    // 传递产品信息
            //                    chatController.isFromProductDetail = YES;
            //                    chatController.commodityID = self.model.goods.goods_id;
            //                    chatController.commodityName = self.model.goods.goods_name;
            //                    chatController.commodityPrice = self.model.goods.shop_price;
            //                    //NSString *urlString = [SPCommonUtils getThumbnailWithHost:FLEXIBLE_THUMBNAIL goodsID:Str(self.model.goods.goods_id)];
            //                    NSString *urlString = self.model.goods.original_img;
            //                    chatController.commodityImage = urlString;
            //                    [self.navigationController pushViewController:chatController animated:YES];
            //
            //                }
            //            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            //            }];
        }else {
            //            GGUserModel *user = [SPMobileApplication sharedInstance].loginUser;
            //            // 登录环信
            //            [[EMClient sharedClient] loginWithUsername:user.emchat_username
            //                                              password:user.emchat_password
            //                                            completion:^(NSString *aUsername, EMError *aError) {
            //                                                if (!aError) {
            //                                                    SupportEmchatAPI *api = [[SupportEmchatAPI alloc] init];
            //                                                    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            //                                                        SupportEmchatModel *model = [SupportEmchatModel objectWithKeyValues:request.responseJSONObject];
            //                                                        if (model.status == 1) {
            //                                                            Result *result = [Result objectWithKeyValues: model.result];
            //                                                            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:result.emchat_username conversationType:0];
            //                                                            chatController.real_name = result.nickname;
            //                                                            chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_HOST,result.head_pic];
            //                                                            [self.navigationController pushViewController:chatController animated:YES];
            //
            //                                                        }
            //                                                    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            //                                                    }];
            //                                                }else {
            //                                                    [self showTextOnly:@"客服正忙，请稍后尝试"];
            //                                                }
            //                                            }];
        }
    }else {
        //[[NSNotificationCenter defaultCenter] postNotificationName:NotificationTokenExpire object:nil];
    }
    
}

- (void)call {
    if(!self.model) {
        return;
    }
    
    if (self.model.user_mobile) {
            //拨打电话
        NSString* str=[[NSString alloc] initWithFormat:@"telprompt://%@",self.model.user_mobile];
        // NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }
}
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
        self.numLabel2.hidden = NO;
        self.numLabel2.text = [NSString stringWithFormat:@"%d",count];
        if (count>99) {
            self.numLabel2.text = @"99+";
        }
    } else {
        self.numLabel.hidden = YES;
        self.numLabel2.hidden = YES;
    }
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{
    
}

- (void) setSubViewsLayout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.scrollView.mas_bottom);
//        make.left.right.bottom.mas_offset(0);
//    }];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(KNavigationBarH);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(26);
        make.left.mas_offset(12);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(26);
        make.right.mas_offset(-12);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moreButton.mas_right).mas_offset(-10);
        make.bottom.equalTo(self.moreButton.mas_top).mas_offset(10);
        make.height.mas_equalTo(13);
        make.width.mas_greaterThanOrEqualTo(13);
    }];
    if (self.numLabel2 && self.numLabel2.superview) {
        [self.numLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-20);
            make.top.mas_offset(23);
            make.height.mas_equalTo(13);
            make.width.mas_greaterThanOrEqualTo(13);
        }];
    }
    
    [self.cartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(26);
        make.right.equalTo(self.moreButton.mas_left).mas_offset(-23);
    }];
    
    self.headHeight = 295 + 32;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(self.headHeight);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    [self.segmentControlContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(37);
    }];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    
    [self.goodsVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControlContainer.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(self.minHeight);
        make.bottom.equalTo(self.scrollView.mas_bottom).mas_offset(0);
    }];
}

- (void)setCollectionViewHeight:(NSNumber *)num {
    CGFloat height = num.floatValue;
    if (height < self.minHeight) {
        height = self.minHeight;
    }
    [self.goodsVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    [self.scrollView.mj_footer endRefreshing];
}

#pragma mark - --- getters 和 setters ----
- (UIScrollView *)scrollView  {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        @weakify(self);
        _scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page ++;
            [self loadGoods];
        }];
    }
    return _scrollView;
}

- (UIButton *)backButton {
    if(!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"gooddetail_icon_back"] forState:UIControlStateNormal];
        @weakify(self);
        [[_backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _backButton;
}

- (UIButton *)cartButton {
    if(!_cartButton) {
        _cartButton = [[UIButton alloc] init];
        [_cartButton setImage:[UIImage imageNamed:@"gooddetail_icon_cart"] forState:UIControlStateNormal];
        //点击后跳转进货车
        @weakify(self);
        [[_cartButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (![self checkLogin]) {
                return;
            }
            DZCartVC *cartVc = [[DZCartVC alloc] init];
            [self.navigationController pushViewController:cartVc animated:YES];
//            if ([DPMobileApplication sharedInstance].isSellerMode) {
//                [self showTabWithIndex:3 needSwitch:YES showLogin:NO];
//            }else{
//                [self showTabWithIndex:3 needSwitch:NO showLogin:NO];
//            }
        }];
    }
    return _cartButton;
}

- (UIButton *)moreButton {
    if(!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:[UIImage imageNamed:@"gooddetail_icon_other"] forState:UIControlStateNormal];
        @weakify(self);
        //点击弹出菜单
        [[_moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self popMenu:_moreButton];
        }];
    }
    return _moreButton;
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

- (UILabel *)numLabel2 {
    if(!_numLabel2) {
        _numLabel2 = [[UILabel alloc] init];
        _numLabel2.backgroundColor = HEXCOLOR(0xFF7722);
        _numLabel2.textColor = [UIColor whiteColor];
        _numLabel2.font = [UIFont systemFontOfSize:10];
        _numLabel2.layer.masksToBounds = YES;
        _numLabel2.layer.cornerRadius = 6;
        _numLabel2.textAlignment = NSTextAlignmentCenter;
        _numLabel2.tag = 1234;
    }
    return _numLabel2;
}

- (DZGoodsDetailNavView *)navView {
    if (!_navView) {
        _navView = [DZGoodsDetailNavView viewFormNib];
        _navView.alpha = 0;
    }
    return _navView;
}

- (DZShopDetailHeadView *)headView  {
    if(!_headView) {
        _headView = [DZShopDetailHeadView viewFormNib];
        [[_headView.followButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if(![self checkLogin]) {
                return;
            }
            //关注店铺
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/collectShop" parameters:@{@"shop_id":self.shopId}];
            
            [SVProgressHUD show];
            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                [SVProgressHUD dismiss];
                DZShopCollectNetModel *model = [DZShopCollectNetModel objectWithKeyValues:request.responseJSONObject];
                [SVProgressHUD showInfoWithStatus:model.info];
                if (model.isSuccess) {
                    if ([model.data isEqualToString:@"1"]) {
                        self.headView.isFavoriteStr = @"1";
                    } else if ([model.data isEqualToString:@"2"]) {
                        self.headView.isFavoriteStr = @"0";
                    }
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:error.domain];
            }];
        }];
        
        [[_headView.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            DZShopCommentVC *vc = [[DZShopCommentVC alloc] init];
            vc.shopId = self.shopId;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _headView;
}

- (UIView *)segmentControlContainer {
    if(!_segmentControlContainer) {
        _segmentControlContainer = [[UIView alloc] init];
    }
    return _segmentControlContainer;
}

- (HMSegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl=[[HMSegmentedControl alloc] initWithSectionTitles:@[@"",@"",@"",@""]];
        
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectionIndicatorColor=OrangeColor;
        _segmentedControl.selectionIndicatorHeight=1;
        _segmentedControl.borderWidth=1;
        _segmentedControl.borderColor=[UIColor colorWithRed:0.965f green:0.965f blue:0.965f alpha:1.00f];
        
        NSDictionary *selectdefaults = @{
                                         NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
                                         NSForegroundColorAttributeName : OrangeColor,
                                         };
        NSMutableDictionary *selectresultingAttrs = [NSMutableDictionary dictionaryWithDictionary:selectdefaults];
        
        NSDictionary *defaults = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
                                   NSForegroundColorAttributeName : TextBlackColor,
                                   };
        NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];
        _segmentedControl.selectedTitleTextAttributes=selectresultingAttrs;
        _segmentedControl.titleTextAttributes=resultingAttrs;
        //_segmentedControl.selectedSegmentIndex=0;
        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        @weakify(self);
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            @strongify(self);
            self.page = 1;
            if (index == 0) {
                self.sort = nil;
            } else if (index == 1) {
                self.sort = @"new";
            } else if (index == 2) {
                self.sort = @"sales";
            }else if (index == 3) {
                self.sort = @"vipp";
            }
            self.goodsIndex = index;
            [self loadGoods];
        };
    }
    return _segmentedControl;
}

- (DZHomeGoodsListVC *)goodsVC {
    if(!_goodsVC) {
        _goodsVC = [[DZHomeGoodsListVC alloc] init];
        @weakify(self);
        [_goodsVC.refreshSubject subscribeNext:^(NSNumber *height) {
            @strongify(self);
            [self setCollectionViewHeight:height];
        }];
        
        [_goodsVC.clickSubject subscribeNext:^(DZGoodsModel *goods) {
            @strongify(self);
            DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
            vc.goodsId = goods.goods_id;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _goodsVC;
}


- (DZShopDetailBottomView *)bottomView {
    if(!_bottomView) {
        _bottomView = [DZShopDetailBottomView viewFormNib];
        @weakify(self);
        [[_bottomView.fileButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            DZShopFileVC *vc = [[DZShopFileVC alloc] init];
            vc.shopId = self.shopId;
            [vc.refreshSubject subscribeNext:^(id x) {
                [self loadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [[_bottomView.catButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            DZShopCateVC *vc = [[DZShopCateVC alloc] init];
            vc.shopId = self.shopId;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [[_bottomView.chatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self chat:self.shopId];
        }];
        
        [[_bottomView.phoneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self call];
        }];
        
        if (self.hideContact) {
            [_bottomView.chatButton removeFromSuperview];
            [_bottomView.phoneButton removeFromSuperview];
            [_bottomView.fileButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_offset(0);
            }];
        }
    
    }
    return _bottomView;
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
