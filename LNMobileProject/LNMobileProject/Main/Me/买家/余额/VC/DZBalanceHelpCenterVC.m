//
//  DZBalanceHelpCenterVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZBalanceHelpCenterVC.h"

#import "DZMyBalanceHelpCell.h"

@interface DZBalanceHelpCenterVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DZBalanceHelpCenterVC

static  NSString  *CellIdentiferId = @"DZMyBalanceHelpCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助中心";
    
    [self.view addSubview:self.tableView];
    
    [self setSubViewsLayout];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - --- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZMyBalanceHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZMyBalanceHelpCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

@end
