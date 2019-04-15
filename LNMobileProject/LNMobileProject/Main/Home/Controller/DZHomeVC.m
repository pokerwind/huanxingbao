//
//  DZHomeVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZHomeVC.h"
#import "DZHomeNavTitleView.h"
#import "SDCycleScrollView.h"
#import "DZHomeMiddleView.h"
#import "HMSegmentedControl.h"
#import "DZHomeGoodsListVC.h"
#import "DZHomeBottomView.h"
#import "DZTimeLimitVC.h"
#import "DZGoodsDetailVC.h"
#import "DZCustomBatchVC.h"
#import "DZSearchVC.h"
#import "DZBannerModel.h"
#import "DZDingZhiModel.h"
#import "DZTimeLimitModel.h"
#import "DZHomeAdCell.h"
#import "DZGoodsModel.h"
#import "DZHomeStartupView.h"
#import "DZStartAdModel.h"
#import "YCWebViewController.h"
#import "DZMessageVC.h"
#import "DZShopDetailVC.h"
#import "DZCustomerServiceModel.h"
#import "DZHomeMidMView.h"
#import "DZHomeMidBottomView.h"
#define kHomeAdCell @"DZHomeAdCell"
#import "DZHomeMidTopView.h"
#import "DZGoodCatagoryModel.h"
#import "DZCartVC.h"
#import "WMDragView.h"
#import "DZLexzViewController.h"
#import "DZJfdhViewController.h"
#import "JSMessageListViewController.h"
#import "SingleLocationViewController.h"
@interface DZHomeVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DZHomeNavTitleView *navView;
@property (strong, nonatomic) SDCycleScrollView *bannerView;
@property (strong, nonatomic) DZHomeMiddleView *middleView;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

/*
 * DZHomeMidMView
 */
@property (nonatomic,strong)DZHomeMidMView *midMView;

/*
 * DZHomeMidBottomView
 */
@property (nonatomic,strong)DZHomeMidBottomView *midBottomView;

/*
 * DZHomeMidTopView
 */
@property (nonatomic,strong)DZHomeMidTopView *midTopView;

/*
 *
 */
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (strong, nonatomic) UITableView *adTableView;
@property (strong, nonatomic) UIView *segmentedContainer;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) DZHomeGoodsListVC *goodsVC;
@property (strong, nonatomic) DZHomeBottomView *bottomView;
@property (nonatomic, assign) NSInteger timeLeft;
@property (nonatomic, assign) NSInteger timeRight;
@property (nonatomic, strong) NSMutableArray *adArray;
@property (nonatomic, assign) NSInteger goodsIndex;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) DZHomeStartupView *startupView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray *banners;

@property (nonatomic, assign) BOOL isLeftCounting;

@property (nonatomic, assign) BOOL isRightCounting;


@property (nonatomic, assign) CGFloat headHeight;
@property (nonatomic, assign) CGFloat adHeight;

/*
 * catagorys
 */
@property (nonatomic,strong)NSArray *catagorys;
@end

@implementation DZHomeVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
//    [self loadCustomerServiceInfo];
//    [self showStartupAd];
    
    //[self setupNavigationBar];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.bannerView];
    [self.scrollView addSubview:self.middleView];
    [self.scrollView addSubview:self.midTopView];
    [self.scrollView addSubview:self.midBottomView];
    [self.scrollView addSubview:self.midMView];
    
//    [self.scrollView addSubview:self.adTableView];
    [self.scrollView addSubview:self.segmentedContainer];
    [self.segmentedContainer addSubview:self.segmentedControl];
    [self addChildViewController:self.goodsVC];
    [self.scrollView addSubview:self.goodsVC.view];
    
    [self setupCartBtn];
    //[self.scrollView addSubview:self.bottomView];
    self.headHeight = SCREEN_WIDTH*332/750 + SCREEN_WIDTH *0.442+ 406 ;
    self.adHeight = 0;
    [self loadData];
   
    //进行单次定位请求
    [self initCompleteBlock];
    
     [self configLocationManager];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    
   
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setSubViewsFrame];
    
    [self getUnreadRequest];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark - ---- 代理相关 ----
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    static BOOL isOver = NO;
    
    CGFloat topHeight = self.headHeight + self.adHeight;
    
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
            [self.segmentedContainer addSubview:self.segmentedControl];
            [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.mas_offset(0);
            }];
        }
    }
}


