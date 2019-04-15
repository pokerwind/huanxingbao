//
//  DZLexzViewController.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/24.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZLexzViewController.h"
#import "DZLxzTableViewCell.h"
#import "DZLexzHead.h"
#import "DZTimeLimitModel.h"
#import "JSFreeModel.h"
#import "JSGiftModel.h"
#import "JSVipModel.h"
#import "DZJfdhHead.h"
#import "DZGoodsDetailVC.h"
#import "DZCartPayVC.h"
#import "DPMobileApplication.h"
#import "THLexiangzhuangModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import<ShareSDKUI/SSUIShareActionSheetStyle.h>

#import <LinkedME_iOS/LMLinkProperties.h>
#import <LinkedME_iOS/LMUniversalObject.h>
#import "DzlexDetailVC.h"
@interface DZLexzViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) LMUniversalObject *linkedUniversalObject;

/*
 * items
 */
@property (nonatomic,strong)NSMutableArray *items;
/*
 * tableView
 */
@property (nonatomic,strong)UITableView *tableView;

/*
 * DZLexzHead
 */
@property (nonatomic,strong)DZLexzHead *headView;

/*
 * DZJfdhHead
 */
@property (nonatomic,strong)DZJfdhHead *headV;

/*
 * 页数
 */
@property (nonatomic,assign)NSInteger page;

/*
 * desc
 */
@property (nonatomic,copy)NSString *desc;

@end

@implementation DZLexzViewController



- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.desc = @"暂无说明";
    self.page = 1;
    if (self.source == 1) {
        self.navigationItem.title = @"乐享赚";
        
    }else if (self.source == 2){
        self.navigationItem.title = @"礼包兑换";
    }else if (self.source == 3){
        self.navigationItem.title = @"会员权益";
    }else if (self.source == 4){
        self.navigationItem.title = @"免费试用";
    }else if (self.source == 7) {
        self.navigationItem.title = @"免费试用";
    }
    else{
        self.navigationItem.title = @"限时特惠";
//        [self getData];
    }
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];;
    
    [self.tableView.mj_header beginRefreshing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -- 懒加载 --
- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-KNavigationBarH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
       
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            if (self.source == 5) {
                [self getData];
            }else if (self.source == 4){
                [self getFreeData];
            }else if (self.source == 3){
                [self getVipData];
            }else if (self.source == 2){
                [self getGiftData];
            }else if (self.source == 7) {
                [self getFreeDataAction];
            }else if (self.source == 1){
                [self lexiangzhuangAction];
            }
        }];
        if (self.source != 1) {
            _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                @strongify(self);
                self.page++;
                if (self.source == 5) {
                    [self getData];
                }else if (self.source == 4){
                    [self getFreeData];
                }else if (self.source == 3){
                    [self getVipData];
                }else if (self.source == 2){
                    [self getGiftData];
                }else if (self.source == 7) {
                    [self getFreeDataAction];
                }
            }];
        }
        if (self.source == 1||self.source == 5) {
            
        }else{
//            _tableView.tableHeaderView = self.headView;

        }
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
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


