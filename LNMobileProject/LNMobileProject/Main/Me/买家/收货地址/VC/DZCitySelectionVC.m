//
//  DZCitySelectionVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCitySelectionVC.h"

#import "DZGetRegionListModel.h"
#import "DZDistrictSelectionVC.h"

@interface DZCitySelectionVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *cityArray;

@end

@implementation DZCitySelectionVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.province;
    
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

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isUtilCity) {
        DZRegionModel *model = self.cityArray[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectionProvince:city:)]) {
            [self.delegate didSelectionProvince:self.province city:model.region_name];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        DZRegionModel *model = self.cityArray[indexPath.row];
        DZDistrictSelectionVC *vc = [DZDistrictSelectionVC new];
        vc.province = self.province;
        vc.provinceID = self.regionId;
        vc.city = model.region_name;
        vc.regionId = model.uid;
        vc.delegate = self.districtDelegateVC;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    DZRegionModel *model = self.cityArray[indexPath.row];
    cell.textLabel.text = model.region_name;
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"parent_id":self.regionId};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Core/RegionApi/getRegionList" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetRegionListModel *model = [DZGetRegionListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.cityArray = model.data;
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

- (NSArray *)cityArray{
    if (!_cityArray) {
        _cityArray = [NSArray array];
    }
    return _cityArray;
}

@end