#pragma mark SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    if (self.banners && self.banners.count > 0) {
//        DZBannerModel *banner = self.banners[index];
//
//        //根据类型分别处理
//        if ([banner.type isEqualToString:@"0"]) { //跳转网页
//            YCWebViewController *vc = [[YCWebViewController alloc] init];
//            vc.web_url = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,banner.link_url];;
//            [self.navigationController pushViewController:vc animated:YES];
//        } else if ([banner.type isEqualToString:@"5"]) { //店铺
//            DZShopDetailVC *vc = [[DZShopDetailVC alloc] init];
//            vc.shopId = banner.item_id;
//            [self.navigationController pushViewController:vc animated:YES];
//        } else if ([banner.type isEqualToString:@"6"]) { //商品
//            DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
//            vc.goodsId = banner.item_id;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    

//    }
}

#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZHomeAdCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeAdCell];
    DZBannerModel *model = self.adArray[indexPath.row];
    [cell.adImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.content)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH*148/375;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //广告点击事件    
    DZBannerModel *banner = self.adArray[indexPath.row];
    
    //根据类型分别处理
    if ([banner.type isEqualToString:@"0"]) { //跳转网页
        YCWebViewController *vc = [[YCWebViewController alloc] init];
        vc.web_url = banner.link_url;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([banner.type isEqualToString:@"5"]) { //店铺
        DZShopDetailVC *vc = [[DZShopDetailVC alloc] init];
        vc.shopId = banner.item_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([banner.type isEqualToString:@"6"]) { //商品
        DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
        vc.goodsId = banner.item_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - ---- Action Events 和 response手势 ----

- (void)messageAction:(id)sender {
    JSMessageListViewController *vc = [JSMessageListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)getUnreadRequest
{
    //获取消息未读个数
    LNetWorkAPI *api6 = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexUserApi/getNoReadCount" parameters:nil];
    [api6 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        if ([[request.responseJSONObject objectForKey:@"status"] integerValue] == 1) {
            self.navView.unReadNum = [[request.responseJSONObject objectForKey:@"data"] integerValue];
        }else{
            
        }
        //        DZBannerNetModel *model = [DZBannerNetModel objectWithKeyValues:request.responseJSONObject];
        //        if (model.isSuccess) {
        //            //self.reasonArray = request.responseJSONObject[@"data"];
        //            [self setBanner:model];
        //        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        
    }];
}

#pragma mark - ---- 私有方法 ----

- (void)loadCustomerServiceInfo {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexApi/getServiceInfo"];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZCustomerServiceNetModel *model = [DZCustomerServiceNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [DPMobileApplication sharedInstance].customerService = model.data;
            //self.customerService = model.data;
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)showStartupAd {
    
    //启动页广告只显示一次
    if([DPMobileApplication sharedInstance].isStartAdShown) {
        return;
    }
    [DPMobileApplication sharedInstance].isStartAdShown = YES;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self.startupView];

    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/PublicApi/startAppAd"];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZStartAdNetModel *model = [DZStartAdNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            //self.reasonArray = request.responseJSONObject[@"data"];
            if (model.data.count >0) {
                NSString *url = model.data.firstObject;
                [self.startupView.adImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(url)] placeholderImage:[UIImage imageNamed:@""]];
            }
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        
    }];
    
    __block NSInteger second = 3;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                [self.startupView.jumpButton setTitle:[NSString stringWithFormat:@"跳过 %ld",second] forState:UIControlStateNormal];
                second--;
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                //[_getNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];

                [self.startupView removeFromSuperview];
            }
        });
    });
    //启动源
    dispatch_resume(timer);
    
}



- (void)loadData {
    //获取轮播图
    NSDictionary *params = @{@"position_id":@"1"};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexApi/adChangeBanner" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZBannerNetModel *model = [DZBannerNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            //self.reasonArray = request.responseJSONObject[@"data"];
            [self setBanner:model];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        
    }];
    
    //获取限时抢购信息
    LNetWorkAPI *api2 = [[LNetWorkAPI alloc] initWithUrl:@"Api/IndexApi/limitedFavourList"];
    [api2 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZTimeLimitNetModel *model = [DZTimeLimitNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            NSArray *items = [DZTimeLimitModel objectArrayWithKeyValuesArray:model.data];
            [self setTimeLimit:items];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        
    }];
    
