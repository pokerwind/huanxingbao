//
//  DZGoodsDetailVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/2.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodsDetailVC.h"
#import "DZGoodsDetailBottomV.h"
#import "SDCycleScrollView.h"
#import "DZGoodsDetailTitleView.h"
#import "DZGoodsDetailPriceView.h"
#import "DZGoodsDetailRemarkView.h"
#import "DZGoodsDetailShopView.h"
#import "DZGoodsDetailPullView.h"
#import "DZCartVC.h"
#import "DZGoodsDetailNavView.h"
#import "JSMessageListViewController.h"
#import "DZAddCartVC.h"
#import "DZShopDetailVC.h"
#import "DZShopCommentVC.h"
#import "DZGoodsDetailNetModel.h"
#import "DZGoodsDetailImageCell.h"
#import "FTPopOverMenu.h"
#import "DZMessageVC.h"
#import "DZGoodsDetailTimeLimitView.h"
#import "DZShopCateVC.h"
#import "DZEMChatUserModel.h"
#import "ChatViewController.h"
#import "DZLoginVC.h"
#import "LNNavigationController.h"
#import "DZFeedbackVC.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import<ShareSDKUI/SSUIShareActionSheetStyle.h>

#import "DZGoodsDetailIntroView.h"
#import "DZGoodsDetailIntroModel.h"
#import "JSShopSpecView.h"
#import "JSShopAttrView.h"
#import "ChoseGoodsTypeAlert.h"
#import "SizeAttributeModel.h"
#import "GoodsTypeModel.h"
#import "Header.h"
#import "DZSubmitOrderVC.h"
#define kGoodsDetailImageCell @"DZGoodsDetailImageCell"
#import <LinkedME_iOS/LMLinkProperties.h>
#import <LinkedME_iOS/LMUniversalObject.h>
#import "JSFreeModel.h"


#define H5_LIVE_URL @""

@interface DZGoodsDetailVC ()<SDCycleScrollViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) SDCycleScrollView *bannerView;
@property (strong, nonatomic) DZGoodsDetailTitleView *titleView;
@property (strong, nonatomic) DZGoodsDetailPriceView *priceView;
@property (nonatomic,strong)  JSShopSpecView *specView;
@property (nonatomic,strong)  JSShopAttrView *attrView;
@property (strong, nonatomic) DZGoodsDetailRemarkView *remarkView;
@property (strong, nonatomic) DZGoodsDetailShopView *shopView;
@property (strong, nonatomic) DZGoodsDetailPullView *pullView;
@property (strong, nonatomic) DZGoodsDetailBottomView *bottomView;
@property (strong, nonatomic) DZGoodsDetailBottomV *bottomV;

@property (strong, nonatomic) DZGoodsDetailNavView *navView;
@property (strong, nonatomic) DZGoodsDetailTimeLimitView *timeLimitView;
@property (strong, nonatomic) DZGoodsDetailIntroView *introView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *heightArray;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *cartButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *numLabel2;

@property (nonatomic, strong) DZGoodsDetailModel *model;
@property (nonatomic, assign) CGFloat oldHeight;
@property (nonatomic, assign) BOOL isScrolling;
@property (nonatomic, assign) BOOL isUp; //是否在上面，还未完全展示图文详情
@property (nonatomic, assign) BOOL isDraging;

@property (nonatomic, assign) BOOL isActivity;
@property (nonatomic, assign) NSString *activityPrice;

@property (nonatomic, assign) NSTimeInterval timeLeft;
@property (nonatomic, strong) FTPopOverMenuView *popMenuView;
@property(nonatomic,strong) NSDictionary *datapingjia;
/*
 * 选择商品数量
 */
@property (nonatomic,copy)NSString *buy_Count;

/*
 * sepc
 */
@property (nonatomic,copy)NSString *sepc_key;

/*
 * GoodsModel
 */
@property (nonatomic,strong)GoodsModel *goodsModel;


@property(nonatomic,strong) LMUniversalObject *linkedUniversalObject;


@end

@implementation DZGoodsDetailVC

- (instancetype)init
{
    if (self =[super init]) {
        self.buy_Count = @"1";
    }
    return self;
}

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.scrollView];
   
    [self.view addSubview:self.navView];
    
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
    
    [self.scrollView addSubview:self.bannerView];
    [self.scrollView addSubview:self.timeLimitView];
    [self.scrollView addSubview:self.titleView];
    [self.scrollView addSubview:self.priceView];
    [self.scrollView addSubview:self.specView];
//    [self.scrollView addSubview:self.attrView];
    [self.scrollView addSubview:self.remarkView];
    [self.scrollView addSubview:self.shopView];
    [self.scrollView addSubview:self.introView];
    //[self.scrollView addSubview:self.pullView];
    
    [self.scrollView addSubview:self.tableView];
    self.isUp = YES;
    
    @weakify(self);
    [RACObserve(self.tableView, contentSize) subscribeNext:^(NSValue *size) {
        @strongify(self);
        CGFloat height = size.CGSizeValue.height;
        if (height != self.oldHeight) {
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            self.oldHeight = height;
        }
    }];
    
    
    [self loadData];
    
    // 写在 ViewDidLoad 的最后一行
