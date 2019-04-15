//
//  DZBatchGoodsEditVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZBatchGoodsEditVC.h"
#import "DZGoodPreviewVC.h"

#import "DZGoodManagementEditCell.h"

@interface DZBatchGoodsEditVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIBarButtonItem *leftItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *selectAllImageView;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;

@property (nonatomic) BOOL isSelectedAll;

@property (nonatomic) BOOL needUpdateOriginalData;//是否需要刷新上一页数据

@end

@implementation DZBatchGoodsEditVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理上架商品";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self fillMode];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (void)leftItemAction{
    if (self.needUpdateOriginalData) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateOriginalData)]) {
            [self.delegate updateOriginalData];
        }
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteButtonAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *array = [NSMutableArray array];
        for (DZGoodModel *model in self.dataArray) {
            if (model.isSelected) {
                [array addObject:model.goods_id];
            }
        }
        if (!array.count) {
            return;
        }
        NSString *ids = [array componentsJoinedByString:@","];
        NSDictionary *params = @{@"goods_id":ids};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsEditApi/delGoods" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                NSMutableArray *resultArray = [NSMutableArray array];
                for (DZGoodModel *model in self.dataArray) {
                    if (!model.isSelected) {
                        [resultArray addObject:model];
                    }
                }
                self.dataArray = resultArray;
                [self.tableView reloadData];
                self.needUpdateOriginalData = YES;
            }else{
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

//上架／下架
- (IBAction)switchButonAction {
    NSMutableArray *array = [NSMutableArray array];
    for (DZGoodModel *model in self.dataArray) {
        if (model.isSelected) {
            [array addObject:model.goods_id];
        }
    }
    if (!array.count) {
        return;
    }
    NSString *ids = [array componentsJoinedByString:@","];
    NSString *goodsState;
    if ([self.currentType isEqualToString:@"0"]) {
        goodsState = @"1";
    }else{
        goodsState = @"0";
    }
    NSDictionary *params = @{@"goods_state":goodsState, @"goods_id":ids};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsEditApi/changeGoodsStatus" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            NSMutableArray *resultArray = [NSMutableArray array];
            for (DZGoodModel *model in self.dataArray) {
                if (!model.isSelected) {
                    [resultArray addObject:model];
                }
            }
            self.dataArray = resultArray;
            [self.tableView reloadData];
            self.needUpdateOriginalData = YES;
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (IBAction)selectAllButtonAction {
    self.isSelectedAll = !self.isSelectedAll;
    if (self.isSelectedAll) {
        self.selectAllImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_s"];
        for (DZGoodModel *model in self.dataArray) {
            model.isSelected = YES;
        }
        [self.tableView reloadData];
    }else{
        self.selectAllImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_n"];
        for (DZGoodModel *model in self.dataArray) {
            model.isSelected = NO;
        }
        [self.tableView reloadData];
    }
}

#pragma mark - ---- 代理相关 ----

#pragma mark - ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DZGoodModel *model = self.dataArray[indexPath.row];
    model.isSelected = !model.isSelected;
    [self.tableView reloadData];
}
#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZGoodManagementEditCell *cell = [tableView dequeueReusableCellWithIdentifier:[DZGoodManagementEditCell cellIdentifier]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZGoodManagementEditCell" owner:self options:nil] firstObject];
    }
    DZGoodModel *model = self.dataArray[indexPath.row];
    [cell fillData:model];
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)fillMode{
    if ([self.currentType isEqualToString:@"1"]) {
        self.title = @"管理上架商品";
        [self.operationButton setTitle:@"下架" forState:UIControlStateNormal];
        [self.operationButton setImage:[UIImage imageNamed:@"good_icon_down"] forState:UIControlStateNormal];
    }else{
        self.title = @"管理下架商品";
        [self.operationButton setTitle:@"上架" forState:UIControlStateNormal];
        [self.operationButton setImage:[UIImage imageNamed:@"good_icon_up"] forState:UIControlStateNormal];
    }
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)leftItem{
    if (!_leftItem) {
        _leftItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
        _leftItem.tintColor = HEXCOLOR(0x333333);
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _leftItem;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