//    //获取定制批发信息
//    LNetWorkAPI *api3 = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexApi/adOrderWholeSale"];
//    [api3 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//        DZDingZhiNetModel *model = [DZDingZhiNetModel objectWithKeyValues:request.responseJSONObject];
//        if (model.isSuccess) {
//            //self.reasonArray = request.responseJSONObject[@"data"];
//            if (model.data.count > 0) {
//                [self setDingZhi:model.data.firstObject];
//            }
//
//        }
//    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//
//    }];
    
    //获取活动广告
    LNetWorkAPI *api4 = [[LNetWorkAPI alloc] initWithUrl:@"Api/IndexApi/hotActivityBanner"];
    [api4 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZBannerNetModel *model = [DZBannerNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            //self.reasonArray = request.responseJSONObject[@"data"];
            [self setAd:model];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        
    }];
    
    
    //获取商品分类接口
    LNetWorkAPI *api5 = [[LNetWorkAPI alloc] initWithUrl:@"Api/IndexApi/getGoodsCategoryList"];
    [api5 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZGoodCatagoryModel *model = [DZGoodCatagoryModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < model.data.count; i++) {
                DZGoodCatagory *catagory = model.data[i];
                [items addObject:catagory.cat_name];
            }
            self.segmentedControl.sectionTitles = items;
            self.catagorys =model.data;
            
            self.goodsIndex = 0;
            self.page = 1;
            [self loadGoods];
        
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        
    }];
    
}

- (void)loadGoods {
    if (self.goodsIndex < 4) {
        //获取各类别商品列表
        DZGoodCatagory *catagory = self.catagorys[self.goodsIndex];
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/IndexApi/getGoodsByCatId" parameters:@{@"cat_id":catagory.cat_id,@"p":@(self.page)} method:LCRequestMethodPost];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            DZGoodsNetModel *model = [DZGoodsNetModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                if(self.page == 1) {
                    [self.goodsArray removeAllObjects];
                    [self.scrollView.mj_header endRefreshing];
                } else {
                    [self.scrollView.mj_footer endRefreshing];
                }
                [self.goodsArray addObjectsFromArray:model.data];
                self.goodsVC.source = 1;
                self.goodsVC.dataArray = self.goodsArray;
            }else{
                [self.scrollView.mj_header endRefreshing];
                [self.scrollView.mj_footer endRefreshing];
                 [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [self.scrollView.mj_header endRefreshing];
            [self.scrollView.mj_footer endRefreshing];
        }];
    } else {
    
        //检查是否登录
        if (![self checkLogin]) {
            [self.goodsArray removeAllObjects];
            self.goodsVC.source = 1;

            self.goodsVC.dataArray = self.goodsArray;
            return;
        }
        //我关注的商品，另一个接口
        NSString *userId = [DPMobileApplication sharedInstance].loginUser.user_id;
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexApi/shopFocusGoods" parameters:@{@"UID":userId,@"p":@(self.page)}];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            DZGoodsNetModel *model = [DZGoodsNetModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                if(self.page == 1) {
                    [self.goodsArray removeAllObjects];
                } else {
                    [self.scrollView.mj_footer endRefreshing];
                }
                [self.goodsArray addObjectsFromArray:model.data];
                self.goodsVC.source = 1;
                self.goodsVC.dataArray = self.goodsArray;
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            
        }];
    }
}

