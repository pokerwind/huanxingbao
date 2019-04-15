//
//  DZMyBillDetailVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMyBillDetailVC.h"

#import "DZBillDetailCell.h"

#import "DZGetBalanceDetailsModel.h"

@interface DZMyBillDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *slider;
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UILabel *inLabel;
@property (nonatomic, strong) UILabel *outLabel;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *inButton;
@property (nonatomic, strong) UIButton *outButton;
@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic) NSInteger p;

@end

@implementation DZMyBillDetailVC

static  NSString  *CellIdentiferId = @"DZBillDetailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"明细";
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.line];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.allLabel];
    [self.view addSubview:self.inLabel];
    [self.view addSubview:self.outLabel];
    [self.view addSubview:self.allButton];
    [self.view addSubview:self.inButton];
    [self.view addSubview:self.outButton];
    [self.view addSubview:self.tableView];
    
    [self setSubViewsFrame];
    
    self.allLabel.textColor = DefaultTextBlackColor;
    self.inLabel.textColor = DefaultTextBlackColor;
    self.outLabel.textColor = DefaultTextBlackColor;
    
    switch (self.type) {
        case 0:{
            self.allLabel.textColor = HEXCOLOR(0xff8903);
            [self getDataWithType:[NSString stringWithFormat:@"%ld", self.type]];
            break;
        }
        case 1:{
            self.inLabel.textColor = HEXCOLOR(0xff8903);
            [self getDataWithType:[NSString stringWithFormat:@"%ld", self.type]];
            break;
        }
        case 2:{
            self.outLabel.textColor = HEXCOLOR(0xff8903);
            [self getDataWithType:[NSString stringWithFormat:@"%ld", self.type]];
            break;
        }
        default:
            break;
    }
    self.slider.frame = CGRectMake(self.type * SCREEN_WIDTH / 3, self.slider.y, self.slider.width, self.slider.height);
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(39.5);
        make.right.left.mas_equalTo(0);
    }];
    [self.allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH / 3);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    [self.inLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.mas_equalTo(self.allLabel);
        make.left.mas_equalTo(self.allLabel.mas_right);
    }];
    [self.outLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.mas_equalTo(self.allLabel);
        make.left.mas_equalTo(self.inLabel.mas_right);
    }];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.allLabel);
    }];
    [self.inButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.inLabel);
    }];
    [self.outButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.outLabel);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.right.bottom.left.mas_equalTo(0);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)switchButtonAction:(UIButton *)btn{
    self.allLabel.textColor = DefaultTextBlackColor;
    self.inLabel.textColor = DefaultTextBlackColor;
    self.outLabel.textColor = DefaultTextBlackColor;
    
    switch (btn.tag) {
        case 0:{
            self.allLabel.textColor = HEXCOLOR(0xff8903);
            self.type = 0;
            break;
        }
        case 1:{
            self.inLabel.textColor = HEXCOLOR(0xff8903);
            self.type = 1;
//            [self getDataWithType:[NSString stringWithFormat:@"%ld", self.type]];
            break;
        }
        case 2:{
            self.outLabel.textColor = HEXCOLOR(0xff8903);
            self.type = 2;
//            [self getDataWithType:[NSString stringWithFormat:@"%ld", self.type]];
            break;
        }
        default:
            break;
    }
    [_tableView.mj_header beginRefreshing];
    [UIView animateWithDuration:.2 animations:^{
        self.slider.frame = CGRectMake(btn.tag * SCREEN_WIDTH / 3, self.slider.y, self.slider.width, self.slider.height);
    }];
}

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    DZBalanceDetailModel *model = self.dataArray[section];
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentiferId owner:self options:nil] firstObject];
    }
    
    DZBalanceDetailModel *model = self.dataArray[indexPath.row];
//    DZBalancLogModel *log = model.log_list[indexPath.row];
    [cell fillData:model];
    
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    view.backgroundColor = [UIColor whiteColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, 100, 18)];
//    label.font = [UIFont systemFontOfSize:13];
//    label.textColor = HEXCOLOR(0x666666);
//    [view addSubview:label];
////    DZBalanceDetailModel *model = self.dataArray[section];
////    label.text = model.date;
//
//    return view;
//}