#pragma mark -- tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
//    return 5;
}
//设置标识
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZLxzTableViewCell *cell =  [DZLxzTableViewCell cellWithTableView:tableView];
    cell.tag = indexPath.row;
    cell.source = self.source;
    if (self.source == 5) {
        cell.model = self.items[indexPath.row];
    }else if (self.source == 4){
        cell.freeList = self.items[indexPath.row];
    }else if (self.source == 3){
        cell.vipList = self.items[indexPath.row];
    }else if (self.source == 2){
        cell.giftList = self.items[indexPath.row];
    }else if (self.source == 7){
        cell.freeList = self.items[indexPath.row];
    }else {
        cell.lexiangzhuanModel = self.items[indexPath.row];
    }
    @weakify(self);
    cell.btnBlock = ^(NSInteger source, NSInteger tag) {
    @strongify(self);
        if (source == 5) {
            DZTimeLimitModel *model = self.items[indexPath.row];
            //限时活动
            DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
            vc.goodsId = model.goods_id;
            vc.act_id = model.act_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (source == 4){
            JSFreeList *model = self.items[indexPath.row];
            //免费
            DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
            vc.ismianfeishiyong = @"YES";
            vc.goodsId = model.goods_id;
            vc.act_id = model.act_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (source == 3){
            JSVipList *model = self.items[indexPath.row];
            //vip
            DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
            vc.goodsId = model.goods_id;
            vc.act_id = model.act_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (source == 2){
            JSGiftList *model = self.items[indexPath.row];
            
            [self getBuyGiftWithId:model.id];
            
//            DZCartPayVC *vc = [DZCartPayVC new];
//            vc.source = 1;
////            vc.delegate = self;
////            vc.goodsCount = self.model.data.total_buy_number;
////            vc.goodsPrice = self.model.data.total_amount;
////            vc.expressPrice = self.model.data.express_amount;
////            vc.totalPrice = self.model.data.real_pay_amount;
////            vc.orderSN = self.order_sn;
//            [self.navigationController pushViewController:vc animated:YES];
            
            //礼包
//            DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
//            vc.goodsId = model.id;
////            vc.act_id = model.act_id;
//            [self.navigationController pushViewController:vc animated:YES];
        }else if (source == 7){
            JSFreeList *model = self.items[indexPath.row];
            //免费
            DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
            vc.goodsId = model.goods_id;
            vc.act_id = model.act_id;
            vc.cash_pledge = model.cash_pledge;
            vc.iswodeshiyong = @"YES";
            vc.order_sn = self.order_sn;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (source == 1){
        
            //DZLexzDetailVC * dzlex = [[DZLexzDetailVC alloc] init];
            THLexiangzhuangModel *model = self.items[indexPath.row];
//             dzlex.goodsId = model.goods_id;
//             dzlex.act_id =  model.act_id;
//
            
            DzlexDetailVC *vc = [[DzlexDetailVC alloc] init];
            vc.goodsId = model.goods_id;
            vc.act_id = model.act_id;
            [self.navigationController pushViewController:vc animated:YES];
            
//            NSLog(@"%@=======",model.goods_id);
//            //[DPMobileApplication sharedInstance].loginUser.token
//            [self.navigationController pushViewController:dzlex animated:YES];
//
        
        }
    };
    if (self.source == 7){
        [cell.btn setBorderCornerRadius:0 andBorderWidth:1 andBorderColor:RGBACOLOR(180, 171, 128, 1)];
        [cell.btn setBackgroundImage:nil forState:UIControlStateNormal];
        [cell.btn setTitle:@"立即选择" forState:UIControlStateNormal];
//        cell.btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cell.btn setTitleColor:RGBACOLOR(180, 171, 128, 1) forState:UIControlStateNormal];

    }
    return cell;
}
- (void)lexiangzhuanFenXiang:(THLexiangzhuangModel *)model1 {
    [SVProgressHUD show];
    NSDictionary *params = @{@"act_id":model1.act_id,@"goods_id":model1.goods_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/DeepLinkApi/click_share_goods" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        JSFreeModel *model = [JSFreeModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
            NSDictionary *dic = request.rawJSONObject[@"data"];
            [SVProgressHUD dismiss];
            //分享
            self.linkedUniversalObject = [[LMUniversalObject alloc] init];
            self.linkedUniversalObject.title = @"标题";//标题
            LMLinkProperties *linkProperties = [[LMLinkProperties alloc] init];
            linkProperties.channel = @"微信";//渠道(微信,微博,QQ,等...)
            linkProperties.feature = @"Share";//特点
            linkProperties.tags=@[@"LinkedME",@"Demo"];//标签
            linkProperties.stage = @"Live";//阶段
            [linkProperties addControlParam:@"parent_id" withValue:[NSString stringWithFormat:@"%@",dic[@"parent_id"]]];//自定义参数，用于在深度链接跳转后获取该数据，这里代表页面唯一标识
            
            [linkProperties addControlParam:@"goods_id" withValue:[NSString stringWithFormat:@"%@",dic[@"goods_id"]]];//自定义参数，用于在深度链接跳转后获取该数据，这里代表页面唯一标识

            [linkProperties addControlParam:@"sglid" withValue:[NSString stringWithFormat:@"%@",dic[@"sglid"]]];//自定义参数，用于在深度链接跳转后获取该数据，这里代表页面唯一标识

            //    [linkProperties addControlParam:@"LinkedME" withValue:@"Demo"];//自定义参数，用于在深度链接跳转后获取该数据，这里标识是Demo
            //开始请求短链
            
            [self.linkedUniversalObject getShortUrlWithLinkProperties:linkProperties andCallback:^(NSString *url, NSError *err) {
                NSString *liveURLStr = @"";
                if (url) {
                    NSLog(@"[LinkedME Info] SDK creates the url is:%@", url);
                    //拼接连接1
                    //            [H5_LIVE_URL stringByAppendingString:arr[page][@"form"]];
                    //            [H5_LIVE_URL stringByAppendingString:@"?linkedme="];
                    liveURLStr = [NSString stringWithFormat:@"%@?linkedme=%@&parent_id=%@&sglid=%@&goods_id=%@",dic[@"url"],url,dic[@"parent_id"],dic[@"sglid"],dic[@"goods_id"]];
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
                NSArray* imageArray = @[FULL_URL(dic[@"icon"])];
                //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
                if (imageArray) {
                    
                    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                    [shareParams SSDKSetupShareParamsByText:dic[@"goods_name"]
                                                     images:imageArray
                                                        url:[NSURL URLWithString:liveURLStr]
                                                      title:dic[@"goods_name"]
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
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中一行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}
//每行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 177;
}

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (DZLexzHead *)headView {
    if(!_headView) {
        _headView = [DZLexzHead viewFormNib];
        _headView.frame = CGRectMake(0, 0,KScreenWidth, KScreenWidth *4/7.5);
        _headView.contentL.text = self.desc;
//        @weakify(self);
    }
    return _headView;
}


- (DZJfdhHead *)headV {
    if(!_headV) {
        _headV = [DZJfdhHead viewFormNib];
        _headV.frame = CGRectMake(0, 0,KScreenWidth, KScreenWidth *4/7.5);
        _headV.nameL.text = @"VIP等级";
        _headV.priceL.text = self.desc;
        _headV.descL.text = @"满足VIP等级方可兑换";
        //        @weakify(self);
    }
    return _headV;
}

- (void)getBuyGiftWithId:(NSString *)bag_id
{
    [SVProgressHUD show];
    NSDictionary *params = @{@"bag_id":bag_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexUserApi/doBuyGiftBag" parameters:params method:LCRequestMethodPost];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
//        JSFreeModel *model = [JSFreeModel objectWithKeyValues:request.responseJSONObject];
        if ([[request.responseJSONObject objectForKey:@"status"] integerValue] == 1) {
            
            DZCartPayVC *vc = [DZCartPayVC new];
            vc.source = 1;
            //            vc.delegate = self;
            vc.goodsCount = @"1";
            vc.goodsPrice = [[request.responseJSONObject objectForKey:@"data"] objectForKey:@"price"];
            vc.expressPrice = @"0";
            vc.totalPrice = [[request.responseJSONObject objectForKey:@"data"] objectForKey:@"price"];
            vc.orderSN =[[request.responseJSONObject objectForKey:@"data"] objectForKey:@"order_sn"];
            [self.navigationController pushViewController:vc animated:YES];
            
//            self.desc = model.data.desc;
//            _tableView.tableHeaderView = self.headView;
//            if (self.page == 1) {
//                [self.items removeAllObjects];
//                [self.tableView.mj_header endRefreshing];
//            } else {
//                [self.tableView.mj_footer endRefreshing];
//            }
//            [self.items addObjectsFromArray:model.data.list];
        }else{
            [SVProgressHUD showErrorWithStatus:[request.responseJSONObject objectForKey:@"info"]];
        }
     
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
          [SVProgressHUD dismiss];
          [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}



- (void)getData{
    NSDictionary *params = @{@"p":@(self.page)};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexUserApi/limitSaleList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        DZTimeLimitNetModel *model = [DZTimeLimitNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.items removeAllObjects];
            if (self.page == 1) {
               
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.items addObjectsFromArray:model.data];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
         [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)getFreeDataAction {
    NSDictionary *params = @{@"order_sn":self.order_sn,@"token":[DPMobileApplication sharedInstance].loginUser.token};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/UserCenterApi/startCunLiu" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        JSFreeModel *model = [JSFreeModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
            self.desc = model.data.desc;
            _tableView.tableHeaderView = self.headView;
            [self.items removeAllObjects];
            if (self.page == 1) {
            } else {
            }
            [self.items addObjectsFromArray:model.data.list];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
        [self.tableView.mj_header endRefreshing];
    }];
}
//乐享赚
- (void)lexiangzhuangAction {
    NSDictionary *params = @{};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexUserApi/shareGoodsList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        JSFreeModel *model = [JSFreeModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
            [self.items removeAllObjects];
            NSArray *dataArray = request.rawJSONObject[@"data"][@"list"];
            if (dataArray == nil) {
                dataArray = @[];
            }
            NSMutableArray *modelArray = [NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
                THLexiangzhuangModel *model = [[THLexiangzhuangModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [modelArray addObject:model];
            }
            [self.items addObjectsFromArray:modelArray];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)getFreeData
{
    NSDictionary *params = @{@"p":@(self.page)};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexUserApi/freeTestGoodsList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        JSFreeModel *model = [JSFreeModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
            self.desc = model.data.desc;
            _tableView.tableHeaderView = self.headView;
            if (self.page == 1) {
                [self.items removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.items addObjectsFromArray:model.data.list];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)getGiftData
{
    NSDictionary *params = @{@"p":@(self.page)};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexUserApi/getGiftBagList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        JSGiftModel *model = [JSGiftModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
             self.desc = model.data.desc;
            _tableView.tableHeaderView = self.headView;
             [self.items removeAllObjects];
            if (self.page == 1) {
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.items addObjectsFromArray:model.data.list];
//            self.headView.contentL.text = self.desc;
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)getVipData
{
    NSDictionary *params = @{@"p":@(self.page)};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexUserApi/promotionList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        JSVipModel *model = [JSVipModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
            _tableView.tableHeaderView = self.headV;
            if (self.page == 1) {
                [self.items removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.items addObjectsFromArray:model.data.list];
            if (self.items.count == 0) {
                self.desc = model.data.my_vip_level;
            }else {
                self.desc = model.data.my_vip_level;
            }
            _headV.priceL.text = self.desc;
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
        [self.tableView.mj_header endRefreshing];
    }];
}

@end