- (void)setBanner:(DZBannerNetModel *)model {
    NSMutableArray *array = [NSMutableArray array];
    self.banners = model.data;
    for (DZBannerModel *banner in model.data) {
        [array addObject:FULL_URL(banner.content)];//
    }
    __block DZHomeVC *men = self;
    self.bannerView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        DZBannerModel *banner = model.data[currentIndex];
        if (banner.item_id.integerValue == 0) {
            return;
        }
        DZGoodsDetailVC *goodsDetailVC = [[DZGoodsDetailVC alloc] init];//WithGoodsID:[NSString stringWithFormat:@"%@",dic[@"commodityID"]]];
        goodsDetailVC.goodsId = [NSString stringWithFormat:@"%@",banner.item_id];
        [men.navigationController pushViewController:goodsDetailVC animated:YES];
    };
    self.bannerView.imageURLStringsGroup = array;
}
- (void)andTimeAction {
    self.timeRight = ((self.timeRight /1000)-1)*1000;
    if (self.timeRight <=0) {
        self.timeRight = 0;
    }
    [self setupTimeRight:self.timeRight];
}
- (void)setTimeLimit:(NSArray *)model {
    
    if (model.count == 0) {
        [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom);
            make.left.right.mas_offset(0);
            make.height.mas_equalTo(0);
        }];
    }else{
        if (model.count == 1) {
        self.middleView.rightView.hidden = YES;
        }else if(model.count == 2){
           
            DZTimeLimitModel *limitModel = model[1];
            if (limitModel.now_price.length == 0) {
                self.middleView.rightView.hidden = YES;
            }else{
                self.middleView.rightView.hidden = NO;
                self.middleView.rightNameL.text = limitModel.goods_name;
                self.middleView.rightOrginalPriceL.text = [NSString stringWithFormat:@"原价：%@ 元",limitModel.shop_price];
                [self.middleView.rightImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, limitModel.goods_img]] placeholderImage:[UIImage imageNamed:@"avatar_grey"] options:0];
                
                NSString *str = [NSString stringWithFormat:@"限时价：%@ 元",limitModel.now_price];
                
                NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];[attrDescribeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:[str rangeOfString:limitModel.now_price]];
                
                self.middleView.rightNowPriceL.attributedText = attrDescribeStr;
                
                if(limitModel.end_time > limitModel.now_time) {
                    //进行中
                    NSInteger timeRight = (limitModel.end_time - limitModel.now_time) * 1000.0;
                    self.timeRight = timeRight;
                    [self setupTimeRight:timeRight];
                    if (self.isRightCounting) {
                        return;
                    }
                    self.isRightCounting = YES;
                    @weakify(self);
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(andTimeAction) userInfo:nil repeats:YES];
                    
                    //                [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal ] subscribeNext:^(id x) {
                    //                    @strongify(self);
                    //                    self.timeRight--;
                    //                    if (self.timeRight <=0) {
                    //                        self.timeRight = 0;
                    //                    }
                    //                    [self setupTimeRight:self.timeRight];
                    //
                    //                }];
                }
                
            }
            }
            
        DZTimeLimitModel *limitModel = model[0];
        self.middleView.leftName.text = limitModel.goods_name;
        self.middleView.leftOrginalPriceL.text = [NSString stringWithFormat:@"原价：%@ 元",limitModel.shop_price];
        [self.middleView.leftImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, limitModel.goods_img]] placeholderImage:[UIImage imageNamed:@"avatar_grey"] options:0];
        NSString *str = [NSString stringWithFormat:@"限时价：%@ 元",limitModel.now_price];
        
        NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];[attrDescribeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:[str rangeOfString:limitModel.now_price]];
        
        self.middleView.leftNowPriceL.attributedText = attrDescribeStr;
        
        if(limitModel.end_time > limitModel.now_time) {
            //进行中
            NSInteger timeLeft = (limitModel.end_time - limitModel.now_time) * 1000.0;
            self.timeLeft = timeLeft;
            [self setupTimeLeft:timeLeft];
            if (self.isLeftCounting) {
                return;
            }
            self.isLeftCounting = YES;
            @weakify(self);
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(andaddTimeAction) userInfo:nil repeats:YES];

            
//            [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal ] subscribeNext:^(id x) {
//                @strongify(self);
//                self.timeLeft--;
//                if (self.timeLeft <=0) {
//                    self.timeLeft = 0;
//                }
//                [self setupTimeLeft:self.timeLeft];
//
//            }];
        }
    }
}
- (void)andaddTimeAction {
    self.timeLeft = ((self.timeLeft /1000)-1)*1000;
    if (self.timeLeft <=0) {
        self.timeLeft = 0;
    }
    [self setupTimeLeft:self.timeLeft];
}

- (void)setupTimeRight:(NSInteger)timeRight
{
    if(timeRight <0 ){
        return;
    }
    
    NSInteger hour = timeRight/3600/1000;
    NSInteger min = ((timeRight/1000)%3600)/60;
    NSInteger sec = (timeRight /1000)%60;
    
    self.middleView.rightHourL.text = [NSString stringWithFormat:@"%02ld",(long)hour];
    self.middleView.rightMinL.text = [NSString stringWithFormat:@"%02ld",(long)min];
    self.middleView.rightSecondL.text = [NSString stringWithFormat:@"%02ld",(long)sec];
}

