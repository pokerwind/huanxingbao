//
//  DZDeliveryVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZDeliveryVC.h"
#import "DZProblemOrderVC.h"
#import "QRCodeVC.h"

#import "DZDeliveryHeaderView.h"
#import "DZOrderDetailCell.h"
#import "DZExpressListView.h"
#import "DZExpressCell.h"

#import "DZGetOrderDetailModel.h"
#import "DZGetExpressListModel.h"

@interface DZDeliveryVC ()<UITableViewDataSource, UITableViewDelegate, QRCodeVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DZDeliveryHeaderView *header;
@property (strong, nonatomic) NSArray *goodsArray;
@property (strong, nonatomic) DZGetOrderDetailModel *model;

@property (strong, nonatomic) UIButton *submitButton;

@property (strong, nonatomic) NSArray *expressArray;
@property (strong, nonatomic) DZExpressListView *expressView;

@property (strong, nonatomic) DZExpressListModel *selectedModel;

@end

@implementation DZDeliveryVC

static  NSString  *CellIdentiferId = @"DZOrderDetailCell";
static  NSString  *expressIdentiferId = @"DZExpressCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发货";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitButton];
    
    [self setSubViewsFrame];
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(223);
        make.width.mas_equalTo(self.tableView);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)expressButtonAction{
    [[UIApplication sharedApplication].delegate.window addSubview:self.expressView];
    [self.expressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(0);
    }];
}

- (void)expressViewCloseButtonAction{
    [self.expressView removeFromSuperview];
}

- (void)expressViewSubmitButtonAction{
    for (DZExpressListModel *model in self.expressArray) {
        if (model.isSelected) {
            self.selectedModel = model;
            break;
        }
    }
    
    if (!self.selectedModel) {
        [SVProgressHUD showErrorWithStatus:@"没有选中任何快递"];
        return;
    }else{
        [self.expressView removeFromSuperview];
        [self.header.expressButton setTitle:self.selectedModel.name forState:UIControlStateNormal];
    }
}

- (void)headerScanButtonAction{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        [SVProgressHUD showInfoWithStatus:@"请您设置允许APP访问您的相机->设置->隐私->相机"];
        return;
    }
    QRCodeVC *vc = [QRCodeVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitButtonClick{
    if (!self.selectedModel) {
        [SVProgressHUD showErrorWithStatus:@"请选择物流公司"];
        return;
    }
    if (!self.header.codeTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请填写物流条码"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定发货？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *params = @{@"order_sn":self.order_sn, @"express_id":self.selectedModel.express_id, @"express_code":self.header.codeTextField.text};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/deliverOrder" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                [SVProgressHUD showSuccessWithStatus:model.info];
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMYORDERNOTIFICATION object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:USERORDERINFOUPDATEDNOTIFICATION object:nil];
                [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - ---- QRCodeVCDelegate ----
- (void)didScanText:(NSString *)text{
    self.header.codeTextField.text = text;
}

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        return 75 + 80 * self.goodsArray.count;
    }else{
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == self.tableView) {
        
    }else{
        for (DZExpressListModel *model in self.expressArray) {
            model.isSelected = NO;
        }
        DZExpressListModel *model = self.expressArray[indexPath.row];
        model.isSelected = YES;
        
        [self.expressView.tableView reloadData];
    }
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (self.goodsArray.count) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return self.expressArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        DZOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DZOrderDetailCell" owner:nil options:nil] lastObject];
        }
        [cell fillData:self.model];
        if ([DPMobileApplication sharedInstance].isSellerMode) {
            cell.phoneButton.hidden = YES;
            cell.messageButton.hidden = YES;
        }
        
        return cell;
    }else{
        DZExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:expressIdentiferId];
        if (!cell) {
            cell = [DZExpressCell viewFormNib];
        }
        DZExpressListModel *model = self.expressArray[indexPath.row];
        [cell fillData:model];
        
        return cell;
    }
}

#pragma mark - --- 私有方法 ----
- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getExpressList" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZGetExpressListModel *model = [DZGetExpressListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.expressArray = model.data;
            [self.expressView.tableView reloadData];
        }else{
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
    }];
    
    [SVProgressHUD show];
    NSDictionary *params2 = @{@"order_sn":self.order_sn};
    LNetWorkAPI *api2 = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getOrderInfo" parameters:params2];
    [api2 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        self.model = [DZGetOrderDetailModel objectWithKeyValues:request.responseJSONObject];
        if (self.model.isSuccess) {
            self.header.numberLabel.text = self.model.data.order_sn;
            self.header.dateLabel.text = [self.model.data.add_time substringToIndex:10];
            self.header.personLabel.text = self.model.data.consignee;
            self.header.addressLabel.text = self.model.data.address;
            
            self.goodsArray = self.model.data.order_goods;
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:self.model.info];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.header;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
    }
    return _tableView;
}

- (DZDeliveryHeaderView *)header{
    if (!_header) {
        _header = [[[NSBundle mainBundle] loadNibNamed:@"DZDeliveryHeaderView" owner:self options:nil] lastObject];
        [_header.expressButton addTarget:self action:@selector(expressButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_header.scanButton addTarget:self action:@selector(headerScanButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _header;
}

- (NSArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [NSArray array];
    }
    return _goodsArray;
}

- (NSArray *)expressArray{
    if (!_expressArray) {
        _expressArray = [NSArray array];
    }
    return _expressArray;
}

- (DZExpressListView *)expressView{
    if (!_expressView) {
        _expressView = [DZExpressListView viewFormNib];
        [_expressView.closeButton addTarget:self action:@selector(expressViewCloseButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_expressView.submitButton addTarget:self action:@selector(expressViewSubmitButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _expressView.tableView.dataSource = self;
        _expressView.tableView.delegate = self;
    }
    return _expressView;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton new];
        [_submitButton setTitle:@"确认发货" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.backgroundColor = HEXCOLOR(0xff7722);
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
