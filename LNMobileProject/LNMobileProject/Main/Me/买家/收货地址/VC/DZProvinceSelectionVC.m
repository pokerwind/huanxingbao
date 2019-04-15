//
//  DZProvinceSelectionVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZProvinceSelectionVC.h"
#import "DZCitySelectionVC.h"

#import "DZGetRegionListModel.h"

@interface DZProvinceSelectionVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIBarButtonItem *leftItem;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *provinceArray;

@end

@implementation DZProvinceSelectionVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择省份";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.tableView];
    [self setSubViewsLayout];
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----
- (void)setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


#pragma mark - ---- Action Events 和 response手势 ----
- (void)leftItemAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DZRegionModel *model = self.provinceArray[indexPath.row];
    DZCitySelectionVC *vc = [DZCitySelectionVC new];
    vc.province = model.region_name;
    vc.regionId = model.uid;
    vc.delegate = self.districtDelegateVC;
    vc.districtDelegateVC = self.districtDelegateVC;
    vc.isUtilCity = self.isUtilCity;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.provinceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    DZRegionModel *model = self.provinceArray[indexPath.row];
    cell.textLabel.text = model.region_name;
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"parent_id":@"0"};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Core/RegionApi/getRegionList" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetRegionListModel *model = [DZGetRegionListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.provinceArray = model.data;
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [NSArray array];
    }
    return _provinceArray;
}

- (UIBarButtonItem *)leftItem{
    if (!_leftItem) {
        _leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
        _leftItem.tintColor = HEXCOLOR(0xff7722);
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];

    }
    return _leftItem;
}

@end
