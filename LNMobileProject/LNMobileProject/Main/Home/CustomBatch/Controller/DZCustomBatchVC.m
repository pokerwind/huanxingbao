//
//  DZCustomBatchVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/28.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCustomBatchVC.h"
#import "DZCustomBatchCell.h"
#import "DZGoodsModel.h"
#import "DZGoodsDetailVC.h"

#define kCustomBatchCell @"DZCustomBatchCell"

@interface DZCustomBatchVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) RACSubject *clickSubject;
@property (nonatomic, assign) NSInteger page;
@end

@implementation DZCustomBatchVC


#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    
    self.navigationItem.title = @"定制批发";
    [self.tableView registerNib:[UINib nibWithNibName:kCustomBatchCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCustomBatchCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    @weakify(self);
    self.tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self loadData];
    }];
    
    self.tableView.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.page ++;
        [self loadData];
    }];
    
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

- (void)initNavigationBar {
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setImage:[UIImage imageNamed:@"nav_icon_share"] forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;
    
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"share");
    }];
}

#pragma mark - ---- 代理相关 ----
#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZCustomBatchCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomBatchCell];
    cell.clickSubject = self.clickSubject;
    id model = self.dataArray[indexPath.row];
    [cell configView:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132;
}
#pragma mark - ---- Action Events 和 response手势 ----
- (void)shareAction:(id)sender {
    
}

#pragma mark - ---- 私有方法 ----
- (void)loadData {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsApi/isMadeGoodsList" parameters:@{@"is_made":@"1",@"p":@(self.page)}];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGoodsNetModel *model = [DZGoodsNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.dataArray addObjectsFromArray:model.data];
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

}

#pragma mark - --- getters 和 setters ----
- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (RACSubject *)clickSubject {
    if(!_clickSubject) {
        _clickSubject = [RACSubject subject];
        @weakify(self);
        [_clickSubject subscribeNext:^(NSString *goodsId) {
            @strongify(self);
            DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
            vc.goodsId = goodsId;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _clickSubject;
}

@end
