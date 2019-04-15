//
//  DZCartCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/31.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCartCell.h"
#import "DZCartInnerCell.h"

@interface DZCartCell ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (strong, nonatomic) JSShopCartList *model;

@end

@implementation DZCartCell
static NSString *identifier = @"DZCartInnerCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.goods?self.model.goods.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZCartInnerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [DZCartInnerCell viewFormNib];
    }
    [cell fillData:self.model.goods[indexPath.row]];
    [cell.selectionButton addTarget:self action:@selector(selectionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    cell.modifyButton.tag = indexPath.row;
    [cell.modifyButton addTarget:self action:@selector(modifyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickGood:)]) {
        JSShopCartGoods *model = self.model.goods[indexPath.row];
        [self.delegate didClickGood:model.goods_id];
    }
}

- (void)selectionButtonAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectionChanged)]) {
        [self.delegate selectionChanged];
    }
}

- (void)modifyButtonAction:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(modifyFrameWithGroup:goodIndex:)]) {
        [self.delegate modifyFrameWithGroup:self.tag goodIndex:btn.tag];
    }
}

- (void)fillData:(JSShopCartList *)model{
    self.shopNameLabel.text = model.shop_name;
    self.model = model;
    
    [self.tableView reloadData];
}

@end
