//
//  DZDZSellerProblemOrderDetailVC.m（文件名称）
//  LNMobileProject（工程名称）
//
//  Created by  六牛科技 on 2017/9/28.（创建用户及时间）
//
//  山东六牛网络科技有限公司 https://liuniukeji.com
//

#import "DZSellerProblemOrderDetailVC.h"

@interface DZSellerProblemOrderDetailVC ()

@end

@implementation DZSellerProblemOrderDetailVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款详情";
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - ---- 代理相关 ----
#pragma mark UITableView

#pragma mark - ---- 用户交互事件 ----

#pragma mark - ---- 私有方法 ----

#pragma mark - ---- 公共方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    //    Maronsy
}

#pragma mark - --- getters 和 setters ----

@end
