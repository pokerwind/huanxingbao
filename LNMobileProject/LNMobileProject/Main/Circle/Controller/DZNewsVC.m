//
//  DZNewsVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/8.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZNewsVC.h"
#import "DZNewsModel.h"
#import "DZNewsCell.h"
#import "DZReleaseButtonView.h"
#import "DZNewsModel.h"

#define kNewsCell @"DZNewsCell"

@interface DZNewsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DZReleaseButtonView *releaseView;
@property (nonatomic, assign) NSInteger page;
@end

@implementation DZNewsVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.releaseSubject = [RACSubject subject];
        self.clickSubject = [RACSubject subject];
    }
    return self;
}

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    if([DPMobileApplication sharedInstance].isSellerMode) {
        [self.view addSubview:self.releaseView];
    }
    self.page = 1;
    [self loadData];
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self setSubViewsFrame];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark - ---- 代理相关 ----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsCell];
    DZNewsModel *model = self.dataArray[indexPath.row];
    [cell configView:model];
    cell.clickSubject = self.clickSubject;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZNewsModel *model = self.dataArray[indexPath.row];
    CGFloat base = 90 + 39;
    NSString *content = model.content;
    if (model.content.length >= kNeedHideNum) {
        base += 22;
        if (!model.isShowAll) {
            content = [content substringToIndex:kNeedHideNum];
            content = content.a(@"…");
        }
    }
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 16, MAXFLOAT)];
    CGFloat height = size.height;
    if (height > 17) {
        base += (height - 17);
    }
    
    CGFloat cellHeight = floor((SCREEN_WIDTH - 16 - 6)/3);
    NSInteger num = (model.goods_list.count + 2)/3;
    
    if (num > 0) {
        base += cellHeight * num + (num - 1)*3;
    }
    
    base += 2;
    
    return base;
}

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 公有方法 ----
- (void)updateFollow:(NSString *)shopId status:(NSString *)isFollow {
    for (DZNewsModel *news in self.dataArray) {
        if ([news.shop_id isEqualToString:shopId]) {
            news.favorite_shop = isFollow;
        }
    }
    [self.tableView reloadData];
}

- (void)reload {
    self.page = 1;
    [self loadData];
}

- (void)refresh {
    [self.tableView reloadData];
}

#pragma mark - ---- 私有方法 ----
- (void)loadData {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexApi/getCircleList" parameters:@{@"p":@(self.page)}];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZNewsNetModel *model = [DZNewsNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            if(self.page == 1) {
                [self.dataArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.dataArray addObjectsFromArray:model.data];
            [self.tableView reloadData];
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    
    if([DPMobileApplication sharedInstance].isSellerMode) {
        
        [self.releaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.bottom.mas_offset(-30);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
    }
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:kNewsCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kNewsCell];
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page ++;
            [self loadData];
        }];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BgColor;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (DZReleaseButtonView *)releaseView {
    if(!_releaseView) {
        _releaseView = [DZReleaseButtonView viewFormNib];
        [[_releaseView.releaseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            //发布动态页面
            [self.releaseSubject sendNext:nil];
        }];
    }
    return _releaseView;
}
@end
