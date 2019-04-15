//
//  JSShopListViewController.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/29.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "JSShopListViewController.h"
#import "UIButton+zt_adjustImageAndTitle.h"
#import "ChooseLocationView.h"
#import "CitiesDataTool.h"
#import "DZShopListTableViewCell.h"
#import "JSShopListModel.h"
#import "DZShopDetailVC.h"
#define k_THUIColorAlpha(hexValue,alphaF) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaF]

@interface JSShopListViewController ()<NSURLSessionDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
/*
 * titleBtn
 */
@property (nonatomic,strong)UIButton *titleBtn;

@property (nonatomic,strong) ChooseLocationView *chooseLocationView;

/*
 * items
 */
@property (nonatomic,strong)NSMutableArray *items;

/*
 * tableView
 */
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong) UIView  *cover;

/*
 * district
 */
@property (nonatomic,copy)NSString *district;
@end

@implementation JSShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.titleBtn;
    
    [[CitiesDataTool sharedManager] requestGetData];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
    
//    self.chooseLocationView.address = @"广东省 广州市 越秀区";
//    self.chooseLocationView.areaCode = @"440104";
    
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
            [self getData];
        }];
    
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.items.count;
}

#pragma mark -- tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//设置标识
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZShopListTableViewCell *cell =  [DZShopListTableViewCell cellWithTableView:tableView];
  
    cell.list = self.items[indexPath.section];
   
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = k_THUIColorAlpha(0xfafafa, 1);
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中一行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JSShopListData *list = self.items[indexPath.section];
    DZShopDetailVC *vc = [[DZShopDetailVC alloc] init];
    vc.shopId =list.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//每行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KScreenWidth *0.62 + 50;
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
    
    //34.9967410000
    NSString *lat = nil;
    NSString *lng = nil;
    NSString *district = nil;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"lat"] length]) {
        lat = [def objectForKey:@"lat"];
    }else{
        lat = @"34.9967410000";
    }
    
    if ([[def objectForKey:@"lng"] length]) {
        lng = [def objectForKey:@"lng"];
    }else{
        lng = @"118.2847860000";
    }
    
    if (self.district.length) {
        district = self.district;
    }else{
        district = [def objectForKey:@"district"];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:lat forKey:@"lat"];
    [params setObject:lng forKey:@"lng"];
    [params setObject:district forKey:@"country"];
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/StoreApi/storeList" parameters:params method:LCRequestMethodPost];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];//distance
        JSShopListModel *model = [JSShopListModel objectWithKeyValues:request.responseJSONObject];
        [self.tableView.mj_header endRefreshing];
        if (model.status == 1) {
            self.items = [model.data mutableCopy];
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



- (UIButton *)titleBtn
{
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] init];
        [_titleBtn setImage:[UIImage imageNamed:@"screen_icon_down"] forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [_titleBtn setTitle:[def objectForKey:@"district"] forState:UIControlStateNormal];
        [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titleBtn.zt_contentAdjustType = ZTContentAdjustImageRightTitleLeft;
        _titleBtn.zt_space = 6;
        [_titleBtn zt_beginAdjustContent];
        [_titleBtn setBackgroundColor:[UIColor whiteColor]];
        [_titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _titleBtn.frame = CGRectMake(0, KStatusBarH, KScreenWidth, 44);
    }
    return _titleBtn;
}

- (void)titleBtnClick:(UIButton *)btn
{
//    [UIView animateWithDuration:0.25 animations:^{
//        self.view.transform =CGAffineTransformMakeScale(0.95, 0.95);
//    }];
    self.cover.hidden = !self.cover.hidden;
    self.chooseLocationView.hidden = self.cover.hidden;
}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)){
        return NO;
    }
    return YES;
}


- (void)tapCover:(UITapGestureRecognizer *)tap{
    
    if (_chooseLocationView.chooseFinish) {
        _chooseLocationView.chooseFinish(@"");
    }
}

- (ChooseLocationView *)chooseLocationView{
    
    if (!_chooseLocationView) {
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)];
        
    }
    return _chooseLocationView;
}

- (UIView *)cover{
    
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_cover addSubview:self.chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^(NSString *district){
            weakSelf.district = district;
            [UIView animateWithDuration:0.25 animations:^{
                if (weakSelf.chooseLocationView.address.length) {
                    [weakSelf.titleBtn setTitle:weakSelf.chooseLocationView.address forState:UIControlStateNormal];
                    [weakSelf justFitBtn];
                    //                weakSelf.view.transform = CGAffineTransformIdentity;
                    [weakSelf.tableView.mj_header beginRefreshing];
                }
                weakSelf.cover.hidden = YES;
            }];
        };
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
        _cover.hidden = YES;
    }
    return _cover;
}

- (void)justFitBtn
{
     __weak typeof (self) weakSelf = self;
    [weakSelf.titleBtn setImage:[UIImage imageNamed:@"screen_icon_down"] forState:UIControlStateNormal];
    weakSelf.titleBtn.zt_contentAdjustType = ZTContentAdjustImageRightTitleLeft;
    weakSelf.titleBtn.zt_space = 6;
    [weakSelf.titleBtn zt_beginAdjustContent];
}

@end
