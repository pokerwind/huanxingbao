//
//  DZCartVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCartVC.h"
#import "DZCartModifyVC.h"
#import "DZSubmitOrderVC.h"
#import "DZGoodsDetailVC.h"
#import "JSShopCartModel.h"
#import "DZShopCollectionRightView.h"
#import "DZCartCell.h"

//#import "DZGetCartListModel.h"

@interface DZCartVC ()<UITableViewDelegate, UITableViewDataSource, DZCartCellSelectionDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightEditItem;
@property (nonatomic, strong) UIBarButtonItem *rightMessageItem;
@property (nonatomic, strong) DZShopCollectionRightView *rightView;
@property (nonatomic, strong) UIBarButtonItem *leftCancelItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *selecAllImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (strong, nonatomic) NSArray *dataArray;
@property (nonatomic) BOOL isSelectedAll;

@end

@implementation DZCartVC
static NSString *identifier = @"DZCartCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"购物车";
    self.navigationItem.rightBarButtonItem = self.rightEditItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartDidModified) name:CARTUPDATENOTIFICATION object:nil];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark - ---- 代理相关 ----
- (void)cartDidModified{
    [self.tableView.mj_header beginRefreshing];
    
    self.navigationItem.rightBarButtonItem = self.rightEditItem;
    self.navigationItem.leftBarButtonItem = nil;
    self.totalMoneyLabel.hidden = NO;
    self.totalTitleLabel.hidden = NO;
    self.expressLabel.hidden = NO;
    [self.submitButton setTitle:@"去结算" forState:UIControlStateNormal];
}

#pragma mark - ---- DZCartCellSelectionDelegate ----
- (void)selectionChanged{
    [self.tableView reloadData];
    
    BOOL isAllSelected = YES;
    float totalMoney = 0;
    for (JSShopCartList *model in self.dataArray) {
        for (JSShopCartGoods *models in model.goods) {
            if (models.isSelected) {
                totalMoney += [models.price floatValue] * [models.buy_number integerValue];
            }else{
                isAllSelected = NO;
            }
        }
    }
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f", totalMoney];
    if (isAllSelected) {
        self.selecAllImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_s"];
        self.isSelectedAll = YES;
    }else{
        self.selecAllImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_n"];
        self.isSelectedAll = NO;
    }
}

- (void)modifyFrameWithGroup:(NSInteger)group goodIndex:(NSInteger)goodIndex{
    JSShopCartList *model = self.dataArray[group];
    JSShopCartGoods *goodModel = model.goods[goodIndex];
    
    DZCartModifyVC *vc = [DZCartModifyVC new];
    vc.goods_id = goodModel.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickGood:(NSString *)goodId{
    DZGoodsDetailVC *vc = [DZGoodsDetailVC new];
    vc.goodsId = goodId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSShopCartList *model = self.dataArray[indexPath.row];
    return 52.5 + 120 * model.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZCartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [DZCartCell viewFormNib];
    }
    JSShopCartList *model = self.dataArray[indexPath.row];
    [cell fillData:model];
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    return cell;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)editItemAction{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = self.leftCancelItem;
    
    self.totalMoneyLabel.hidden = YES;
    self.totalTitleLabel.hidden = YES;
    self.expressLabel.hidden = YES;
    [self.submitButton setTitle:@"删除" forState:UIControlStateNormal];
}

- (void)submitItemAction{
    self.navigationItem.rightBarButtonItem = self.rightEditItem;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)messageItemAction{
    self.rightView.countLabel.hidden = !self.rightView.countLabel.hidden;
}

- (void)cancelItemAction{
    self.navigationItem.rightBarButtonItem = self.rightEditItem;
    self.navigationItem.leftBarButtonItem = nil;
    self.totalMoneyLabel.hidden = NO;
    self.totalTitleLabel.hidden = NO;
    self.expressLabel.hidden = NO;
    [self.submitButton setTitle:@"去结算" forState:UIControlStateNormal];
}