//    [self setSubViewsLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setSubViewsFrame];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark - ---- 代理相关 ----
#pragma mark UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY>0) {
        CGFloat alpha = offsetY/(SCREEN_WIDTH * 785 / 750);
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
    return;
    CGFloat top = [self pullTop] + 46;
    CGFloat pull = offsetY + SCREEN_HEIGHT - 50 - top;
    CGFloat posTop = -(SCREEN_HEIGHT - 50 - top);
    CGFloat posDown = top + 64;
    CGFloat pull2 = top - offsetY;
    
    if (self.scrollView.isDragging) {
        return;
    }
//    if(self.isUp) {
//        if (pull > 0) {
//            [self.scrollView setContentOffset:CGPointMake(0, posTop) animated:NO];
//        }
//    } else {
//        if (pull2 > 0) {
//            [self.scrollView setContentOffset:CGPointMake(0, posDown) animated:NO];
//        }
//    }

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    return;
        CGFloat offsetY = scrollView.contentOffset.y;
    if (self.model && !self.isScrolling) {
        //self.isScrolling = YES;
        //计算被上拉的高度
        CGFloat top = [self pullTop] + 46;
        CGFloat pull = offsetY + SCREEN_HEIGHT - 50 - top;
        CGFloat posTop = -(SCREEN_HEIGHT - 50 - top);
        CGFloat posDown = top - 64;
        
        CGFloat pull2 = posDown - offsetY;
        if (pull > 0) {
            if (self.isUp) {
                if (pull + velocity.y * 1000 < 150) {
                    //需要归位，即回到pull=0的地方
                    //[self.scrollView setContentOffset:CGPointMake(0, posTop) animated:YES];
                    targetContentOffset->y = posTop;
                } else {
                    //pull需要上移到顶部
                    //[self.scrollView setContentOffset:CGPointMake(0, posDown) animated:YES];
                    targetContentOffset->y = posDown;
                    self.isUp = NO;
                }
            } else {
                if (pull2 > 0) {
                    if (pull2 - velocity.y * 1000  < 150) {
                        //[self.scrollView setContentOffset:CGPointMake(0, posDown) animated:YES];
                        targetContentOffset->y = posDown;
                    } else {
                        //[self.scrollView setContentOffset:CGPointMake(0, posTop) animated:YES];
                        targetContentOffset->y = posTop;
                        self.isUp = YES;
                    }
                }
            }
            
        }
        
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //self.isScrolling = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isDraging = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.isDraging = NO;
}
#pragma mark UITableView delegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZGoodsDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailImageCell];
    DZGoodsGalleryItemModel *item = self.imageArray[indexPath.row];
    NSString *imageUrl = item.image_path;
    @weakify(self);
    [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(imageUrl)] placeholderImage:[UIImage imageNamed:@"avatar_grey"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        if(image && !item.isLoaded) {
            //计算出应该的高度
            CGFloat height = (SCREEN_WIDTH * image.size.height + 5) / (image.size.width + 10);
            [self.heightArray setObject:@(height) atIndexedSubscript:indexPath.row];
            
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadData];
            item.isLoaded = YES;
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = self.heightArray[indexPath.row];
    return height.floatValue + 5;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)favoriteViewClick{
    if (![DPMobileApplication sharedInstance].isLogined) {
        DZLoginVC *vc = [DZLoginVC new];
        LNNavigationController *nvc = [[LNNavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nvc animated:YES completion:nil];
        return;
    }
    
    NSDictionary *params = @{@"goods_id":self.model.goods_info.goods_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/collectGoods" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            if ([model.info isEqualToString:@"收藏成功!"]) {
                self.titleView.heartImageView.image = [UIImage imageNamed:@"gooddetail_icon_liked"];
                self.titleView.collectNum.text = [NSString stringWithFormat:@"%ld", [self.titleView.collectNum.text integerValue] + 1];
                [SVProgressHUD showSuccessWithStatus:model.info];
            }else{
                self.titleView.heartImageView.image = [UIImage imageNamed:@"gooddetail_icon_unlike"];
                self.titleView.collectNum.text = [NSString stringWithFormat:@"%ld", [self.titleView.collectNum.text integerValue] - 1];
                [SVProgressHUD showSuccessWithStatus:model.info];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 私有方法 ----
- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urls = @"/Api/IndexApi/getGoodsDetail";
    if (self.iswodeshiyong.length == 0) {
        urls = @"/Api/IndexApi/getGoodsDetail";
        [params setObject:self.goodsId forKey:@"goods_id"];
        [params setObject:self.act_id forKey:@"act_id"];
    }else {
        urls = @"/Api/UserCenterApi/enterTestGoodsDetail";
        [params setObject:self.goodsId forKey:@"goods_id"];
        [params setObject:self.order_sn forKey:@"order_sn"];
        [params setObject:self.cash_pledge forKey:@"cash_pledge"];

    }
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:urls parameters:params method:LCRequestMethodPost];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGoodsDetailNetModel *model = [DZGoodsDetailNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.model = model.data;
            [self setupViews];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
            
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}
- (void)huoqupingjia {

    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/IndexApi/get_goods_comment_base_info" parameters:@{@"goods_id":self.goodsId} method:LCRequestMethodPost];
//    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGoodsDetailNetModel *model = [DZGoodsDetailNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.datapingjia = request.rawJSONObject[@"data"];
//            self.remarkView.userNameLabel.text = comment.user_name;
//            self.remarkView.contentLabel.text = comment.content;
//            self.remarkView.timeLabel.text = comment.add_time;

        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)setupViews {
    if (self.iswodeshiyong.length == 0) {
        if ([self.model.goods_info.act_type integerValue] == 0) {
            [self.view addSubview:self.bottomView];
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView.mas_bottom);
                make.left.bottom.right.mas_offset(0);
            }];
            if ([self.model.goods_info.is_on_sale isEqualToString:@"0"]) {
                self.bottomView.addLabel.text = @"商品已下架";
                self.bottomView.addView.backgroundColor = HEXCOLOR(0x999999);
                self.bottomView.addButton.enabled = NO;
            }
        }else if ([self.model.goods_info.act_type integerValue] == 2){
            //
            [self.view addSubview:self.bottomV];
            [self.bottomV.btn setTitle:@"立即试用" forState:UIControlStateNormal];
            [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView.mas_bottom);
                make.left.bottom.right.mas_offset(0);
            }];
        }else if ([self.model.goods_info.act_type integerValue] == 5) {
            [self.view addSubview:self.bottomV];
            [self.bottomV.btn setTitle:@"立即购买" forState:UIControlStateNormal];
            [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView.mas_bottom);
                make.left.bottom.right.mas_offset(0);
            }];
            
            if ([self.model.goods_info.is_on_sale isEqualToString:@"0"]) {
                [self.bottomV.btn setTitle:@"商品已下架" forState:UIControlStateNormal];
                self.bottomV.backgroundColor = HEXCOLOR(0x999999);
                self.bottomV.btn.enabled = NO;
            }
            
        }else if ([self.model.goods_info.act_type integerValue] == 1){
            [self.view addSubview:self.bottomV];
            [self.bottomV.btn setTitle:@"立即购买" forState:UIControlStateNormal];
            [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView.mas_bottom);
                make.left.bottom.right.mas_offset(0);
            }];
            
            if ([self.model.goods_info.is_on_sale isEqualToString:@"0"]) {
                [self.bottomV.btn setTitle:@"商品已下架" forState:UIControlStateNormal];
                self.bottomV.backgroundColor = HEXCOLOR(0x999999);
                self.bottomV.btn.enabled = NO;
            }
        }
        else{
            [self.view addSubview:self.bottomV];
            [self.bottomV.btn setTitle:@"立即兑换" forState:UIControlStateNormal];
            [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView.mas_bottom);
                make.left.bottom.right.mas_offset(0);
            }];
        }
    }else {
        [self.view addSubview:self.bottomV];
        [self.bottomV.btn setTitle:@"立即选择" forState:UIControlStateNormal];
        [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_bottom);
            make.left.bottom.right.mas_offset(0);
        }];
        
        if ([self.model.goods_info.is_on_sale isEqualToString:@"0"]) {
            [self.bottomV.btn setTitle:@"商品已下架" forState:UIControlStateNormal];
            self.bottomV.backgroundColor = HEXCOLOR(0x999999);
            self.bottomV.btn.enabled = NO;
        }
    }
    
    [self setupBanner];
    [self setupInfo];
    [self setupAttr];

    [self setupShopComment];
    [self setupShopInfo];
    [self setupImages];
    [self setupActivity];
    [self setupIntro];
}

