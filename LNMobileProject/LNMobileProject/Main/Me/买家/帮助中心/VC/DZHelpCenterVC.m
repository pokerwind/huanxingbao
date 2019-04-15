//
//  DZHelpCenterVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZHelpCenterVC.h"
#import "DZHelpDetailVC.h"

#import "DZGetArticleListModel.h"

#import "DZMyBalanceHelpCell.h"

@interface DZHelpCenterVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation DZHelpCenterVC

static  NSString  *CellIdentiferId = @"DZMyBalanceHelpCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助中心";
    if (self.isNotice) {
        self.title = @"系统通知";
    }
    
    [self.view addSubview:self.tableView];
    
    [self setSubViewsLayout];
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - --- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DZArticleListModel *model = self.dataArray[indexPath.row];
    DZHelpDetailVC *vc = [DZHelpDetailVC new];
    vc.article_id = model.article_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - --- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZMyBalanceHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZMyBalanceHelpCell" owner:nil options:nil] lastObject];
    }
    DZArticleListModel *model = self.dataArray[indexPath.row];
    [cell fillData:model];
    
    return cell;
}

- (void)getData{
    NSDictionary *params;
    if ([DPMobileApplication sharedInstance].isSellerMode) {
        params = @{@"article_category_id":@"7"};
    }else{
        params = @{@"article_category_id":@"6"};
    }
    
    if (self.isNotice) {
        params = @{@"article_category_id":@"8"};
    }
    
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/ArticleApi/article" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetArticleListModel *model = [DZGetArticleListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.dataArray = model.data;
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
