//
//  DZShopGoodsListVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopGoodsListVC.h"
#import "YZPullDownMenu.h"
#import "PullListTableVC.h"
#import "DZGoodsDetailVC.h"
#import "DZGoodsModel.h"
#import "DZHomeGoodsListCell.h"
#import "HMSegmentedControl.h"

#define kHomeGoodsListCell @"DZHomeGoodsListCell"

@interface DZShopGoodsListVC ()<YZPullDownMenuDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) NSArray *menuTitle;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *sort;
@end

@implementation DZShopGoodsListVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuTitle = @[@"新品",@"价格升序"];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.collectionView];
    
    self.page = 1;
    self.sort = @"add_time";
    [self loadData];
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
#pragma mark - 下拉菜单代理
- (NSInteger)numberOfColsInMenu:(YZPullDownMenu *)pullDownMenu
{
    return self.menuTitle.count;
}
// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(YZPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    NSString *buttonTitle = self.menuTitle[index];
    UIButton *button = [[UIButton alloc] init];
    //button.backgroundColor = AfterColor;
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:TextLightColor forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(YZPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index
{
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(YZPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    // 第1列 高度
    int i = 2;
    return 44 * i;
}

#pragma mark UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZHomeGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeGoodsListCell forIndexPath:indexPath];
    DZGoodsModel *model = self.dataArray[indexPath.row];
    
    [cell fillPic:model.goods_img title:model.goods_name pack_price:model.pack_price shop_price:model.shop_price];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //[self.clickSubject sendNext:nil];
    DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
    DZGoodsModel *model = self.dataArray[indexPath.row];
    vc.goodsId = model.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----
- (void)loadData {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/getShopGoodsList" parameters:@{@"shop_id":self.shopId,@"cat_id":self.catId,@"p":@(self.page),@"sort":self.sort} method:LCRequestMethodPost];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGoodsNetModel *model = [DZGoodsNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            if(self.page == 1) {
                [self.dataArray removeAllObjects];
                [self.collectionView.mj_header endRefreshing];
            } else {
                [self.collectionView.mj_footer endRefreshing];
            }
            [self.dataArray addObjectsFromArray:model.data];
            [self.collectionView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
            
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}
#pragma mark - 添加子控制器
- (void)setupPullDownMenuChildVC
{
    for(UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    
    PullListTableVC *allCourse2 = [[PullListTableVC alloc] init];
    allCourse2.dataSoure = @[@{@"name":@"新品",@"short":@"新品",@"type":@"store_count"},
                             @{@"name":@"收藏量",@"short":@"收藏量",@"type":@"store_count"}];
    [self addChildViewController:allCourse2];
    
    //排序
    PullListTableVC *allCourse = [[PullListTableVC alloc] init];
    allCourse.dataSoure = @[
                            @{@"name":@"价格升序",@"short":@"价格升序",@"type":@"store_count"},
                            @{@"name":@"价格降序",@"short":@"价格降序",@"type":@"store_count"},
                            ];
    [self addChildViewController:allCourse];
    
}
#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
}

#pragma mark - --- getters 和 setters ----

- (HMSegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl=[[HMSegmentedControl alloc] initWithSectionTitles:@[@"新品",@"收藏量",@"价格升序",@"价格升序"]];
        
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectionIndicatorColor=OrangeColor;
        _segmentedControl.selectionIndicatorHeight=0;
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
            if(index == 0) {
                self.sort = @"add_time";
            } else if (index == 1) {
                self.sort = @"collect";
            } else if (index == 2) {
                self.sort = @"price_asc";
            } else if (index == 3) {
                self.sort = @"price_desc";
            }
            self.page = 1;
            [self loadData];
        };
    }
    return _segmentedControl;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH - 15)/2;
        CGFloat picHeight = width*400/350;
        CGFloat height = picHeight + 71;
        layout.itemSize = CGSizeMake(width, height);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 9;
        layout.sectionInset = UIEdgeInsetsMake(5, 3, 5, 3);
        //layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        //collectionView.backgroundColor = TextWhiteColor;
        collectionView.pagingEnabled = NO;
        collectionView.directionalLockEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        //注册cell
        [collectionView registerNib:[UINib nibWithNibName:kHomeGoodsListCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kHomeGoodsListCell];
        collectionView.backgroundColor = BgColor;
        _collectionView = collectionView;
        @weakify(self);
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData];
        }];
        
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page ++;
            [self loadData];
        }];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray  {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
