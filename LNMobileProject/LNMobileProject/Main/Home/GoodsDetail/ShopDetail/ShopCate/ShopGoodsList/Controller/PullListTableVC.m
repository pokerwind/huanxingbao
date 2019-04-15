//
//  PullListTableVC.m
//  ShopMobile
//
//  Created by LiuNiu-MacMini-YQ on 2017/3/13.
//  Copyright © 2017年 liuniukeji. All rights reserved.
//

#import "PullListTableVC.h"
#import "PullListCell.h"
#import "YZPullDownMenu.h"

@interface PullListTableVC ()

@end

@implementation PullListTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //_selectedCol = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"PullListCell" bundle:nil]
         forCellReuseIdentifier:@"PullListCell"];
    [self.tableView setSeparatorColor:CellSeparatorColor];
    self.tableView.backgroundColor = BgColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickMenu:) name:YZUpdateMenuTitleNote object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)setSelectedCol:(NSInteger)selectedCol {
    _selectedCol = selectedCol;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PullListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PullListCell" forIndexPath:indexPath];
    NSDictionary *cellDict = self.dataSoure[indexPath.row];
    
    cell.cellTitleLabel.text = cellDict[@"name"];
    
//    if (indexPath.row == 0) {
//        [cell setSelected:YES animated:NO];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedCol = indexPath.row;

    
    // 选中当前
//    PullListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *cellDict = self.dataSoure[indexPath.row];
    // 更新菜单标题
    //[[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":cellDict[@"short"],@"type":cellDict[@"type"]}];
    //增加返回索引？
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":cellDict[@"short"],@"type":cellDict[@"type"],@"index":@(indexPath.row)}];
    
    
}

- (void)clickMenu:(NSNotification *)info {
    
    NSDictionary *userInfo = info.userInfo;
    NSString *type = userInfo[@"type"];
    NSNumber *num = userInfo[@"index"];
    NSInteger index = [num integerValue];
    if ([type isEqualToString:@"price"] && index == 0) {
        _selectedCol = index;
    }
    NSString *title = userInfo[@"title"];

    if ([title isEqualToString:@"综合排序"]) {
        
    } else if ([title isEqualToString:@"价格从低到高"]) {
    
    } else if ([title isEqualToString:@"价格从高到低"]) {
    
    }
}


@end
