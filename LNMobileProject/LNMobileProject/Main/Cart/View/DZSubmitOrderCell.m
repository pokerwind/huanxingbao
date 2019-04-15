//
//  DZSubmitOrderCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSubmitOrderCell.h"
#import "DZSubmitOrderInnerCell.h"

@interface DZSubmitOrderCell ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *shopLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *expressPriceLabel;

@property (strong, nonatomic) DZCartConfirmShopModel *model;

@end

@implementation DZSubmitOrderCell

static NSString *identifier = @"DZSubmitOrderInnerCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.messageTextField.hidden = YES;
    self.layoutC.constant = 0.001;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.goods_list?self.model.goods_list.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 118;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZSubmitOrderInnerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [DZSubmitOrderInnerCell viewFormNib];
    }
    [cell fillData:self.model.goods_list[indexPath.row]];
    cell.modifyButton.tag = indexPath.row;
    [cell.modifyButton addTarget:self action:@selector(modifyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)modifyButtonAction:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(modifyFrameWithGroup:goodIndex:)]) {
        [self.delegate modifyFrameWithGroup:self.tag goodIndex:btn.tag];
    }
}

- (void)fillData:(DZCartConfirmShopModel *)model{
    self.shopLabel.text = model.shop_name;
    self.expressPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.shop_express_price];
    self.model = model;
    
    [self.tableView reloadData];
}
@end
