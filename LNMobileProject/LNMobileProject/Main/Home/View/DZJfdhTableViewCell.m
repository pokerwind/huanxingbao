//
//  DZJfdhTableViewCell.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/24.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZJfdhTableViewCell.h"

@implementation DZJfdhTableViewCell

+ (DZJfdhTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *identy = @"DZJfdhTableViewCell";
    DZJfdhTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:identy owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.list.btn == 1) {
        if (self.btnBlock) {
            self.btnBlock(2, self.tag);
        }else{
            
        }
    }else{
        
    }
}

- (void)setList:(JSScoreList *)list
{
    _list = list;
    self.nameL.text = list.goods_name;
    self.jifenL.text = [NSString stringWithFormat:@"%@积分",list.goods_score];
    self.priceL.text = [NSString stringWithFormat:@"¥%@",list.goods_price];
    self.orignalPriceL.text = [NSString stringWithFormat:@"原价：¥%@",list.shop_price];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:FULL_URL(list.goods_img)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    if (list.btn == 1) {
        [self.btn setBackgroundImage:[UIImage imageNamed:@"JSLjdh"] forState:UIControlStateNormal];
    }else{
        [self.btn setBackgroundImage:[UIImage imageNamed:@"JSJfbz"] forState:UIControlStateNormal];
    }
}

@end
