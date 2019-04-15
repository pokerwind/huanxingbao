//
//  DZSearchVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/8.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSearchVC.h"
#import "DZSearchNavView.h"
#import "DZSearchResultVC.h"
#import "DZSearchShopResultVC.h"

@interface DZSearchVC ()<UITextFieldDelegate>
@property (nonatomic, strong) DZSearchNavView *navView;
@end

@implementation DZSearchVC


#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];

    //[self initNavigationBar];
    [self.view addSubview:self.navView];
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

- (void)initNavigationBar {
    self.navigationItem.titleView = self.navView;
}

#pragma mark - ---- 代理相关 ----

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)goodsAction:(id)sender {
    NSString *keyword = self.navView.searchTextFiled.text;
    DZSearchResultVC *vc = [[DZSearchResultVC alloc] init];
    vc.keyword = keyword;
    [self.navigationController pushViewController:vc animated:YES];
}
//- (IBAction)shopAction:(id)sender {
//    NSString *keyword = self.navView.searchTextFiled.text;
//    DZSearchShopResultVC *vc = [[DZSearchShopResultVC alloc] init];
//    vc.keyword = keyword;
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - ---- 私有方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(KNavigationBarH + 0.5);
    }];
}

#pragma mark - --- getters 和 setters ----
- (DZSearchNavView *)navView {
    if(!_navView) {
        _navView = [DZSearchNavView viewFormNib];
        @weakify(self);
        [[_navView.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _navView.searchTextFiled.returnKeyType = UIReturnKeySearch;
        _navView.searchTextFiled.delegate = self;
    }
    return _navView;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self.view endEditing:YES];
    NSString *keyword = self.navView.searchTextFiled.text;
    DZSearchResultVC *vc = [[DZSearchResultVC alloc] init];
    vc.keyword = keyword;
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
}
@end