- (IBAction)selectAllButtonAction {
    self.isSelectedAll = !self.isSelectedAll;
    if (self.isSelectedAll) {
        self.selecAllImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_s"];
        float totalMoney = 0;
        
        for (JSShopCartList *model in self.dataArray) {
            for (JSShopCartGoods *models in model.goods) {
                models.isSelected = YES;
                
                totalMoney += [models.price floatValue] * [models.buy_number integerValue];
            }
        }
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f", totalMoney];
    }else{
        self.selecAllImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_n"];
        for (JSShopCartList *model in self.dataArray) {
            for (JSShopCartGoods *models in model.goods) {
                models.isSelected = NO;
            }
        }
        self.totalMoneyLabel.text = @"0.00";
    }
    [self.tableView reloadData];
}

- (IBAction)payButtonAction {
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *shopIds = [NSMutableArray array];
    NSMutableArray *cartIds = [NSMutableArray array];

    for (JSShopCartList *model in self.dataArray) {
        for (JSShopCartGoods *models in model.goods) {
            if (models.isSelected) {
                [array addObject:models.cart_id];
                BOOL isbutong = NO;
                for (NSString *str1 in shopIds) {
                    if ([str1 isEqualToString:models.shop_id]) {
                        isbutong = YES;
                        break;
                    }
                }
                if (isbutong == NO) {
                    [shopIds addObject:models.shop_id];
                }
                [cartIds addObject:models.cart_id];
            }
        }
    }
    
    if (!array.count) {
        [SVProgressHUD showErrorWithStatus:@"您没有选中任何商品"];
        return;
    }
    
    if (self.navigationItem.leftBarButtonItem) {//编辑模式
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定从购物车中删除所有选中的商品吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *params = @{@"cart_id":[array componentsJoinedByString:@","]};
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/CartApi/delCartGoods" parameters:params method:LCRequestMethodPost];
            [SVProgressHUD show];
            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                [SVProgressHUD dismiss];
                LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
                if (model.isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:model.info];
                    [self.tableView.mj_header beginRefreshing];
                }else{
                    [SVProgressHUD showErrorWithStatus:model.info];
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD dismiss];
            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }else{//购买模式
        DZSubmitOrderVC *vc = [DZSubmitOrderVC new];
        vc.source = 0;
        vc.goodIds = array;
        vc.shopIds = shopIds;
        vc.cart_ids = cartIds;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)goButtonClick {
    [self showTabWithIndex:0 needSwitch:NO showLogin:NO];
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/CartApi/getCartList" parameters:nil method:LCRequestMethodPost];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        JSShopCartModel *model = [JSShopCartModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
            self.dataArray = model.data.list;
            if (self.dataArray.count) {
                self.emptyView.hidden = YES;
            }else{
                self.emptyView.hidden = NO;
            }
            self.selecAllImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_n"];
            self.isSelectedAll = NO;
            
            for (JSShopCartList *cartModel in self.dataArray) {
                for (JSShopCartGoods *model in cartModel.goods) {
                    model.isSelected = YES;
                }
            }
            
            [self.tableView reloadData];
            [self selectionChanged];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightEditItem{
    if (!_rightEditItem) {
        _rightEditItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editItemAction)];
        [_rightEditItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightEditItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
        _rightEditItem.tintColor = DefaultTextBlackColor;
    }
    return _rightEditItem;
}

- (UIBarButtonItem *)rightMessageItem{
    if (!_rightMessageItem) {
        _rightMessageItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightView];
    }
    return _rightMessageItem;
}

- (DZShopCollectionRightView *)rightView{
    if (!_rightView) {
        _rightView = [[[NSBundle mainBundle] loadNibNamed:@"DZShopCollectionRightView" owner:self options:nil] firstObject];
        _rightView.countLabel.layer.cornerRadius = 6.5;
        _rightView.countLabel.layer.masksToBounds = YES;
        [_rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageItemAction)]];
    }
    return _rightView;
}

- (UIBarButtonItem *)leftCancelItem{
    if (!_leftCancelItem) {
        _leftCancelItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemAction)];
        [_leftCancelItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_leftCancelItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
        _leftCancelItem.tintColor = DefaultTextBlackColor;
    }
    return _leftCancelItem;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