- (void)setupTimeLeft:(NSInteger)timeLeft {
    if(timeLeft <0 ){
        return;
    }
    
    NSInteger hour = timeLeft/3600/1000;
    NSInteger min = ((timeLeft/1000)%3600)/60;
    NSInteger sec = (timeLeft /1000)%60;
    
    self.middleView.leftHourL.text = [NSString stringWithFormat:@"%02ld",(long)hour];
    self.middleView.leftMinL.text = [NSString stringWithFormat:@"%02ld",(long)min];
    self.middleView.leftSecondL.text = [NSString stringWithFormat:@"%02ld",(long)sec];
}

- (void)setDingZhi:(DZDingZhiModel *)model {
//    [self.middleView.right2ImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.content)] placeholderImage:[UIImage imageNamed:@"custombatch"]];
}

- (void)setAd:(DZBannerNetModel *)model {
    [self.adArray removeAllObjects];
//    if (model.data.count > 2) {
//        [self.adArray addObjectsFromArray:[model.data subarrayWithRange:NSMakeRange(0, 2)]];
//        //self.goodsVC.adArray = [model.data subarrayWithRange:NSMakeRange(2, model.data.count-2)];
//    } else {
        [self.adArray addObjectsFromArray:model.data];
//    }
    self.goodsVC.adArray = model.data;
    DZBannerModel *bannerModel;
    if (self.goodsVC.adArray.count) {
        bannerModel = self.goodsVC.adArray[0];
    }
    __block DZHomeVC *men = self;
    self.midMView.block = ^(DZBannerModel *JsonModel) {
//        if (JsonModel.type.integerValue == 1) {
//
//        }
//        if (JsonModel.type.integerValue == 2) {
//
//        }
//        if (JsonModel.type.integerValue == 3) {
//
//        }
//        if (JsonModel.type.integerValue == 4) {
//
//        }
//        if (JsonModel.type.integerValue == 5) {
//
//        }
//        if (JsonModel.type.integerValue == 6) {
//
//        }
        // 打开商品详情
        if (JsonModel.item_id.integerValue == 0) {
            return;
        }
        DZGoodsDetailVC *goodsDetailVC = [[DZGoodsDetailVC alloc] init];//WithGoodsID:[NSString stringWithFormat:@"%@",dic[@"commodityID"]]];
        goodsDetailVC.goodsId = [NSString stringWithFormat:@"%@",JsonModel.item_id];
        [men.navigationController pushViewController:goodsDetailVC animated:YES];
    };
    self.midMView.bannerModel = bannerModel;
    
//    [self.midMView.adImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,bannerModel.content]] placeholderImage:[UIImage imageNamed:@"avatar_grey"] options:0];
    
//    CGFloat height = SCREEN_WIDTH*148/375;
////    height *= self.adArray.count;
//    self.adHeight = height;
//    [self.adTableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
//
//    [self.adTableView reloadData];
}



#pragma mark - ---- 布局代码 ----

- (void)setupNavigationBar {
    DZHomeNavTitleView *titleView = [DZHomeNavTitleView viewFormNib];
    self.navigationItem.titleView = titleView;
    
    //self.navigationItem.hidesBackButton = YES;
    
    @weakify(self);
    [[titleView.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"go search");
        DZSearchVC *vc = [[DZSearchVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gooddetail_icon_chat"] style:UIBarButtonItemStylePlain target:self action:@selector(messageAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(KNavigationBarH);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.left.right.bottom.mas_offset(0);
    }];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(SCREEN_WIDTH * 332 / 750);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    [self.midTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.middleView.mas_bottom);
        make.left.right.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(118);
    }];
    
    
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(140);
    }];
    
    [self.midBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.midTopView.mas_bottom);
        make.left.right.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(118);
    }];

    [self.midMView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.midBottomView.mas_bottom);
        make.left.right.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(SCREEN_WIDTH *0.442+ 30);
    }];
    
