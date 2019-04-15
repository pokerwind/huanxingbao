//
//  DZShopCollectionVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopCollectionVC.h"
#import "DZShopCollectionEditingVC.h"
#import "DZShopDetailVC.h"

#import "DZShopCollectionCell.h"
#import "DZShopCollectionRightView.h"

#import "DPMobileApplication.h"
#import "DZGetFavoriteShopListModel.h"

@interface DZShopCollectionVC ()<UITableViewDelegate, UITableViewDataSource, DZShopCollectionEditingVCDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightEditItem;
@property (nonatomic, strong) UIBarButtonItem *rightMessageItem;
@property (nonatomic, strong) DZShopCollectionRightView *rightView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *shopsArray;
@property (nonatomic, assign) NSInteger pageNum;//分页请求页码

@end

@implementation DZShopCollectionVC

static  NSString  *CellIdentiferId = @"DZMyOrderCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏的店铺";
//    self.navigationItem.rightBarButtonItems = @[self.rightMessageItem, self.rightEditItem];
    self.navigationItem.rightBarButtonItem = self.rightEditItem;
    
    [self.view addSubview:self.tableView];
    
    [self setSubViewsLayout];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)editItemAction{
    DZShopCollectionEditingVC *vc = [DZShopCollectionEditingVC new];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

- (void)messageItemAction{
    self.rightView.countLabel.hidden = !self.rightView.countLabel.hidden;
}
#pragma mark - ---- DZShopCollectionEditingVCDelegate ----
- (void)didDeleteShops{
    [self getNewData];
}

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    DZShoopsCollectionModel *model = self.shopsArray[indexPath.row];
    DZShopDetailVC *vc = [DZShopDetailVC new];
    vc.shopId = model.shop_info[@"shop_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZShopCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZShopCollectionCell" owner:nil options:nil] lastObject];
    }
    
    DZShoopsCollectionModel *model = self.shopsArray[indexPath.row];
    [cell fillData:model.shop_info];
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)getNewData{
    self.pageNum = 1;
    NSDictionary *params = @{@"p":@(1)};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getFavoriteShopList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        DZGetFavoriteShopListModel *model = [DZGetFavoriteShopListModel objectWithKeyValues:request.responseJSONObject];
        
        if (model.isSuccess) {
            self.shopsArray = [NSMutableArray arrayWithArray:model.data];
            
            if (!self.shopsArray.count) {
                self.navigationItem.rightBarButtonItem = nil;
            }else{
                self.navigationItem.rightBarButtonItem = self.rightEditItem;
            }
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info?:@"网络不给力"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)getMoreData{
    self.pageNum++;
    NSDictionary *params = @{@"p":@(self.pageNum)};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getFavoriteShopList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_footer endRefreshing];
        DZGetFavoriteShopListModel *model = [DZGetFavoriteShopListModel objectWithKeyValues:request.responseJSONObject];
        
        if (model.isSuccess) {
            [self.shopsArray addObjectsFromArray:model.data];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info?:@"网络不给力"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightEditItem{
    if (!_rightEditItem) {
        _rightEditItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editItemAction)];
        [_rightEditItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightEditItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
        _rightEditItem.tintColor = DefaultTextBlackColor;
    }
    return _rightEditItem;
}

- (UIBarButtonItem *)rightMessageItem{
    if (!_rightMessageItem) {
        _rightMessageItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightView];
    }
    return _rightMessageItem;
}

- (DZShopCollectionRightView *)rightView{
    if (!_rightView) {
        _rightView = [[[NSBundle mainBundle] loadNibNamed:@"DZShopCollectionRightView" owner:self options:nil] firstObject];
        _rightView.countLabel.layer.cornerRadius = 6.5;
        _rightView.countLabel.layer.masksToBounds = YES;
        [_rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageItemAction)]];
    }
    return _rightView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getNewData];
        }];
        _tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            [self getMoreData];
        }];
        
    }
    return _tableView;
}

- (NSMutableArray *)shopsArray{
    if (!_shopsArray) {
        _shopsArray = [NSMutableArray array];
    }
    return _shopsArray;
}

@end
