//
//  DZShopCollectionEditingVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopCollectionEditingVC.h"

#import "DZShopCollectionEditingCell.h"
#import "DZShopCollectionRightView.h"

#import "DPMobileApplication.h"
#import "DZGetFavoriteShopListModel.h"

@interface DZShopCollectionEditingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIBarButtonItem *rightEditItem;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *leftItem;

@property (nonatomic, strong) NSMutableArray *shopsArray;
@property (nonatomic, assign) NSInteger pageNum;//分页请求页码

@end

@implementation DZShopCollectionEditingVC

static  NSString  *CellIdentiferId = @"DZShopCollectionEditingCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏的店铺";
    self.navigationItem.rightBarButtonItem = self.rightEditItem;
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
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
    NSMutableArray *idsArray = [NSMutableArray new];
    for (DZShoopsCollectionModel *model in self.shopsArray) {
        if (model.selected) {
            [idsArray addObject:model.fav_id];
        }
    }
    
    if (!idsArray.count) {
        [SVProgressHUD showErrorWithStatus:@"您没有选择任何店铺"];
        return;
    }
    NSString *ids = [idsArray componentsJoinedByString:@","];
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/cancelShopFavorite" parameters:@{@"ids":ids}];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.tableView.mj_header beginRefreshing];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteShops)]) {
                [self.delegate didDeleteShops];
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

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    DZShoopsCollectionModel *model = self.shopsArray[indexPath.row];
    model.selected = !model.selected;
    
    [tableView reloadData];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZShopCollectionEditingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZShopCollectionEditingCell" owner:nil options:nil] lastObject];
    }
    
    DZShoopsCollectionModel *model = self.shopsArray[indexPath.row];
    [cell fillData:model.shop_info];
    if (model.selected) {
        [cell setEditingState:1];
    }else{
        [cell setEditingState:0];
    }
    
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
        _rightEditItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(editItemAction)];
        [_rightEditItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightEditItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
        _rightEditItem.tintColor = HEXCOLOR(0xff7722);
    }
    return _rightEditItem;
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
