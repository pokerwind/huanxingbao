//
//  DZMessageDetailViewController.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/30.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZMessageDetailViewController.h"
#import "DZMessageDetaiTableViewCell.h"
#import "DZCGSize.h"
@interface DZMessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
/*
 * tableView
 */
@property (nonatomic,strong)UITableView *tableView;


/*
 * items
 */
@property (nonatomic,strong)NSMutableArray *items;
@end

@implementation DZMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息详情";
    [self.view addSubview:self.tableView];
    [self postUnreadRequest];
}

#pragma mark -- 懒加载 --
- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-KNavigationBarH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        //修复下拉刷新错位
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

#pragma mark -- tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//设置标识
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZMessageDetaiTableViewCell *cell = [DZMessageDetaiTableViewCell cellWithTableView:tableView];
    cell.list = self.list;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
//每行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DZCGSize sizeWithText:self.list.content andFont:[UIFont systemFontOfSize:14] andMaxW:KScreenWidth - 30].height + 40;
}

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)postUnreadRequest{
    //34.9967410000,118.2847860000
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.list.id forKey:@"message_id"];
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexUserApi/messageDetail" parameters:params method:LCRequestMethodPost];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        JSMessageListModel *model = [JSMessageListModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
        }else{
//            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}


@end