#pragma mark - ---- 私有方法 ----
- (void)getDataWithType:(NSString *)type{
    self.p = 1;
    NSDictionary *params;
    if (!type || [type isBlankString]) {
        params = @{@"p":@(self.p)};
    }else{
        if (type.integerValue == 0) {
            params = @{@"p":@(self.p)};
        }else {
            params = @{@"type":type, @"p":@(self.p)};
        }
    }
    LNetWorkAPI *api;
    if ([DPMobileApplication sharedInstance].isSellerMode) {
//        api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getBalanceDetails" parameters:params];
        api = [[LNetWorkAPI alloc] initWithUrl:@"Api/UserCenterApi/getBalanceDetails" parameters:params];
    }else{
        api = [[LNetWorkAPI alloc] initWithUrl:@"Api/UserCenterApi/getBalanceDetails" parameters:params];
    }
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        DZGetBalanceDetailsModel *model = [DZGetBalanceDetailsModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.dataArray = [NSMutableArray arrayWithArray:model.data];
            [self.tableView reloadData];
            
            self.p = 2;
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)getMoreDataWithType:(NSString *)type{
    NSDictionary *params;
    if (!type || [type isBlankString]) {
        params = @{@"p":@(self.p)};
    }else{
        if (type.integerValue == 0) {
            params = @{@"p":@(self.p)};
        }else {
            params = @{@"type":type, @"p":@(self.p)};
        }
    }
    LNetWorkAPI *api;
    if ([DPMobileApplication sharedInstance].isSellerMode) {
//        api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getBalanceDetails" parameters:params];
        api = [[LNetWorkAPI alloc] initWithUrl:@"Api/UserCenterApi/getBalanceDetails" parameters:params];
    }else{
        api = [[LNetWorkAPI alloc] initWithUrl:@"Api/UserCenterApi/getBalanceDetails" parameters:params];
    }
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_footer endRefreshing];
        DZGetBalanceDetailsModel *model = [DZGetBalanceDetailsModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.dataArray addObjectsFromArray:model.data];
            [self.tableView reloadData];
            
            self.p++;
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = BannerOtherDotColor;
    }
    return _line;
}

- (UIView *)slider{
    if (!_slider) {
        _slider = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH / 3, 1)];
        _slider.backgroundColor = HEXCOLOR(0xff8903);
    }
    return _slider;
}

- (UILabel *)allLabel{
    if (!_allLabel) {
        _allLabel = [UILabel new];
        _allLabel.font = [UIFont systemFontOfSize:14];
        _allLabel.textColor = HEXCOLOR(0xff8903);
        _allLabel.textAlignment = NSTextAlignmentCenter;
        _allLabel.text = @"全部";
    }
    return _allLabel;
}

- (UILabel *)inLabel{
    if (!_inLabel) {
        _inLabel = [UILabel new];
        _inLabel.font = [UIFont systemFontOfSize:14];
        _inLabel.textColor = HEXCOLOR(0x333333);
        _inLabel.textAlignment = NSTextAlignmentCenter;
        _inLabel.text = @"累计收入";
    }
    return _inLabel;
}

- (UILabel *)outLabel{
    if (!_outLabel) {
        _outLabel = [UILabel new];
        _outLabel.font = [UIFont systemFontOfSize:14];
        _outLabel.textColor = HEXCOLOR(0x333333);
        _outLabel.textAlignment = NSTextAlignmentCenter;
        _outLabel.text = @"累计消费";
    }
    return _outLabel;
}

- (UIButton *)allButton{
    if (!_allButton) {
        _allButton = [UIButton new];
        _allButton.tag = 0;
        [_allButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (UIButton *)inButton{
    if (!_inButton) {
        _inButton = [UIButton new];
        _inButton.tag = 1;
        [_inButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inButton;
}

- (UIButton *)outButton{
    if (!_outButton) {
        _outButton = [UIButton new];
        _outButton.tag = 2;
        [_outButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _outButton;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getDataWithType:[NSString stringWithFormat:@"%ld", self.type]];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self getMoreDataWithType:[NSString stringWithFormat:@"%ld", self.type]];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
