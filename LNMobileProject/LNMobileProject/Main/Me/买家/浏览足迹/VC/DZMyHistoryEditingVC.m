//
//  DZMyHistoryEditingVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/18.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMyHistoryEditingVC.h"

#import "DZHomeGoodsListCell.h"
#import "DZHistoryGroupHeader.h"

#import "DPMobileApplication.h"
#import "DZGetBrowseListModel.h"

#define kHomeGoodsListCell @"DZHomeGoodsListCell"
#define HeaderIdentifier @"HeaderIdentifier"

@interface DZMyHistoryEditingVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIBarButtonItem *leftItem;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *groupsArray;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation DZMyHistoryEditingVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的足迹";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.collectionView];
    
    [self setSubViewsLayout];
    
    [self.collectionView.mj_header beginRefreshing];
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
    for (DZBrowseListGroupModel *model in self.groupsArray) {
        for (DZBrowseListItemModel *models in model.goods_list) {
            if (models.selected) {
                [idsArray addObject:[NSString stringWithFormat:@"%@", models.goods_id]];
            }
        }
    }
    
    if (!idsArray.count) {
        [SVProgressHUD showErrorWithStatus:@"您没有选择任何记录"];
        return;
    }
    NSString *ids = [idsArray componentsJoinedByString:@","];
    NSDictionary *params = @{@"goods_id":ids};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/delUserBrowse" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            [self getNewData];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteHistory)]) {
                [self.delegate didDeleteHistory];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)leftItemAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ---- 代理相关 ----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.groupsArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    DZBrowseListGroupModel *model = self.groupsArray[section];
    return model.goods_list.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZHomeGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeGoodsListCell forIndexPath:indexPath];
    
    DZBrowseListGroupModel *groupModel = self.groupsArray[indexPath.section];
    DZBrowseListItemModel *itemModel = groupModel.goods_list[indexPath.item];
    
    [cell fillPic:itemModel.goods_img title:itemModel.goods_name pack_price:itemModel.pack_price shop_price:itemModel.shop_price];
    if (itemModel.selected) {
        [cell setEditingState:1];
    }else{
        [cell setEditingState:-1];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DZBrowseListGroupModel *groupModel = self.groupsArray[indexPath.section];
    DZBrowseListItemModel *itemModel = groupModel.goods_list[indexPath.item];
    itemModel.selected = !itemModel.selected;
    [self.collectionView reloadData];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        DZHistoryGroupHeader *headerView = (DZHistoryGroupHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        
        DZBrowseListGroupModel *model = self.groupsArray[indexPath.section];
        headerView.dateLabel.text = model.date;
        
        reusableView = headerView;
    }
    return reusableView;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {SCREEN_WIDTH,30};
    return size;
}

#pragma mark - ---- 私有方法 ----
- (void)getNewData{
    self.pageNum = 1;
    NSDictionary *params = @{@"p":@(1)};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getBrowseList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.collectionView.mj_header endRefreshing];
        DZGetBrowseListModel *model = [DZGetBrowseListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.groupsArray = [NSMutableArray arrayWithArray:model.data];
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info?:@"网络不给力"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)getMoreData{
    self.pageNum++;
    NSDictionary *params = @{@"p":@(self.pageNum)};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getBrowseList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.collectionView.mj_footer endRefreshing];
        DZGetBrowseListModel *model = [DZGetBrowseListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.groupsArray addObjectsFromArray:model.data];
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info?:@"网络不给力"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
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
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = NO;
        collectionView.directionalLockEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        //注册cell
        [collectionView registerNib:[UINib nibWithNibName:kHomeGoodsListCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kHomeGoodsListCell];
        [collectionView registerClass:[DZHistoryGroupHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
        
        _collectionView = collectionView;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getNewData];
        }];
        _collectionView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            [self getMoreData];
        }];
    }
    return _collectionView;
    
}

- (NSMutableArray *)groupsArray{
    if (!_groupsArray) {
        _groupsArray = [NSMutableArray array];
    }
    return _groupsArray;
}

@end