- (void)setupBanner {
    NSMutableArray *urls = [NSMutableArray array];
    for (DZGoodsGalleryItemModel *item in self.model.goods_gallery) {
        [urls addObject:FULL_URL(item.image_path)];
    }
    self.bannerView.imageURLStringsGroup = urls;
}

- (void)setupInfo {
    DZGoodsInfoModel *info = self.model.goods_info;
    self.titleView.titleLabel.text = info.goods_name;
    self.titleView.collectNum.text = info.collect_num;
    if (info.is_favorite) {
        self.titleView.heartImageView.image = [UIImage imageNamed:@"gooddetail_icon_liked"];
    }else{
        self.titleView.heartImageView.image = [UIImage imageNamed:@"gooddetail_icon_unlike"];
    }
    
//    self.priceView.retailNumLabel.text = [NSString stringWithFormat:@"%@-%d件",info.retail_amount,[info.basic_amount intValue] - 1];
//    self.priceView.packNumLabel.text = [NSString stringWithFormat:@"%@件以上",info.basic_amount];
    
    self.priceView.shopPriceLabel.text = [NSString stringWithFormat:@"￥%@",info.shop_price];
//    self.priceView.packPriceLabel.text = [NSString stringWithFormat:@"￥%@",info.pack_price];
    self.priceView.timeLabel.text = [NSString stringWithFormat:@"%ld天前发布",(long)info.day_ago];
    self.priceView.viewNumLabel.text = [NSString stringWithFormat:@"月销%@件",info.sale_num];
    self.priceView.soldNumLabel.text = [NSString stringWithFormat:@"%@%@%@",self.model.shop_info.province,self.model.shop_info.city,self.model.shop_info.country];
}

