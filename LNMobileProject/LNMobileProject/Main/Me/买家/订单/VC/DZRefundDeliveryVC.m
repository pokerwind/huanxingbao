//
//  DZRefundDeliveryVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZRefundDeliveryVC.h"
#import "QRCodeVC.h"

#import "DZExpressListView.h"
#import "DZExpressCell.h"

#import "DZGetExpressListModel.h"

@interface DZRefundDeliveryVC ()<UITableViewDataSource, UITableViewDelegate, QRCodeVCDelegate>

@property (weak, nonatomic) IBOutlet UIButton *expressButton;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property (strong, nonatomic) NSArray *expressArray;
@property (strong, nonatomic) DZExpressListView *expressView;

@property (strong, nonatomic) NSString *expressId;
@property (strong, nonatomic) NSString *expressName;

@end

@implementation DZRefundDeliveryVC
static  NSString  *expressIdentiferId = @"DZExpressCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认发货";
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)expressButtonAction {
    [[UIApplication sharedApplication].delegate.window addSubview:self.expressView];
    [self.expressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(0);
    }];
}

- (IBAction)scanButtonAction {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        [SVProgressHUD showInfoWithStatus:@"请您设置允许APP访问您的相机->设置->隐私->相机"];
        return;
    }
    QRCodeVC *vc = [QRCodeVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)submitButtonAction {
    if (!self.expressName || !self.expressId) {
        [SVProgressHUD showErrorWithStatus:@"请先选择快递"];
        return;
    }
    if (!self.numberTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入物流条码"];
        return;
    }
    NSDictionary *params = @{@"order_sn":self.order_sn, @"express_id":self.expressId, @"express_name":self.expressName, @"express_code":self.numberTextField.text};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/setExpressSn" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSendSuccess)]) {
                [self.delegate didSendSuccess];
            }
            
            if (self.removeVC) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [array removeObjectAtIndex:array.count - 2];
                self.navigationController.viewControllers = array;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)expressViewCloseButtonAction{
    [self.expressView removeFromSuperview];
}

- (void)expressViewSubmitButtonAction{
    DZExpressListModel *selectedModel;
    for (DZExpressListModel *model in self.expressArray) {
        if (model.isSelected) {
            selectedModel = model;
            break;
        }
    }
    
    if (!selectedModel) {
        [SVProgressHUD showErrorWithStatus:@"没有选中任何快递"];
        return;
    }else{
        [self.expressView removeFromSuperview];
        [self.expressButton setTitle:selectedModel.name forState:UIControlStateNormal];
        self.expressId = selectedModel.express_id;
        self.expressName = selectedModel.name;
    }
}
#pragma mark - ---- 代理相关 ----
#pragma mark - ---- QRCodeVCDelegate ----
- (void)didScanText:(NSString *)text{
    self.numberTextField.text = text;
}

#pragma mark - ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    for (DZExpressListModel *model in self.expressArray) {
        model.isSelected = NO;
    }
    DZExpressListModel *model = self.expressArray[indexPath.row];
    model.isSelected = YES;
    
    [self.expressView.tableView reloadData];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.expressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:expressIdentiferId];
    if (!cell) {
        cell = [DZExpressCell viewFormNib];
    }
    DZExpressListModel *model = self.expressArray[indexPath.row];
    [cell fillData:model];
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getExpressList" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetExpressListModel *model = [DZGetExpressListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.expressArray = model.data;
            [self.expressView.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----
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

@end
