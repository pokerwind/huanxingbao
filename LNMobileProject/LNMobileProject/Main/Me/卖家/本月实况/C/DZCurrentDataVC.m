//
//  DZCurrentDataVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/24.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCurrentDataVC.h"

@interface DZCurrentDataVC ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyerLabel;

@end

@implementation DZCurrentDataVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"本月实况";
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 代理相关 ----

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/moneyStatistical" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = request.responseJSONObject;
        if ([dic[@"status"] integerValue] == 1) {
            self.dateLabel.text = dic[@"data"][@"now"];
            self.moneyLabel.text = dic[@"data"][@"real_pay_amounts"];
            self.visitorLabel.text = dic[@"data"][@"click_counts"];
            self.buyerLabel.text = [NSString stringWithFormat:@"%@", dic[@"data"][@"pay_users"]];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - --- getters 和 setters ----

@end
