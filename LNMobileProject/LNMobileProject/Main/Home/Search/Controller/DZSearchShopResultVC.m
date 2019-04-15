//
//  DZSearchShopResult.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSearchShopResultVC.h"
#import "DZSearchShopCell.h"
#import "DZShopDetailVC.h"
#import "DZSearchShopResultNavView.h"
#import "DZShopModel.h"
#import "DZMessageVC.h"
#import "JSMessageListViewController.h"

#define kSearchShopCell @"DZSearchShopCell"
@interface DZSearchShopResultVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) DZSearchShopResultNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@end

@implementation DZSearchShopResultVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.navView];
    [self.view addSubview:self.tableView];
    
    self.page = 1;
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

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //点击了搜索，改变关键字，在搜索一下。
    self.page = 1;
    self.keyword = textField.text;
    [self loadData];
    [self.view endEditing:YES];
    return YES;
}

#pragma mark UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZSearchShopCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchShopCell];
    id model = self.dataArray[indexPath.row];
    [cell configView:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DZShopDetailVC *vc = [[DZShopDetailVC alloc] init];
    DZShopModel *model = self.dataArray[indexPath.row];
    vc.shopId = model.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----
- (void)loadData {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/seachShopName" parameters:@{@"keyword":self.keyword,@"p":@(self.page)} method:LCRequestMethodPost];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZShopNetModel *model = [DZShopNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.dataArray addObjectsFromArray:model.data.list];
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.mas_equalTo(KNavigationBarH);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.bottom.left.right.mas_offset(0);
    }];
}

#pragma mark - --- getters 和 setters ----

- (DZSearchShopResultNavView *)navView {
    if(!_navView) {
        _navView = [DZSearchShopResultNavView viewFormNib];
        @weakify(self);
        [[_navView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [[_navView.messageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            JSMessageListViewController *vc = [JSMessageListViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        _navView.searchField.text = self.keyword;
        _navView.searchField.delegate = self;
    }
    return _navView;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:kSearchShopCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kSearchShopCell];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page++;
            [self loadData];
        }];
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
