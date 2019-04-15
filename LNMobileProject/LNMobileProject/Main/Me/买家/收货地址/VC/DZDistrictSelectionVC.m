//
//  DZDistrictSelectionVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZDistrictSelectionVC.h"

@interface DZDistrictSelectionVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *districtArray;

@end

@implementation DZDistrictSelectionVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.city;
    
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
    DZRegionModel *model = self.districtArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectionProvince:city:district:)]) {
        [self.delegate didSelectionProvince:self.province city:self.city district:model.region_name];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectionProvince:city:district:AndIDProvinceID:cityID:districtID:)]) {
        [self.delegate didSelectionProvince:self.province city:self.city district:model.region_name AndIDProvinceID:self.provinceID cityID:self.regionId districtID:model.uid];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.districtArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    DZRegionModel *model = self.districtArray[indexPath.row];
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
            self.districtArray = model.data;
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

- (NSArray *)districtArray{
    if (!_districtArray) {
        _districtArray = [NSArray array];
    }
    return _districtArray;
}

@end
