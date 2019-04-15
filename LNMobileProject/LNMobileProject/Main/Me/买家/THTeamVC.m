//
//  THTeamVC.m
//  LNMobileProject
//
//  Created by 童浩 on 2019/3/18.
//  Copyright © 2019 Liuniu. All rights reserved.
//

#import "THTeamVC.h"
#import "DateTimePickerView.h"

@interface THTeamVC ()
@property(nonatomic,strong) DateTimePickerView *pickerView;

@end

@implementation THTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的团队";
    self.pickerView = [[DateTimePickerView alloc] init];
    self.pickerView.ischaoguodangqianshijian = NO;
    [self.pickerView setCurrentDate:[NSDate date]];
    self.pickerView.pickerViewMode = DatePickerViewMonthMode;
    __weak THTeamVC *men = self;
    self.pickerView.block = ^(NSString *date) {
        NSArray *array = [date componentsSeparatedByString:@" "];
        NSArray *array1 = [array.firstObject componentsSeparatedByString:@"-"];
        NSString *str = [NSString stringWithFormat:@"%@-%@",array1.firstObject,array1[1]];
        men.dateStr = str;
        [men wangluohuoquAction];
        [men.xuanzeyuefenButton setTitle:[NSString stringWithFormat:@"选择月份:%@",men.dateStr] forState:UIControlStateNormal];
    };
    [kKeyWindow addSubview:self.pickerView];
    [self.xuanzeyuefenButton addTarget:self action:@selector(xuanzeyuefenAction) forControlEvents:k_BuuttonAction];
    [self wangluohuoquAction];
    [self.xuanzeyuefenButton setTitle:[NSString stringWithFormat:@"选择月份:%@",self.dateStr] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
- (void)wangluohuoquAction {
    [SVProgressHUD show];
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/myteam" parameters:@{@"token":[DPMobileApplication sharedInstance].loginUser.token,@"month":self.dateStr}];
//    __weak typeof(self) weakSelf = self;
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"status"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDic = dict[@"data"];
            self.leijixiaofeiLabel.text = [NSString stringWithFormat:@"%.2lf",[dataDic[@"all_consume"] doubleValue]];
            self.yuexiaofeiLabel.text = [NSString stringWithFormat:@"%.2lf",[dataDic[@"month_consume"] doubleValue]];
            self.leijiJiangliLabel.text = [NSString stringWithFormat:@"%.2lf",[dataDic[@"all_reward"] doubleValue]];
            self.yuejiangliLabel.text = [NSString stringWithFormat:@"%.2lf",[dataDic[@"month_reward"] doubleValue]];
        }else{
            [SVProgressHUD showErrorWithStatus:dict[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络获取失败"];
    }];
}
- (void)xuanzeyuefenAction {
    [self.pickerView showDateTimePickerView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