//    [self.midMView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.midTopView.mas_bottom);
//        make.left.right.mas_equalTo(self.scrollView);
//        make.height.mas_equalTo(SCREEN_WIDTH *0.442+ 30);
//    }];
//
//    [self.midBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.midMView.mas_bottom);
//        make.left.right.mas_equalTo(self.scrollView);
//        make.height.mas_equalTo(118);
//    }];
    
//    [self.adTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.midBottomView.mas_bottom);
//        make.left.right.mas_offset(0);
//        make.height.mas_equalTo(SCREEN_WIDTH*148/375);
//    }];
    
    [self.segmentedContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midMView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(37);
    }];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    
    [self.goodsVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedContainer.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(300);
        make.bottom.mas_offset(0);
    }];
    
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.goodsVC.view.mas_bottom);
//        make.left.right.mas_offset(0);
//        make.height.mas_equalTo(SCREEN_WIDTH*280/750);
//        
//    }];
}

- (void)setCollectionViewHeight:(NSNumber *)heightNumber {
    CGFloat minHeight = SCREEN_HEIGHT - (64 + 50 +35);
    CGFloat height = heightNumber.floatValue;
    if (height < minHeight) {
        height = minHeight;
    }
    [self.goodsVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}


#pragma mark - --- getters 和 setters ----
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        @weakify(self);
        _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData];
            [self loadGoods];
        }];
        
        _scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page ++;
            [self loadGoods];
        }];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (SDCycleScrollView *)bannerView {
    
    if (!_bannerView) {
        // 网络加载 --- 创建带标题的图片轮播器
        _bannerView = [[SDCycleScrollView alloc] init];
        //    cycleScrollView.placeholderImage = placeholderImage;
        _bannerView.delegate = self;
        _bannerView.backgroundColor = [UIColor whiteColor];
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _bannerView.currentPageDotColor = BannerCurrentDotColor; // 自定义分页控件小圆标颜色
        _bannerView.pageDotColor = BannerOtherDotColor;
        _bannerView.placeholderImage = [UIImage imageNamed:@"avatar_grey"];
        _bannerView.autoScrollTimeInterval = 3.0f;
        //NSMutableArray *imageArray =[[NSMutableArray alloc] init];
        //        for (BannerlistModel *bannerModel in [Utils getUserModel].bannerList) {
        //            NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",base_image_url,bannerModel.img];
        //            [imageArray addObject:imageStringUrl];
        //        }
        //[imageArray addObject:@"http://gobuy.host3.liuniukeji.com/Public/upload/goods/2017/07-12/5965cc2844085.jpg"];
        //[imageArray addObject:@"http://gobuy.host3.liuniukeji.com/Public/upload/goods/2017/07-12/5965cc3e57fa2.jpg"];
        ///_bannerView.imageURLStringsGroup = [imageArray copy];
        _bannerView.layer.masksToBounds = YES;
        
    }
    return _bannerView;
}

- (DZHomeMidTopView *)midTopView
{
    if (!_midTopView) {
        _midTopView = [DZHomeMidTopView viewFormNib];
         @weakify(self);
        _midTopView.lBlock = ^{
         @strongify(self);
            DZLexzViewController *lexzVc = [[DZLexzViewController alloc]init];
            lexzVc.source = 1;
            [self.navigationController pushViewController:lexzVc animated:YES];
        };
        
        _midTopView.mBlock = ^{
         @strongify(self);
            //礼包兑换
            DZLexzViewController *lexzVc = [[DZLexzViewController alloc]init];
            lexzVc.source = 4;
            [self.navigationController pushViewController:lexzVc animated:YES];
        };
        
        _midTopView.pBlock = ^{
        @strongify(self);
        //礼包兑换
        DZLexzViewController *lexzVc = [[DZLexzViewController alloc]init];
        lexzVc.source = 2;
        [self.navigationController pushViewController:lexzVc animated:YES];
        };
    }
    return _midTopView;
}

- (DZHomeMidMView *)midMView
{
    if (!_midMView) {
        _midMView = [DZHomeMidMView viewFormNib];
//         @weakify(self);
//        _midMView.block = ^(NSString *link_url) {
//            @strongify(self);
//            YCWebViewController *vc = [[YCWebViewController alloc] init];
//            vc.web_url = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,link_url];
//            [self.navigationController pushViewController:vc animated:YES];
//        };
    }
    return _midMView;
}