- (void)setupAttr
{
//    NSMutableArray *items = [NSMutableArray array];
    if (self.model.goods_attr == nil) {
//        return;
        self.model.goods_attr = @[];
        JSShopAttrView *attrView = [JSShopAttrView viewFormNib];
        [self.scrollView addSubview:attrView];
        
        [attrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.specView.mas_bottom).mas_offset(0);
            make.left.right.mas_offset(0);
            make.height.mas_equalTo(44);
        }];
        self.attrView = attrView;
        attrView.nameL.text = @"暂无";
        attrView.contentL.text = @"";
        
        [self setSubViewsLayout];
        return;
    }
    for (int i = 0; i < self.model.goods_attr.count; i++) {
        DZGoodsAttrItemModel *model = self.model.goods_attr[i];
        
        JSShopAttrView *attrView = [JSShopAttrView viewFormNib];
        [self.scrollView addSubview:attrView];
    
        [attrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.specView.mas_bottom).mas_offset(i*44);
            make.left.right.mas_offset(0);
            make.height.mas_equalTo(44);
        }];
        
        if (i == self.model.goods_attr.count -1) {
            self.attrView = attrView;
        }
        attrView.nameL.text = [NSString stringWithFormat:@"%@:",model.attr_name];
        attrView.contentL.text = model.attr_value;
        
       
//        [items addObject:[NSString stringWithFormat:@"%@: %@",model.attr_name,model.attr_value]];
        
//        self.attrView.contentL.text = [items componentsJoinedByString:@", "];
    }
    
      [self setSubViewsLayout];
}

- (void)setupShopComment {
    NSDictionary *shop_comment = self.model.shop_comment;
//
    self.remarkView.rateLabel.text = [NSString stringWithFormat:@"%@%%",shop_comment[@"ravorableRate"]];
    self.remarkView.commentNumLabel.text = [NSString stringWithFormat:@"%@条评论",shop_comment[@"commentCount"]];
    //如果没有评论，隐藏下面的部分，有则显示。
    NSString *str = shop_comment[@"commentCount"];
    NSInteger newCommentCount = str.intValue;
    if (newCommentCount == 0) {
        //隐藏掉,其实就是改变View高度？
        [self.remarkView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
    }else {
        [self.remarkView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(shop_comment[@"newComment"][@"head_pic"])] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
        self.remarkView.userNameLabel.text = shop_comment[@"newComment"][@"user_name"];
        NSString *contents = shop_comment[@"newComment"][@"content"];
        self.remarkView.contentLabel.text = contents;
        self.remarkView.timeLabel.text = shop_comment[@"newComment"][@"add_time"];
        
        CGFloat remarkHeight = 117;
        CGSize size = [contents sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 24, MAXFLOAT)];
        
        CGFloat height = size.height;
        if (height > 15) {
            remarkHeight += (height - 15);
        }
        
        [self.remarkView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(remarkHeight);
        }];
    }
//    if(model.neoComment.count > 0 && ![model.commentCount isEqualToString:@"0"]) {
//        DZGoodsShopCommentItemModel *comment = model.neoComment.firstObject;
//
//
//    } else {
//
//    }
}

- (void)setupShopInfo {
    DZGoodsShopInfoModel *shop = self.model.shop_info;
    
    [self.shopView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(shop.shop_logo)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.shopView.nameLabel.text = shop.shop_name;
    self.shopView.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",shop.province,shop.city,shop.country];
    self.shopView.soldNumLabel.text = shop.rank;
    self.shopView.updateNumLabel.text = shop.service_rank;
    self.shopView.suppRateLabel.text = shop.express_rank;
}

- (void)setupImages {
    NSArray *images = self.model.goods_desc;
    [self.imageArray removeAllObjects];
    [self.heightArray removeAllObjects];
    for (DZGoodsGalleryItemModel *item in images) {
        [self.imageArray addObject:item];
        [self.heightArray addObject:@(10)];
    }
    if(images.count == 0) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }

    [self.tableView reloadData];
}

- (void)setupActivity {
//    DZGoodsActivityModel *model = self.model.goods_info.activity;
//    if (model) {
//        if(model.start_time >0 && model.end_time >0) {
//            if(model.start_time < model.now_time && model.now_time < model.end_time) {
//                //进行中  显示出限时抢购view
//                self.isActivity = YES;
//                self.activityPrice = model.activity_price;
//                
//                [self.timeLimitView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.mas_equalTo(40);
//                }];
//                
//                self.timeLimitView.activityPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.activity_price];
//                
//                //self.timeLimitView.shopPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.shop_price];
//                NSString *oldPrice = [NSString stringWithFormat:@"￥%@",model.shop_price];
//                NSUInteger length = [oldPrice length];
//                
//                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
//                [attri addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(0, length)];
//                [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
//                [attri addAttribute:NSStrikethroughColorAttributeName value:self.timeLimitView.shopPriceLabel.textColor range:NSMakeRange(0, length)];
//                [self.timeLimitView.shopPriceLabel setAttributedText:attri];
//                
//                NSTimeInterval timeLeft = model.end_time - model.now_time;
//                self.timeLeft = timeLeft;
//                [self setupTimeLeft:timeLeft];
//                @weakify(self);
//                [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal ] subscribeNext:^(id x) {
//                    @strongify(self);
//                    self.timeLeft--;
//                    [self setupTimeLeft:self.timeLeft];
//                }];
//            }
//        }
//        
//    }
}

