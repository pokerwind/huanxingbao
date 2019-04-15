//
//  DZGoodsCollectionVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodsCollectionVC.h"
#import "DZGoodsCollectionEditingVC.h"
#import "DZGoodsDetailVC.h"

#import "GetFavoriteGoodsListApi.h"
#import "DZFavoriteGoodsListModel.h"
#import <MJExtension.h>

#import "DZHomeGoodsListCell.h"

#define kHomeGoodsListCell @"DZHomeGoodsListCell"

@interface DZGoodsCollectionVC ()<UICollectionViewDelegate,UICollectionViewDataSource, DZGoodsCollectionEditingVCDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) GetFavoriteGoodsListApi *api;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, assign) NSInteger pageNum;//分页请求页码

@end

@implementation DZGoodsCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏的商品";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
    
    [self setSubViewsLayout];
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZGoodsCollectionEditingVCDelegate ----
- (void)didDeleteGoods{
    [self getNewData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZHomeGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeGoodsListCell forIndexPath:indexPath];
    
    DZGoodsCollectionModel *model = self.goodsArray[indexPath.item];
    [cell fillPic:model.goods_img title:model.goods_name pack_price:model.pack_price shop_price:model.shop_price];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DZGoodsCollectionModel *model = self.goodsArray[indexPath.item];
    DZGoodsDetailVC *vc = [DZGoodsDetailVC new];
    vc.goodsId = [NSString stringWithFormat:@"%ld", model.goods_id];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- 私有方法 ----
- (void)getNewData{
    self.pageNum = 1;
    [self.api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        
        DZFavoriteGoodsListModel *base = [DZFavoriteGoodsListModel objectWithKeyValues:request.responseJSONObject];
        [self.collectionView.mj_header endRefreshing];
        
        if (base.isSuccess) {
            self.goodsArray = [NSMutableArray arrayWithArray:base.data];
            
            if (!self.goodsArray.count) {
                self.navigationItem.rightBarButtonItem = nil;
            }else{
                self.navigationItem.rightBarButtonItem = self.rightItem;
            }
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:base.info?:@"网络不给力"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)getMoreData{
    self.pageNum++;
    [self.api setPage:self.pageNum];
    [self.api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZFavoriteGoodsListModel *base = [DZFavoriteGoodsListModel objectWithKeyValues:request.responseJSONObject];
        [self.collectionView.mj_footer endRefreshing];
        
        if (base.isSuccess) {
            [self.goodsArray addObjectsFromArray:base.data];
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:base.info?:@"网络不给力"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 布局代码 ----

- (void) setSubViewsLayout{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)rightItemAction{
    DZGoodsCollectionEditingVC *vc = [DZGoodsCollectionEditingVC new];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction)];
        _rightItem.tintColor = HEXCOLOR(0x333333);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}

#pragma mark - --- getters 和 setters ----
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
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = TextWhiteColor;
        collectionView.pagingEnabled = NO;
        collectionView.directionalLockEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.emptyDataSetSource = self;
        collectionView.emptyDataSetDelegate = self;
        //注册cell
        [collectionView registerNib:[UINib nibWithNibName:kHomeGoodsListCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kHomeGoodsListCell];
        
        _collectionView = collectionView;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getNewData];
        }];
        _collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [self getMoreData];
        }];
    }
    return _collectionView;
    
}

- (GetFavoriteGoodsListApi *)api{
    if (!_api) {
        _api = [[GetFavoriteGoodsListApi alloc] initWithPage:1];
    }
    return _api;
}

- (NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

@end
