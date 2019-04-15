//
//  DZShopCateVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopCateVC.h"
#import "DZShopCateCell.h"
#import "DZShopGoodsListVC.h"
#import "DZShopCateModel.h"

#define kShopCateCell @"DZShopCateCell"

@interface DZShopCateVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation DZShopCateVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品分类";
    
    [self.view addSubview:self.tableView];

    [self loadData];
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSubViewsFrame];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark - ---- 代理相关 ----
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZShopCateCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopCateCell];
    DZShopCateModel *model = self.dataArray[indexPath.row];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.image)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    cell.nameLabel.text = model.cat_name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DZShopCateModel *model = self.dataArray[indexPath.row];
    DZShopGoodsListVC *vc = [[DZShopGoodsListVC alloc] init];
    vc.shopId = self.shopId;
    vc.catId = model.cat_id;
    vc.navigationItem.title = model.cat_name;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----
- (void)loadData {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/getGoodsCat" parameters:@{@"shop_id":self.shopId}];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZShopCateNetModel *model = [DZShopCateNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.data];
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
            
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView  {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:kShopCateCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kShopCateCell];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
