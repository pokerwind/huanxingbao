//
//  LNTableViewController.m
//  LNFrameWork
//
//  Created by LiuYanQi on 2017/7/22.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import "LNTableViewController.h"
#import "EmptyDataSource.h"
#import "Masonry.h"
@interface LNTableViewController () 

@property (strong, nonatomic) EmptyDataSource *emptyDataSource;

@end

@implementation LNTableViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super init];
    if (self) {
        self.tableViewStyle = style;
        self.dataController = [[LNTableDataController alloc] init];
        self.dataController.viewController = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.isNeedPullUpToRefreshAction = YES;
    self.isNeedPullDownToRefreshAction = YES;
    self.isNeedTableBlankView = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataController.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - 开启 上拉加载和下拉刷新
- (void)setIsNeedPullDownToRefreshAction:(BOOL)isEnable {
    if (_isNeedPullDownToRefreshAction == isEnable) {
        return;
    }
    _isNeedPullDownToRefreshAction = isEnable;
    
    if (_isNeedPullDownToRefreshAction) {
        __block typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.dataController refreshData];
        }];
        
    } else {
        self.tableView.mj_header = nil;
    }
}

- (void)setIsNeedPullUpToRefreshAction:(BOOL)isEnable
{
    if (_isNeedPullUpToRefreshAction == isEnable) {
        return;
    }
    _isNeedPullUpToRefreshAction = isEnable;
    
    if (_isNeedPullUpToRefreshAction) {
        __block typeof(self) weakSelf = self;
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.dataController loadMoreData];
        }];
    } else {
        self.tableView.mj_footer = nil;
    }
}
#pragma mark - 上拉加载和下拉刷新 完成
- (void)tableViewDataController:(LNTableDataController *)dataController didRefreshDataWithResult:(id)result error:(NSError *)error{
    if ([result isKindOfClass:[NSArray class]] ) {
        dataController.tableArray = result;
    } else {
        NSAssert(NO, @"传入的 result 不是 NSArray，请重写该方法");
    }
    [self checkEmptyViewStatus];
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
}
- (void)tableViewDataController:(LNTableDataController *)dataController didLoadMoreDataWithResult:(id)result error:(NSError *)error{
    if ([result isKindOfClass:[NSArray class]] ) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:dataController.tableArray];
        [array addObjectsFromArray:result];
        dataController.tableArray = array;
    } else {
        NSAssert(NO, @"传入的 result 不是 NSArray，请重写该方法");
    }
    
    [self checkEmptyViewStatus];
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - 空视图 相关

- (void)setIsNeedTableBlankView:(BOOL)isEnable{
    if (_isNeedTableBlankView == isEnable) {
        return;
    }
    _isNeedTableBlankView = isEnable;
    
    if (_isNeedTableBlankView) {
        self.tableView.emptyDataSetSource = self.emptyDataSource;
        self.tableView.emptyDataType = EmptyDataTypeLoading;
        [self.tableView reloadEmptyDataSet];
    } else {
        [self.tableView removeEmptyDataSet];
    }
}

- (void)checkEmptyViewStatus{

    if (self.dataController.tableArray.count == 0) {
        // 设置空视图
        self.tableView.emptyDataType = EmptyDataTypeList;
        [self.tableView reloadEmptyDataSet];
    } else {
        // 移除空试图
        [self.tableView removeEmptyDataSet];
    }
    
    [self.tableView reloadData];
}

- (EmptyDataSource *)emptyDataSource{
    if (!_emptyDataSource) {
        _emptyDataSource = [[EmptyDataSource alloc] init];
    }
    return _emptyDataSource;
}

@end