- (DZHomeMiddleView *)middleView {
    if(!_middleView) {
        _middleView = [DZHomeMiddleView viewFormNib];
        @weakify(self);
        _middleView.leftBlock = ^(NSString *JsonModel) {
        @strongify(self);
            DZLexzViewController *lexzVc = [[DZLexzViewController alloc]init];
            lexzVc.source = 5;
            [self.navigationController pushViewController:lexzVc animated:YES];
        };
        
        _middleView.rightBlock = ^(NSString *JsonModel) {
            @strongify(self);
            DZLexzViewController *lexzVc = [[DZLexzViewController alloc]init];
            lexzVc.source = 5;
            [self.navigationController pushViewController:lexzVc animated:YES];
        };
//        [[_middleView.timeLimitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self);
//            if (self.timeLeft > 0) {
//                DZTimeLimitVC *vc = [[DZTimeLimitVC alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }else {
//                [SVProgressHUD showInfoWithStatus:@"暂无限时特惠"];
//            }
//
//        }];
        
//        [[_middleView.customButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self);
//            if (self.timeLeft > 0) {
//                DZTimeLimitVC *vc = [[DZTimeLimitVC alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
//            } else {
//                [SVProgressHUD showInfoWithStatus:@"暂无限时特惠"];
//            }
//        }];
    }
    return _middleView;
}

- (DZHomeMidBottomView *)midBottomView
{
    if (!_midBottomView) {
        _midBottomView = [DZHomeMidBottomView viewFormNib];
        @weakify(self);
        _midBottomView.jBlock = ^{
            @strongify(self);
            DZJfdhViewController *jfdhVc = [[DZJfdhViewController alloc]init];
            [self.navigationController pushViewController:jfdhVc animated:YES];
        };
        _midBottomView.hBlock = ^{
          //会员权益
            @strongify(self);
            DZLexzViewController *lexzVc = [[DZLexzViewController alloc]init];
            lexzVc.source = 3;
            [self.navigationController pushViewController:lexzVc animated:YES];
        };
        _midBottomView.dBlock = ^{
          //待开发
            @strongify(self);
        };
    }
    return _midBottomView;
}

- (UITableView *)adTableView {
    if(!_adTableView) {
        _adTableView = [[UITableView alloc] init];
        _adTableView.delegate = self;
        _adTableView.dataSource = self;
        _adTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_adTableView registerNib:[UINib nibWithNibName:kHomeAdCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kHomeAdCell];
        _adTableView.scrollEnabled = NO;
        _adTableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        _adTableView.backgroundColor = [UIColor redColor];
    }
    return _adTableView;
}

