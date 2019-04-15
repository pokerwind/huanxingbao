//
//  DZGoodsCollectionEditingVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodsCollectionEditingVC.h"

#import "DZHomeGoodsListCell.h"

#import "GetFavoriteGoodsListApi.h"
#import "CancelGoodsFavoriteApi.h"
#import "DZFavoriteGoodsListModel.h"
#import <MJExtension.h>


#define kHomeGoodsListCell @"DZHomeGoodsListCell"

@interface DZGoodsCollectionEditingVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIBarButtonItem *leftItem;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) GetFavoriteGoodsListApi *api;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, assign) NSInteger pageNum;//分页请求页码

@end

@implementation DZGoodsCollectionEditingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏的商品";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.collectionView];
    
    [self setSubViewsLayout];
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - ---- 代理相关 ----

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZHomeGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeGoodsListCell forIndexPath:indexPath];
    
    DZGoodsCollectionModel *model = self.goodsArray[indexPath.item];
    [cell fillPic:model.goods_img title:model.goods_name pack_price:model.pack_price shop_price:model.shop_price];
    if (model.selected) {
        [cell setEditingState:1];
    }else{
        [cell setEditingState:-1];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DZGoodsCollectionModel *model = self.goodsArray[indexPath.item];
    model.selected = !model.selected;
    
    [self.collectionView reloadData];
}

#pragma mark - ---- 私有方法 ----
- (void)getNewData{
    self.pageNum = 1;
    [self.api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZFavoriteGoodsListModel *base = [DZFavoriteGoodsListModel objectWithKeyValues:request.responseJSONObject];
        [self.collectionView.mj_header endRefreshing];
        
        if (base.isSuccess) {
            self.goodsArray = [NSMutableArray arrayWithArray:base.data];
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
        DZFavoriteGoodsListModel *model = [DZFavoriteGoodsListModel objectWithKeyValues:request.responseJSONObject];
        [self.collectionView.mj_footer endRefreshing];
        
        if (model.isSuccess) {
            NSLog(@"data: %@", model.data);
            
            NSArray *array = [DZGoodsCollectionModel objectArrayWithKeyValuesArray:model.data];
            [self.goodsArray addObjectsFromArray:array];
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info?:@"网络不给力"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        
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
    NSMutableArray *idsArray = [NSMutableArray new];
    for (DZGoodsCollectionModel *model in self.goodsArray) {
        if (model.selected) {
            [idsArray addObject:[NSString stringWithFormat:@"%ld", model.favorite_id]];
        }
    }
    
    if (!idsArray.count) {
        [SVProgressHUD showErrorWithStatus:@"您没有选择任何商品"];
        return;
    }
    NSString *ids = [idsArray componentsJoinedByString:@","];
    CancelGoodsFavoriteApi *api = [[CancelGoodsFavoriteApi alloc] initWithIds:ids];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = request.responseJSONObject;
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.collectionView.mj_header beginRefreshing];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteGoods)]) {
                [self.delegate didDeleteGoods];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:model.msg];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)leftItemAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        _rightItem.tintColor = HEXCOLOR(0xff7722);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}

- (UIBarButtonItem *)leftItem{
    if (!_leftItem) {
        _leftItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
        _leftItem.tintColor = HEXCOLOR(0xff7722);
    }
    return _leftItem;
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
