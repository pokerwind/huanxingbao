//
//  DZGoodManagmentVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/24.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodManagmentVC.h"
#import "DZBatchGoodsEditVC.h"
#import "DZCreateGoodVC.h"
#import "LNNavigationController.h"
#import "DZGoodPreviewVC.h"

#import "DZGoodManegementCell.h"

#import "DZGetGoodListModel.h"

@interface DZGoodManagmentVC ()<UITableViewDelegate, UITableViewDataSource, DZBatchGoodsEditVCDelegate, DZCreateGoodVCDelegate, DZGoodPreviewVCDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightItem;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *slider;
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UILabel *inLabel;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *inButton;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIButton *addButton;

@property (strong, nonatomic) NSArray *dataArray;
@property (nonatomic) NSString *currentType;//0:已下架1:已上架

@end

@implementation DZGoodManagmentVC

static  NSString  *CellIdentiferId = @"DZGoodManegementCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品管理";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.line];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.allLabel];
    [self.view addSubview:self.inLabel];
    [self.view addSubview:self.allButton];
    [self.view addSubview:self.inButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addButton];
    
    [self setSubViewsFrame];
    
    self.currentType = @"1";
    [self getDataWithType:self.currentType];
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
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    [self.inLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.mas_equalTo(self.allLabel);
        make.left.mas_equalTo(self.allLabel.mas_right);
        make.right.mas_equalTo(0);
    }];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.allLabel);
    }];
    [self.inButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.inLabel);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.right.bottom.left.mas_equalTo(0);
    }];
    self.addButton.hidden = YES;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)rightItemAction{
    if (!self.dataArray.count) {
        [SVProgressHUD showErrorWithStatus:@"没有可编辑的商品~"];
        return;
    }
    DZBatchGoodsEditVC *vc = [DZBatchGoodsEditVC new];
    vc.dataArray = self.dataArray;
    vc.currentType = self.currentType;
    vc.delegate = self;
    LNNavigationController *nvc = [[LNNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

- (void)switchButtonAction:(UIButton *)btn{
    self.allLabel.textColor = DefaultTextBlackColor;
    self.inLabel.textColor = DefaultTextBlackColor;
    
    switch (btn.tag) {
        case 0:{
            self.inLabel.textColor = HEXCOLOR(0xff8903);
            [UIView animateWithDuration:.2 animations:^{
                self.slider.frame = CGRectMake(SCREEN_WIDTH / 2, self.slider.y, self.slider.width, self.slider.height);
            }];
            self.currentType = @"0";
            [self getDataWithType:self.currentType];
            break;
        }
        case 1:{
            self.allLabel.textColor = HEXCOLOR(0xff8903);
            [UIView animateWithDuration:.2 animations:^{
                self.slider.frame = CGRectMake(0, self.slider.y, self.slider.width, self.slider.height);
            }];
            self.currentType = @"1";
            [self getDataWithType:self.currentType];
            break;
        }
        default:
            break;
    }
}

- (void)addButtonAction{
    DZCreateGoodVC *vc = [DZCreateGoodVC new];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZGoodPreviewVCDelegate ----
- (void)goodOperationSuccess:(NSString *)goodId{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
    for (DZGoodModel *model in array) {
        if ([model.goods_id isEqualToString:goodId]) {
            [array removeObject:model];
            break;
        }
    }
    self.dataArray = array;
    [self.tableView reloadData];
}

- (void)goodOperationSuccess{
    [self getDataWithType:self.currentType];
}
#pragma mark - ---- DZCreateGoodVCDelegate ----
- (void)didAddGood{
    [self getDataWithType:self.currentType ];
}

#pragma mark - ---- DZBatchGoodsEditVCDelegate ----
- (void)updateOriginalData{
    [self getDataWithType:self.currentType];
}

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    DZGoodModel *model = self.dataArray[indexPath.row];
    DZGoodPreviewVC *vc = [DZGoodPreviewVC new];
    vc.currentType = self.currentType;
    vc.goods_id = model.goods_id;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZGoodManegementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (!cell) {
        cell = [DZGoodManegementCell viewFormNib];
    }
    
    DZGoodModel *model = self.dataArray[indexPath.row];
    [cell fillData:model];
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)getDataWithType:(NSString *)type{
    NSDictionary *params = @{@"goods_state":type};
    [SVProgressHUD show];
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsEditApi/getGoodsList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetGoodListModel *model =[DZGetGoodListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.dataArray = model.data.goods_list;
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
        _slider = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH / 2, 1)];
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
        _allLabel.text = @"已上架";
    }
    return _allLabel;
}

- (UILabel *)inLabel{
    if (!_inLabel) {
        _inLabel = [UILabel new];
        _inLabel.font = [UIFont systemFontOfSize:14];
        _inLabel.textColor = HEXCOLOR(0x333333);
        _inLabel.textAlignment = NSTextAlignmentCenter;
        _inLabel.text = @"已下架";
    }
    return _inLabel;
}

- (UIButton *)allButton{
    if (!_allButton) {
        _allButton = [UIButton new];
        _allButton.tag = 1;
        [_allButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (UIButton *)inButton{
    if (!_inButton) {
        _inButton = [UIButton new];
        _inButton.tag = 0;
        [_inButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inButton;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        _rightItem.tintColor = HEXCOLOR(0x333333);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton new];
        [_addButton setTitle:@"上架新款" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _addButton.backgroundColor = HEXCOLOR(0xff7722);
        [_addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end