- (void)setupIntro {
    
//    if (self.model) {
//        self.introView.titleLabel.text = self.model.goods_info.goods_description;
//    }
//
//    NSMutableArray *introArray = [NSMutableArray array];
//
//
//    DZGoodsShopSpecModel *spec = self.model.goods_spec;
//    if (spec) {
//        if ([spec.color notBlank]) {
//            //self.introView.colorLabel.text = spec.color;
//            DZGoodsDetailIntroModel *model = [[DZGoodsDetailIntroModel alloc] init];
//            model.name = @"颜色";
//            model.spec = spec.color;
//            [introArray addObject:model];
//        }
//
//        if ([spec.size notBlank]) {
//            //self.introView.sizeLabel.text = spec.size;
//            DZGoodsDetailIntroModel *model = [[DZGoodsDetailIntroModel alloc] init];
//            model.name = @"尺码";
//            model.spec = spec.size;
//            [introArray addObject:model];
//        }
//    }
//
//    NSArray *attrs = self.model.goods_attr;
//
//    for (DZGoodsAttrItemModel *attr in attrs) {
//        //遍历所有属性
//        if ([attr.attr_name isEqualToString:@"季节"]) {
//            DZGoodsDetailIntroModel *model = [[DZGoodsDetailIntroModel alloc] init];
//            model.name = @"季节";
//            model.spec = attr.attr_value;
//            [introArray addObject:model];
//            //self.introView.seasonLabel.text = attr.attr_value;
//        } else if ([attr.attr_name isEqualToString:@"面料"]) {
//            DZGoodsDetailIntroModel *model = [[DZGoodsDetailIntroModel alloc] init];
//            model.name = @"面料";
//            model.spec = attr.attr_value;
//            [introArray addObject:model];
//        } else if ([attr.attr_name isEqualToString:@"风格"]) {
//            DZGoodsDetailIntroModel *model = [[DZGoodsDetailIntroModel alloc] init];
//            model.name = @"风格";
//            model.spec = attr.attr_value;
//            [introArray addObject:model];
//        } else if ([attr.attr_name isEqualToString:@"厚度"]) {
//            DZGoodsDetailIntroModel *model = [[DZGoodsDetailIntroModel alloc] init];
//            model.name = @"厚度";
//            model.spec = attr.attr_value;
//            [introArray addObject:model];
//        }
//    }
//
//    self.introView.dataArray = introArray;
//    //根据高度调节view高度？
//    CGFloat height = introArray.count * 24 + 110;
//
//    [self.introView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
}

- (void)setupTimeLeft:(NSTimeInterval)timeLeft {
    if(timeLeft <=0 ){
        return;
    }
    
    NSInteger hour = ((int)timeLeft/3600)%100;
    NSInteger min = ((int)timeLeft%3600)/60;
    NSInteger sec = ((int)timeLeft%60);
    
    self.timeLimitView.hourLabel.text = [NSString stringWithFormat:@"%02ld",(long)hour];
    self.timeLimitView.minLabel.text = [NSString stringWithFormat:@"%02ld",(long)min];
    self.timeLimitView.secLabel.text = [NSString stringWithFormat:@"%02ld",(long)sec];
}

- (CGFloat)pullTop {
    CGFloat top = 0;
    top += SCREEN_WIDTH * 785 / 750;
    top += 45;
    top += 91 + 0.5;
//    DZGoodsShopCommentModel *model = self.model.shop_comment;
//    if(model.neoComment.count > 0 && ![model.commentCount isEqualToString:@"0"]) {
//        top += 117;
//    } else {
        top += 30;
//    }
    top += 8;
    top += 94 + 8;
    
    return top;
}

