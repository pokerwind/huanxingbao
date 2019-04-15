//
//  DZGoodsDetailIntroView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/10/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGoodsDetailIntroView.h"
#import "DZGoodsDetailIntroCell.h"
#import "DZGoodsDetailIntroModel.h"

#define kIntroCell @"DZGoodsDetailIntroCell"

@interface DZGoodsDetailIntroView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DZGoodsDetailIntroView

- (void)awakeFromNib {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:kIntroCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kIntroCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.tableView reloadData];
}

#pragma  mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZGoodsDetailIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:kIntroCell];
    DZGoodsDetailIntroModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.name;
    cell.specLabel.text = model.spec;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 24;
}

@end
