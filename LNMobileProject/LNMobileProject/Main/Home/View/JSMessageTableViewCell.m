//
//  JSMessageTableViewCell.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/29.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "JSMessageTableViewCell.h"

@implementation JSMessageTableViewCell

+ (JSMessageTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *identy = @"JSMessageTableViewCell";
    JSMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:identy owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setList:(JSMessageListData *)list
{
    _list = list;
    self.nameL.text = list.content;
    self.timeL.text = list.add_time;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