- (void)popMenu:(UIButton *)button {
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    //configuration.textColor = HEXCOLOR(0xfffff);
    //configuration.menuIconMargin = 12;
   // configuration.borderColor = HEXCOLOR(0x333333);
   // configuration.menuRowHeight = 35;
    configuration.tintColor = [UIColor colorWithWhite:0 alpha:0.8];
    configuration.textAlignment = NSTextAlignmentCenter;
    
    
    [FTPopOverMenu showForSender:button withMenuArray:@[@"消息",@"首页",@"分享商品", @"我要反馈"] doneBlock:^(NSInteger selectedIndex) {
        switch (selectedIndex) {
            case 0:
            {
                if(![self checkLogin]) {
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
                [self share];
                break;
            case 3:{
                if(![self checkLogin]) {
                    return;
                }
                DZFeedbackVC *vc = [DZFeedbackVC new];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    } dismissBlock:^{
        
    }];
    
}

- (void)chat {
    if(![self checkLogin]) {
        return;
    }
    
    //检查是不是自己的店
    NSString *myShopId = [DPMobileApplication sharedInstance].loginUser.shop_id;
    if ([self.model.shop_info.shop_id isEqualToString:myShopId]) {
        [SVProgressHUD showErrorWithStatus:@"不能和自己聊天"];
        return;
    }
    
    if(!self.model) {
        return;
    }
    
    if ([DPMobileApplication sharedInstance].isShowing) {
        return;
    }
    
    //[DPMobileApplication sharedInstance].isShowing = YES;
    
    if ([DPMobileApplication sharedInstance].isLogined) {

        if ([EMClient sharedClient].currentUsername) {
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/getShopEmchat" parameters:@{@"shop_id":self.model.shop_info.shop_id}];
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
                    // 传递产品信息
                    chatController.isFromProductDetail = YES;
                    chatController.commodityID = self.model.goods_info.goods_id;// self.model.goods.goods_id;
                    chatController.commodityName = self.model.goods_info.goods_name;
                    chatController.commodityPrice = self.model.goods_info.shop_price;
                    //NSString *urlString = [SPCommonUtils getThumbnailWithHost:FLEXIBLE_THUMBNAIL goodsID:Str(self.model.goods.goods_id)];
                    NSString *urlString = FULL_URL(self.model.goods_info.goods_img);
                    chatController.commodityImage = urlString;
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

- (void)share {
    if (!self.model) {
        return;
    }
    [SVProgressHUD show];
    NSDictionary *params = @{@"goods_id":self.goodsId};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/DeepLinkApi/share_goods" parameters:params];
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

- (void)setSubViewsLayout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-50);
    }];
    
//    [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.scrollView.mas_bottom);
//        make.left.bottom.right.mas_offset(0);
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
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.right.mas_offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_WIDTH * 9 / 16);
    }];
    
    [self.timeLimitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(0);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLimitView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(45);

    }];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).mas_offset(0.5);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(91);
    }];
    
    [self.specView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(44);
    }];
    
//    [self.attrView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.specView.mas_bottom);
//        make.left.right.mas_offset(0);
//        make.height.mas_equalTo(44);
//    }];
    
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopView.mas_bottom).mas_offset(8);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(117);
    }];
    
    [self.shopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.attrView.mas_bottom).mas_offset(8);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(102);
    }];
    
    [self.introView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkView.mas_bottom).mas_offset(10);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(80);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introView.mas_bottom).mas_offset(10);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(100);
        make.bottom.mas_offset(0);
    }];
}

#pragma mark - --- getters 和 setters ----
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
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
//        NSMutableArray *imageArray =[[NSMutableArray alloc] init];
//        //        for (BannerlistModel *bannerModel in [Utils getUserModel].bannerList) {
//        //            NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",base_image_url,bannerModel.img];
//        //            [imageArray addObject:imageStringUrl];
//        //        }
//        [imageArray addObject:@"http://dingzhi.host3.liuniukeji.com/Uploads/goods_desc/20170906/1504691717483422.png"];
//        [imageArray addObject:@"http://gobuy.host3.liuniukeji.com/Public/upload/goods/2017/07-12/5965cc3e57fa2.jpg"];
//        _bannerView.imageURLStringsGroup = [imageArray copy];
        _bannerView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerView.layer.masksToBounds = YES;
        _bannerView.autoScroll = YES;
        
    }
    return _bannerView;
}

- (DZGoodsDetailTitleView *)titleView {
    if(!_titleView) {
        _titleView = [DZGoodsDetailTitleView viewFormNib];
        [_titleView.favoriteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteViewClick)]];
    }
    return _titleView;
}

- (DZGoodsDetailPriceView *)priceView {
    if(!_priceView) {
        _priceView = [DZGoodsDetailPriceView viewFormNib];
    }
    return _priceView;
}

- (JSShopSpecView *)specView
{
    if (!_specView) {
        _specView = [JSShopSpecView viewFormNib];
        @weakify(self);
        _specView.block = ^{
        @strongify(self);
            [self popSepcViewWithType:@"0"];
        };
    }
    return _specView;
}

- (JSShopAttrView *)attrView
{
    if (!_attrView) {
        _attrView = [JSShopAttrView viewFormNib];
    }
    return _attrView;
}


