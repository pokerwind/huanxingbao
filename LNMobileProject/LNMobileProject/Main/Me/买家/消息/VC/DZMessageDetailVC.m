//
//  DZMessageDetailVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/10.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMessageDetailVC.h"
#import "DZGetArticleListModel.h"
#import "DZNoticeDetailVC.h"
#import "DZSystemNoticeCell.h"

#define kNoticeCell @"DZSystemNoticeCell"
@interface DZMessageDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation DZMessageDetailVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
        self.title = @"系统通知";
    
    [self.view addSubview:self.tableView];
    [self getData];
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSubViewsFrame];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - --- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DZNoticeDetailVC *model = self.dataArray[indexPath.row];
    DZNoticeDetailVC *vc = [DZNoticeDetailVC new];
    vc.article_id = model.article_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - --- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZSystemNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoticeCell];

    DZArticleListModel *model = self.dataArray[indexPath.row];
    //[cell fillData:model];
    cell.timeLabel.text = model.addtime;
    cell.titleLabel.text = model.title;
    cell.contentLabel.text = model.introduce;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat base = 80;
    DZArticleListModel *model = self.dataArray[indexPath.row];
    
    CGSize size = [model.title sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 16, MAXFLOAT)];
    CGFloat height = size.height;
    if (height > 16) {
        base += (height - 16);
    }
    size = [model.introduce sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 16, MAXFLOAT)];
    height = size.height;
    if (height > 16) {
        base += (height - 16);
    }
    base +=4;
    return base;
}

#pragma mark - ---- 事件响应 ----

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params;
//    if ([DPMobileApplication sharedInstance].isSellerMode) {
//        params = @{@"article_cat_id":@"7"};
//    }else{
//        params = @{@"article_cat_id":@"6"};
//    }
    params = @{@"article_cat_id":@"8"};
    
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ArticleApi/articleList" parameters:params];
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
#pragma mark - ---- 公有方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
- (void) setSubViewsFrame{
    
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
        [_tableView registerNib:[UINib nibWithNibName:kNoticeCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kNoticeCell];
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
