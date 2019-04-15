//
//  DZFindViewController.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/25.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZFindViewController.h"
#import "HMSegmentedControl.h"
#import "JSHospitalInformationCell.h"
#import "JSCircleTipModel.h"
#import "JSCircleListModel.h"
#import "DZCircleDetailViewController.h"
@interface DZFindViewController ()<UITableViewDataSource,UITableViewDelegate>


/*
 * segmentedControl
 */
@property (nonatomic,strong)HMSegmentedControl *segmentedControl;

/*
 * tableView
 */
@property (nonatomic,strong)UITableView *tableView;

/*
 * arr
 */
@property (nonatomic,strong)NSMutableArray *arr;

/*
 * goodsIndex
 */
@property (nonatomic,assign)NSInteger goodsIndex;

/*
 * page
 */
@property (nonatomic,assign)NSInteger page;

/*
 * 注释JSScoreModel
 */
@property (nonatomic,strong)JSCircleTipModel *model;

/*
 * items
 */
@property (nonatomic,strong)NSMutableArray *items;



@end

@implementation DZFindViewController

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodsIndex = 0;
    self.page = 1;
    self.navigationItem.title = @"发现";
    [self loadData];
    // Do any additional setup after loading the view.
    [self setupSectionTitles];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadGoods];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadGoods];
    }];
}


- (void)setupSectionTitles
{
    
//    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(44);
//    }];
    
    [self setupTableView];
}




- (HMSegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl=[[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
        _segmentedControl.selectionIndicatorColor=OrangeColor;
        _segmentedControl.selectionIndicatorHeight=1;
        _segmentedControl.borderWidth=1;
        _segmentedControl.borderColor=[UIColor colorWithRed:0.965f green:0.965f blue:0.965f alpha:1.00f];
        
        NSDictionary *selectdefaults = @{
                                         NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
                                         NSForegroundColorAttributeName : OrangeColor,
                                         };
        NSMutableDictionary *selectresultingAttrs = [NSMutableDictionary dictionaryWithDictionary:selectdefaults];
        
        NSDictionary *defaults = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
                                   NSForegroundColorAttributeName : TextBlackColor,
                                   };
        NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];
        _segmentedControl.selectedTitleTextAttributes=selectresultingAttrs;
        _segmentedControl.titleTextAttributes=resultingAttrs;
        //_segmentedControl.selectedSegmentIndex=0;
        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        @weakify(self);
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            @strongify(self);
            //[self loadDiscovery:index];
            self.goodsIndex = index;
            self.page = 1;
            [self.tableView.mj_header beginRefreshing];
        };
    }
    return _segmentedControl;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)setupTableView
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.frame = CGRectMake(15, 44, KScreenWidth - 30, KScreenHeight - KTabBarH - KNavigationBarH- 44);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSHospitalInformationCell *cell = [JSHospitalInformationCell cellWithTableView:tableView];
    cell.model = [self.items objectAtIndex:indexPath.section];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125 + (self.tableView.width - 26) *0.52;
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{

//    JSHospitalInfomationNewslist *list = [self.arr objectAtIndex:section];
//
//    UIView *headView = [[UIView alloc]init];
//    headView.backgroundColor = [UIColor whiteColor];
//
//    UILabel *timeL = [[UILabel alloc]init];
//    timeL.text = list.createDate;
//    timeL.textAlignment = NSTextAlignmentCenter;
//    timeL.textColor = [UIColor whiteColor];
//    timeL.backgroundColor = KRGBA(210, 210, 210, 1);
//    timeL.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 10];
//    [headView addSubview:timeL];
//    [timeL sizeToFit];
//    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(headView);
//        make.centerY.mas_equalTo(headView);
//        make.width.mas_equalTo(timeL.width + 10);
//        make.height.mas_equalTo(timeL.height + 4);
//    }];
//    timeL.layer.cornerRadius = 0.5*timeL.height + 2;
//    timeL.layer.masksToBounds = YES;
//    return headView;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSCircleListData *data = self.items[indexPath.section];
    DZCircleDetailViewController *circleDetailVc = [[DZCircleDetailViewController alloc]init];
    circleDetailVc.name = data.title;
    circleDetailVc.image = data.thumb_img;
    circleDetailVc.article_id = data.article_id;
    [self.navigationController pushViewController:circleDetailVc animated:YES];
}

- (void)netRequest
{
    
}


- (NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}


#pragma mark - ---- 私有方法 ----
- (void)loadData {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ArticleApi/articleCategory" parameters:nil];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        JSCircleTipModel *model = [JSCircleTipModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
            self.model = model;
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < model.data.count; i++) {
                JSCircleTipData *catagory = model.data[i];
                [items addObject:catagory.name];
            }
            if (self.segmentedControl) {
                [self.segmentedControl removeFromSuperview];
                self.segmentedControl = nil;
            }
            self.segmentedControl.sectionTitles = items;
            if (items.count < 5) {
                _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
            }
            [self.view addSubview:self.segmentedControl];
            if (self.model.data.count != 0) {
                [self.tableView.mj_header beginRefreshing];
            }
            self.segmentedControl.backgroundColor = self.tableView.backgroundColor;
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)loadGoods
{
    if (self.model.data.count == 0) {
        return;
    }
    JSCircleTipData *data = self.model.data[self.goodsIndex];
    NSDictionary *params = @{@"article_category_id":data.article_category_id,@"p":@(self.page)};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ArticleApi/article" parameters:params method:LCRequestMethodPost];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        JSCircleListModel *model = [JSCircleListModel objectWithKeyValues:request.responseJSONObject];
        if (self.page == 1) {
            [self.tableView.mj_header endRefreshing];
            [self.items removeAllObjects];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        if (model.status == 1) {
            [self.items addObjectsFromArray:model.data];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
        [self.tableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
