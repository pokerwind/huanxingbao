//
//  DZAddMyAddressVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/18.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZAddMyAddressVC.h"
#import "DZProvinceSelectionVC.h"
#import "DZDistrictSelectionVC.h"

#import "UITextView+ZWPlaceHolder.h"

#import "DPMobileApplication.h"
#import <IQTextView.h>

@interface DZAddMyAddressVC ()<DZDistrictSelectionVCDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;

@property (weak, nonatomic) IBOutlet IQTextView *textViewAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress;

@property (nonatomic, strong) DZMyAddressItemModel *model;
//保存用户选择的值
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *district;

@end

@implementation DZAddMyAddressVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.addressId.length) {
        self.title = @"编辑收货地址";
        [self fillData];
    }else{
        self.title = @"新增收货地址";
    }
    self.addressTextView.placeholder = @"";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.textViewAddress.placeholder = @"请输入地址或粘贴地址";
    self.btnAddress.layer.cornerRadius = 5;
    self.btnAddress.clipsToBounds = YES;
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (void)rightItemAction{
    if (!self.nameTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"收货人姓名不能为空"];
        return;
    }
    if (!self.mobileTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"联系电话不能为空"];
        return;
    }
    if ([self.areaButton.titleLabel.text isEqualToString:@"请选择"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择所在地区"];
        return;
    }
    
    NSDictionary *params;
    if (self.model) {
        NSInteger is_default;
        if (self.selectionButton.selected) {
            is_default = 1;
        }else{
            is_default = 0;
        }
        params = @{@"address_id":self.model.address_id, @"consignee":self.nameTextField.text, @"address":self.addressTextView.text, @"province":self.province, @"city":self.city, @"district":self.district, @"mobile":self.mobileTextField.text, @"is_default":@(is_default)};
    }else{
        NSInteger is_default;
        if (self.selectionButton.selected) {
            is_default = 1;
        }else{
            is_default = 0;
        }
        params = @{@"consignee":self.nameTextField.text, @"address":self.addressTextView.text, @"province":self.province, @"city":self.city, @"district":self.district, @"mobile":self.mobileTextField.text, @"is_default":@(is_default)};
    }
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/addEditAddress" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:model.info];
            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateAddress)]) {
                [self.delegate didUpdateAddress];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (IBAction)selectionButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.selectionButton setImage:[UIImage imageNamed:@"my_address_icon_s"] forState:UIControlStateNormal];
    }else{
        [self.selectionButton setImage:[UIImage imageNamed:@"my_address_icon_n"] forState:UIControlStateNormal];
    }
}

- (IBAction)areaButtonAction:(id)sender {
    DZProvinceSelectionVC *vc = [DZProvinceSelectionVC new];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.districtDelegateVC = self;
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}


/**
 自动识别地址
 */
- (IBAction)addressBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (self.textViewAddress.text.length == 0) {
        [self showHint:self.textViewAddress.placeholder];
        return;
    }
    
    [self showHudInView:self.view hint:@"正在识别"];
    [[[LNetWorkAPI alloc] initWithUrl:@"Api/UserCenterApi/smartAddress" parameters:@{@"address":self.textViewAddress.text}] startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self hideHud];
        if ([request.responseJSONObject[@"status"] integerValue] == 1) {
            NSDictionary *data = request.responseJSONObject[@"data"];
            NSLog(@"%@",data);
            self.nameTextField.text = [NSString stringWithFormat:@"%@",data[@"name"]];
            self.addressTextView.text = [NSString stringWithFormat:@"%@",data[@"address"]];
            self.mobileTextField.text = [NSString stringWithFormat:@"%@",data[@"mobile"]];
            NSArray *thr_address = data[@"thr_address"];
            if (thr_address.count >= 1) {
                self.province = [NSString stringWithFormat:@"%@",thr_address[0][@"region_name"]];
            }
            if (thr_address.count >= 2) {
                self.city = [NSString stringWithFormat:@"%@",thr_address[1][@"region_name"]];
            }else {
                self.city = @"";
            }
            if (thr_address.count >= 3) {
                self.district = [NSString stringWithFormat:@"%@",thr_address[2][@"region_name"]];
            }else {
                self.district = @"";
            }
            [self.areaButton setTitle:[NSString stringWithFormat:@"%@%@%@",self.province,self.city,self.district] forState:0];
        }else {
            [self showHint:request.responseJSONObject[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self hideHud];
        [self showHint:error.domain];
    }];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- DZDistrictSelectionVCDelegate ----
- (void)didSelectionProvince:(NSString *)province city:(NSString *)city district:(NSString *)district{
    [self.areaButton setTitle:[NSString stringWithFormat:@"%@%@%@", province, city, district] forState:UIControlStateNormal];
    self.province = province;
    self.city = city;
    self.district = district;
}

#pragma mark - ---- 私有方法 ----
- (void)fillData{
    NSDictionary *params = @{@"address_id":self.addressId};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getAddressInfo" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        self.model = [DZMyAddressItemModel objectWithKeyValues:request.responseJSONObject[@"data"]];
        NSString *status = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"status"]];
        if ([status isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            self.nameTextField.text = self.model.consignee;
            self.mobileTextField.text = self.model.mobile;
            [self.areaButton setTitle:[NSString stringWithFormat:@"%@%@%@", self.model.province, self.model.city, self.model.district] forState:UIControlStateNormal];
            self.addressTextView.text = self.model.address;
            self.province = self.model.province;
            self.city = self.model.city;
            self.district = self.model.district;
            if (self.model.is_default) {
                [self selectionButtonAction:self.selectionButton];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:request.responseJSONObject[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
    
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        _rightItem.tintColor = HEXCOLOR(0xff7722);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}




@end

