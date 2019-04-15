//
//  DZShopListTableViewCell.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/29.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZShopListTableViewCell.h"

@implementation DZShopListTableViewCell

+ (DZShopListTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *identy = @"DZShopListTableViewCell";
    DZShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
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

- (void)setList:(JSShopListData *)list
{
    _list = list;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:FULL_URL(list.shop_real_pic)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.disL.text = [NSString stringWithFormat:@"%@km",list.distance];
    self.nameL.text = list.shop_name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
