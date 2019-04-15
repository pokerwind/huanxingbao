//
//  DZJfdhViewController.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/24.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZJfdhViewController.h"
#import "DZJfdhTableViewCell.h"
#import "DZJfdhHead.h"
#import "JSScoreModel.h"
#import "DZGoodsDetailVC.h"
@interface DZJfdhViewController ()<UITableViewDelegate,UITableViewDataSource>

/*
 * DZJfdhHead
 */
@property (nonatomic,strong)DZJfdhHead *headView;

/*
 * items
 */
@property (nonatomic,strong)NSMutableArray *items;

/*
 * tableView
 */
@property (nonatomic,strong)UITableView *tableView;

/*
 * 页数
 */
@property (nonatomic,assign)NSInteger page;

/*
 *
 */
@property (nonatomic,copy)NSString *score;


@end

@implementation DZJfdhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.score = @"0";
    self.page = 1;
    self.navigationItem.title = @"积分兑换";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];;
    [self.tableView.mj_header beginRefreshing];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


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
            [self getScoreData];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page++;
            [self getScoreData];
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
    DZJfdhTableViewCell *cell =  [DZJfdhTableViewCell cellWithTableView:tableView];
    cell.tag = indexPath.row;
    cell.list = self.items[indexPath.row];
    @weakify(self);
    cell.btnBlock = ^(NSInteger source, NSInteger tag) {
        @strongify(self);
        JSScoreList *list = self.items[tag];
        DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
        vc.goodsId = list.goods_id;
        vc.act_id = list.act_id;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中一行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
//每行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 177;
}

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (DZJfdhHead *)headView {
    if(!_headView) {
        _headView = [DZJfdhHead viewFormNib];
        _headView.frame = CGRectMake(0, 0,KScreenWidth, KScreenWidth *4/7.5);
        //        @weakify(self);
    }
    return _headView;
}

- (void)getScoreData
{
    NSDictionary *params = @{@"p":@(self.page)};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexUserApi/scoreExchangeList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        JSScoreModel *model = [JSScoreModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
            _tableView.tableHeaderView = self.headView;
            if (self.page == 1) {
                [self.items removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.items addObjectsFromArray:model.data.list];
            if (self.items.count == 0) {
//                self.score = @"";
                self.score = model.data.user_score;
            }else {
                self.score = model.data.user_score;
            }
            _headView.priceL.text = self.score;
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
        [self.tableView.mj_header endRefreshing];
    }];
}

@end
