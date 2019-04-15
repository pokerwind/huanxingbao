//
//  PullDoubleTableVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "PullDoubleTableVC.h"
#import "PullListCell.h"
#import "YZPullDownMenu.h"

@interface PullDoubleTableVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *leftTable;
@property (nonatomic, strong) UITableView *rightTable;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedRow;
@end

@implementation PullDoubleTableVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = 0;
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.leftTable];
    [self.view addSubview:self.rightTable];
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

#pragma mark - ---- 代理相关 ----
#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger tag = tableView.tag;
    
    if (tag == 1) {
        //左边的
        return self.indexArray.count;
    } else {
        NSArray *list = self.listArrays[self.selectedIndex];
        return list.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PullListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PullListCell" forIndexPath:indexPath];
    NSInteger tag = tableView.tag;
    if (tag == 1) {
        cell.cellTitleLabel.text = self.indexArray[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        NSArray *list = self.listArrays[self.selectedIndex];
        cell.cellTitleLabel.text = list[indexPath.row];
        cell.backgroundColor = BgColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tag = tableView.tag;
    if (tag == 1) {
        self.selectedIndex = indexPath.row;
        [self.rightTable reloadData];
    } else {
        NSArray *list = self.listArrays[self.selectedIndex];
        NSString *title = list[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":title,@"type":@"attr",@"index":@(indexPath.row)}];
    }
}
#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.leftTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.width.mas_equalTo(125);
    }];
    
    [self.rightTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_offset(0);
        make.left.equalTo(self.leftTable.mas_right);
    }];
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)leftTable {
    if(!_leftTable) {
        _leftTable = [[UITableView alloc] init];
        _leftTable.tag = 1;
        _leftTable.delegate = self;
        _leftTable.dataSource = self;
        [_leftTable registerNib:[UINib nibWithNibName:@"PullListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PullListCell"];
        _leftTable.tableFooterView = [UIView new];
        _leftTable.backgroundColor = [UIColor clearColor];
    }
    return _leftTable;
}

- (UITableView *)rightTable {
    if(!_rightTable) {
        _rightTable = [[UITableView alloc] init];
        _rightTable.tag = 2;
        _rightTable.delegate = self;
        _rightTable.dataSource = self;
        [_rightTable registerNib:[UINib nibWithNibName:@"PullListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PullListCell"];
        _rightTable.backgroundColor = HEXCOLOR(0xf7f7f7);
        _rightTable.backgroundColor = [UIColor clearColor];
        _rightTable.tableFooterView = [UIView new];
    }
    return _rightTable;
}
@end
