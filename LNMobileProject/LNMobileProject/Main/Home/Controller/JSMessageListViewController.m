//
//  JSMessageListViewController.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/29.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "JSMessageListViewController.h"
#import "JSMessageTableViewCell.h"
#import "JSMessageListModel.h"
#import "DZMessageDetailViewController.h"
@interface JSMessageListViewController ()<UITableViewDataSource,UITableViewDelegate>
/*
 * tableView
 */
@property (nonatomic,strong)UITableView *tableView;

/*
 * page
 */
@property (nonatomic,assign)NSInteger page;

/*
 * items
 */
@property (nonatomic,strong)NSMutableArray *items;

@end

@implementation JSMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    self.page = 1;
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
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
        
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self getData];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page++;
            [self getData];
        }];
        
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
    return self.items.count;
}
//设置标识
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSMessageTableViewCell *cell =  [JSMessageTableViewCell cellWithTableView:tableView];
    
    cell.list = self.items[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     JSMessageListData *list = self.items[indexPath.row];
    //取消选中一行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DZMessageDetailViewController *detailVc = [[DZMessageDetailViewController alloc]init];
    detailVc.list = list;
    [self.navigationController pushViewController:detailVc animated:YES];
    
    
}
//每行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}


- (void)getData{
    //34.9967410000,118.2847860000
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.page) forKey:@"p"];
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/IndexUserApi/getMessageList" parameters:params method:LCRequestMethodPost];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        JSMessageListModel *model = [JSMessageListModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
        if (self.page == 1) {
            [self.items removeAllObjects];
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.items addObjectsFromArray:model.data];
        [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 代理相关 ----
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"me_null"];
}

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *title = @"狮子王";
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
//                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
//                                 };
//    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
//}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"没有数据";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
@end
