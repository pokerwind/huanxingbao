//
//  DZFreightAddressVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZFreightAddressVC.h"

#import "DZFreightProvinceCell.h"

#import "DZGetRegionListModel.h"

@interface DZFreightAddressVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIBarButtonItem *rightItem;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *provinceArray;

@end

@implementation DZFreightAddressVC
static NSString *identifier = @"DZFreightProvinceCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地址";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    [self.view addSubview:self.tableView];
    
    [self getData];
    
    [self setSubViewsLayout];
}

#pragma mark - ---- 布局代码 ----
- (void)setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)rightItemAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedArea:atIndex:)]) {
        NSMutableArray *array = [NSMutableArray array];
        for (DZRegionModel *model in self.provinceArray) {
            if (model.isSelected) {
                [array addObject:model];
            }
        }
        
        [self.delegate didSelectedArea:array atIndex:self.index];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.provinceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZFreightProvinceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [DZFreightProvinceCell viewFormNib];
    }
    DZRegionModel *model = self.provinceArray[indexPath.row];
    cell.nameLabel.text = model.region_name;
    if (model.isSelected) {
        cell.selectedImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_s"];
    }else{
        cell.selectedImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_n"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DZRegionModel *model = self.provinceArray[indexPath.row];
    model.isSelected = !model.isSelected;
    [self.tableView reloadData];
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getTemplateRegion" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetRegionListModel *model = [DZGetRegionListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            NSMutableArray *provinceArray = [NSMutableArray arrayWithArray:model.data];
            for (DZRegionModel *regionModel in provinceArray) {
                if (![self.selectedArray containsObject:regionModel.region_name]) {
                    [self.provinceArray addObject:regionModel];
                }
            }
            
            
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
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        _rightItem.tintColor = HEXCOLOR(0xff7722);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

@end