- (void)popSepcViewWithType:(NSString *)type
{
    if (self.model.goods_attr == nil || self.model.goods_attr.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无规格不可购买加入购物车"];
        return;
    }
    ChoseGoodsTypeAlert *_alert = [[ChoseGoodsTypeAlert alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andHeight:kSize (450)];
    _alert.alpha = 0;
    if (self.ismianfeishiyong.length) {
        _alert.isdianji = NO;
    }else {
        if (self.iswodeshiyong.length) {
            _alert.isdianji = NO;
        }else {
            _alert.isdianji = YES;
        }
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_alert];
     @weakify(self);
    _alert.selectSize = ^(NSString *selectSize,NSString *num) {
        @strongify(self);
        self.buy_Count = num;
        self.sepc_key = selectSize;
        if ([type integerValue] == 0) {
            [self getDataWithSpecKey:selectSize num:num];
        }else{
            DZSubmitOrderVC *vc = [DZSubmitOrderVC new];
            vc.source = 1;
            vc.goodId = self.model.goods_info.goods_id;
            vc.from_shop_id = self.model.goods_info.shop_id;
            vc.buy_number = self.buy_Count;
            vc.goods_spec_key = self.sepc_key;
            vc.act_id = self.model.goods_info.act_id;
            vc.act_type = self.model.goods_info.act_type;
            vc.iswodeshiyong = self.iswodeshiyong;
            vc.order_sn = self.order_sn;
            vc.goods_price = self.model.goods_info.shop_price;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //sizeModel 选择的属性模型
//        [JXUIKit showSuccessWithStatus:[NSString stringWithFormat:@"选择了：%@ %@",selectSize,num]];
        
    };
    if (self.iswodeshiyong.length != 0) {
        
        [_alert initData:self.goodsModel Andtype:self.model.goods_info.shop_price];
    }else {
        [_alert initData:self.goodsModel];
    }
    [_alert showView];
}

- (void)getDataWithSpecKey:(NSString *)speckey num:(NSString *)num{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:speckey forKey:@"goods_spec_key"];
    [params setObject:num forKey:@"buy_number"];
    [params setObject:self.model.goods_info.goods_id forKey:@"goods_id"];
    [params setObject:self.model.goods_info.shop_id forKey:@"from_shop_id"];
    [params setObject:self.model.goods_info.act_id forKey:@"act_id"];
    [params setObject:@"0" forKey:@"act_type"];
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/CartApi/addCart" parameters:params method:LCRequestMethodPost];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        if ([[request.responseJSONObject objectForKey:@"status"] integerValue] == 1) {
            DZCartVC *cartVc = [[DZCartVC alloc] init];
            [self.navigationController pushViewController:cartVc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[request.responseJSONObject objectForKey:@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}



- (DZGoodsDetailRemarkView *)remarkView {
    if (!_remarkView) {
        _remarkView = [DZGoodsDetailRemarkView viewFormNib];
        @weakify(self);
        [[_remarkView.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if(!self.model ||!self.model.shop_info.shop_id) {
                return;
            }
            DZShopCommentVC *vc = [[DZShopCommentVC alloc] init];
            vc.shopId = self.goodsId;
            vc.isShangpinPingjia = @"YES";
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _remarkView;
}

- (DZGoodsDetailShopView *)shopView {
    if(!_shopView) {
        _shopView = [DZGoodsDetailShopView viewFormNib];
        
        @weakify(self);
        [[_shopView.shopButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.model) {
                DZShopDetailVC *vc = [[DZShopDetailVC alloc] init];
                vc.shopId = self.model.shop_info.shop_id;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }];
    }
    return _shopView;
}

- (DZGoodsDetailPullView *)pullView {
    if(!_pullView) {
        _pullView = [DZGoodsDetailPullView viewFormNib];
    }
    return _pullView;
}


- (DZGoodsDetailBottomV *)bottomV {
    if(!_bottomV){
        _bottomV = [DZGoodsDetailBottomV viewFormNib];
        
        @weakify(self);
        _bottomV.block = ^{
            @strongify(self);
            if ([self.model.goods_info.act_type integerValue] == 2) {
                //
                [self popSepcViewWithType:@"1"];
            }else if([self.model.goods_info.act_type integerValue] == 3){
                //立即兑换
                [self popSepcViewWithType:@"1"];
                
//                DZSubmitOrderVC *vc = [DZSubmitOrderVC new];
//                vc.source = 1;
//                vc.goodId = self.model.goods_info.goods_id;
//                vc.from_shop_id = self.model.goods_info.shop_id;
//                vc.buy_number = self.buy_Count;
//                vc.goods_spec_key = self.sepc_key;
//                vc.act_id = self.model.goods_info.act_id;
//                vc.act_type = @"3";
//                [self.navigationController pushViewController:vc animated:YES];
            }else if ([self.model.goods_info.act_type integerValue] == 5){
                [self popSepcViewWithType:@"1"];
            }else if ([self.model.goods_info.act_type integerValue] == 1){
                [self popSepcViewWithType:@"1"];
            }else {
                [self popSepcViewWithType:@"1"];
            }
        };
    }
    return _bottomV;
}

- (DZGoodsDetailBottomView *)bottomView {
    if(!_bottomView) {
        _bottomView = [DZGoodsDetailBottomView viewFormNib];
        
        @weakify(self);
        _bottomView.block = ^{
            @strongify(self);
            NSLog(@"xxxkkkk");
            [self popSepcViewWithType:@"0"];
        };
        
        [[_bottomView.catButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (!self.model) {
                return;
            }
            DZShopCateVC *vc = [[DZShopCateVC alloc] init];
            vc.shopId = self.model.shop_info.shop_id;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [[_bottomView.chatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self chat];
        }];
        
        [[_bottomView.shopButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.model) {
                DZShopDetailVC *vc = [[DZShopDetailVC alloc] init];
                vc.shopId = self.model.shop_info.shop_id;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        
        [[_bottomView.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (![self checkLogin]) {
                return;
            }
            
            [self popSepcViewWithType:@"1"];
           
            
//            DZAddCartVC *vc = [[DZAddCartVC alloc] init];
//            vc.goodsId = self.goodsId;
//            vc.model = self.model;
//            vc.isActivity = self.isActivity;
//            vc.activityPrice = self.activityPrice;
//            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        
    }
    return _bottomView;
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
            if(![self checkLogin]) {
                return;
            }
            
            DZCartVC *cartVc = [[DZCartVC alloc]init];
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

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:kGoodsDetailImageCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kGoodsDetailImageCell];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}
- (NSMutableArray *)imageArray {
    if(!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)heightArray {
    if(!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

- (DZGoodsDetailTimeLimitView *)timeLimitView {
    if (!_timeLimitView) {
        _timeLimitView = [DZGoodsDetailTimeLimitView viewFormNib];
        _timeLimitView.layer.masksToBounds = YES;
    }
    return _timeLimitView;
}

- (DZGoodsDetailIntroView *)introView {
    if (!_introView) {
        _introView = [DZGoodsDetailIntroView viewFormNib];
    }
    return _introView;
}

- (GoodsModel *)goodsModel
{
    DZGoodsDetailModel *m  = self.model;
    if (_goodsModel == nil) {
        _goodsModel = [[GoodsModel alloc]init];
        _goodsModel.imageId = self.model.goods_info.goods_img;
        _goodsModel.goodsId = self.model.goods_info.goods_id;
        _goodsModel.act_Id = self.model.goods_info.act_id;
        _goodsModel.goodsNo = @"商品名";
        _goodsModel.title = self.model.goods_info.goods_name;
        _goodsModel.totalStock = self.model.goods_info.storage;
        //价格信息
        _goodsModel.price = [[GoodsPriceModel alloc] init];
        _goodsModel.price.minPrice = self.model.goods_info.shop_price;
//        _goodsModel.price.maxPrice = @"158";
//        _goodsModel.price.minOriginalPrice = @"155";
//        _goodsModel.price.maxOriginalPrice = @"160";
        //属性-应该从服务器获取属性列表
        NSMutableArray *types = [NSMutableArray array];
        for (int i = 0; i < self.model.goods_spec.count; i++) {
            DZGoodsShopSpecModel *speModel = self.model.goods_spec[i];
             GoodsTypeModel *type = [[GoodsTypeModel alloc] init];
             [types addObject:type];
             type.selectIndex = -1;
             type.typeItems = speModel.item_array;
             type.typeName = speModel.spec_name;
             NSMutableArray *items = [NSMutableArray array];
            NSMutableArray *itemIds = [NSMutableArray array];
            
            for (GoodsItem_Array *item in speModel.item_array) {
                [items addObject:item.spec_item_name];
                [itemIds addObject:item.spec_item_id];
            }
             type.typeArray = items;
             type.typeIds = itemIds;
        }
        
        
//        GoodsTypeModel *type = [[GoodsTypeModel alloc] init];
//        type.selectIndex = -1;
//        type.typeName = @"尺码";
//        type.typeArray = @[@"XL",@"XXL"];
//
//        GoodsTypeModel *type2 = [[GoodsTypeModel alloc] init];
//        type2.selectIndex = -1;
//        type2.typeName = @"颜色";
//        type2.typeArray = @[@"黑色",@"白色",@"黑色",@"白色",@"黑色",@"白色",@"黑色"];
//
//        GoodsTypeModel *type3 = [[GoodsTypeModel alloc] init];
//        type3.selectIndex = -1;
//        type3.typeName = @"日期";
//        type3.typeArray = @[@"2016",@"2017",@"2018"];
        _goodsModel.itemsList = [types copy];
        //属性组合数组-有时候不同的属性组合价格库存都会有差异，选择完之后要对应修改商品的价格、库存图片等信息，可能是获得商品信息时将属性数组一并返回，也可能属性选择后再请求服务器获得属性组合对应的商品信息，根据自己的实际情况调整
//        _goodsModel.sizeAttribute = [[NSMutableArray alloc] init];
//        NSArray *valueArr = @[@"XL、黑色、2016",@"XXL、黑色、2016",@"XL、白色、2016",@"XXL、白色、2016",@"XL、黑色、2017",@"XXL、黑色、2017",@"XL、白色、2017",@"XXL、白色、2017",@"XL、黑色、2018",@"XXL、黑色、2018",@"XL、白色、2018",@"XXL、白色、2018"];
//        for (int i = 0; i<valueArr.count; i++) {
//            SizeAttributeModel *type = [[SizeAttributeModel alloc] init];
//            type.price = @"153";
//            type.originalPrice = @"158";
//            type.stock = [NSString stringWithFormat:@"%d",i];
//            type.goodsNo = _goodsModel.goodsNo;
//            type.value = valueArr[i];
//            type.imageId =[NSString stringWithFormat:@"%d.jpg",1];
//            [_goodsModel.sizeAttribute addObject:type];
//        }
    }
    return _goodsModel;
}

@end