- (HMSegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl=[[HMSegmentedControl alloc] initWithSectionTitles:@[@"推荐产品",@"上新产品",@"一件代发",@"定制产品",@"关注"]];
        
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectionIndicatorColor=OrangeColor;
        _segmentedControl.selectionIndicatorHeight=1;
        _segmentedControl.borderWidth=1;
        _segmentedControl.borderColor=[UIColor colorWithRed:0.965f green:0.965f blue:0.965f alpha:1.00f];
        
        NSDictionary *selectdefaults = @{
                                         NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                         NSForegroundColorAttributeName : OrangeColor,
                                         };
        NSMutableDictionary *selectresultingAttrs = [NSMutableDictionary dictionaryWithDictionary:selectdefaults];
        
        NSDictionary *defaults = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
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
            //[self loadDiscovery:index];
            self.goodsIndex = index;
            self.page = 1;
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
        
        [_goodsVC.clickSubject subscribeNext:^(id model) {
            @strongify(self);
            if ([model isKindOfClass:DZGoodsModel.class]) {
                DZGoodsModel *goods = model;
                DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
                vc.goodsId = goods.goods_id;
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([model isKindOfClass:DZBannerModel.class]) {
                //点击了广告
                DZBannerModel *banner = model;                
                
                //根据类型分别处理
                if ([banner.type isEqualToString:@"0"]) { //跳转网页
                    YCWebViewController *vc = [[YCWebViewController alloc] init];
                    vc.web_url = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,banner.link_url];;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([banner.type isEqualToString:@"5"]) { //店铺
                    DZShopDetailVC *vc = [[DZShopDetailVC alloc] init];
                    vc.shopId = banner.item_id;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([banner.type isEqualToString:@"6"]) { //商品
                    DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
                    vc.goodsId = banner.item_id;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }];
    }
    return _goodsVC;
}
- (DZHomeBottomView *)bottomView {
    if(!_bottomView) {
        _bottomView = [DZHomeBottomView viewFormNib];
    }
    return _bottomView;
}

- (NSMutableArray *)adArray {
    if(!_adArray) {
        _adArray = [NSMutableArray array];
    }
    return _adArray;
}

- (NSMutableArray *)goodsArray {
    if(!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

- (DZHomeStartupView *)startupView {
    if(!_startupView) {
        _startupView = [DZHomeStartupView viewFormNib];
        _startupView.frame = SCREEN_BOUNDS;
        
        __weak DZHomeStartupView *weakStartupView = _startupView;
        [[_startupView.jumpButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakStartupView removeFromSuperview];
        }];
    }
    return _startupView;
}

- (DZHomeNavTitleView *)navView {
    if(!_navView) {
        _navView = [DZHomeNavTitleView viewFormNib];
        @weakify(self);
        [[_navView.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            DZSearchVC *vc = [[DZSearchVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        _navView.block = ^{
            @strongify(self);
            SingleLocationViewController *vc = [[SingleLocationViewController alloc]init];
            vc.block = ^(NSString *city) {
                [self.navView.goMap setTitle:city forState:UIControlStateNormal];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        [[_navView.messageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if(![self checkLogin]) {
                return;
            }
            JSMessageListViewController *vc = [JSMessageListViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _navView;
}

- (UIView *)segmentedContainer {
    if(!_segmentedContainer) {
        _segmentedContainer = [[UIView alloc] init];
    }
    return _segmentedContainer;
}


- (void)setupCartBtn
{
    WMDragView *logoView = [[WMDragView alloc] initWithFrame:CGRectMake(0, 0 , 60, 60)];
    logoView.layer.cornerRadius = 30;
    logoView.isKeepBounds = NO;
    //设置网络图片
    logoView.imageView.image = [UIImage imageNamed:@"shopCar"];
   
    [self.view addSubview:logoView];
    //限定logoView的活动范围
    CGFloat tabBarH = [[UIApplication sharedApplication] statusBarFrame].size.height>20? 83.0:49.0;
    logoView.freeRect = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44, self.view.frame.size.width, self.view.frame.size.height-([UIApplication sharedApplication].statusBarFrame.size.height + 44) - tabBarH);
    logoView.center =CGPointMake(self.view.frame.size.width - 50, self.view.frame.size.height - 50 - tabBarH);
    
    ///点击block
    logoView.clickDragViewBlock = ^(WMDragView *dragView){
        DZCartVC *cartVc = [[DZCartVC alloc] init];
        [self.navigationController pushViewController:cartVc animated:YES];
        
    };
    ///开始拖曳block
    logoView.beginDragBlock = ^(WMDragView *dragView){
        NSLog(@"开始拖曳");
       
    };
    
    ///结束拖曳block
    logoView.endDragBlock = ^(WMDragView *dragView){
        NSLog(@"结束拖曳");
        
    };
}

#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:6];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:6];
    
    //设置开启虚拟定位风险监测，可以根据需要开启
    [self.locationManager setDetectRiskOfFakeLocation:NO];
}

- (void)initCompleteBlock
{
    
     @weakify(self);
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        @strongify(self);
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.userInfo);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.userInfo);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.userInfo);
            
            //存在虚拟定位的风险的定位结果
            __unused CLLocation *riskyLocateResult = [error.userInfo objectForKey:@"AMapLocationRiskyLocateResult"];
            //存在外接的辅助定位设备
            __unused NSDictionary *externalAccressory = [error.userInfo objectForKey:@"AMapLocationAccessoryInfo"];
            
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //根据定位信息，添加annotation
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        [annotation setCoordinate:location.coordinate];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:[NSString stringWithFormat:@"%lf",location.coordinate.latitude] forKey:@"lat"];
        [def setObject:[NSString stringWithFormat:@"%lf",location.coordinate.longitude] forKey:@"lng"];
        [def setObject:regeocode.district forKey:@"district"];
        [def synchronize];
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
            [annotation setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
            [self.navView.goMap setTitle:regeocode.district forState:UIControlStateNormal];
            //            [annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
        }
        else
        {
            [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
            [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
        }
        
    };
}


@end
