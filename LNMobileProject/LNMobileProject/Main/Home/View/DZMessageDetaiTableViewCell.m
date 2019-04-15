//
//  DZMessageDetaiTableViewCell.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/30.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZMessageDetaiTableViewCell.h"

@implementation DZMessageDetaiTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellName=@"DZMessageDetaiTableViewCell";
    DZMessageDetaiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell=[[DZMessageDetaiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //话题
        self.topicLabel =[[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.topicLabel];
        self.topicLabel.preferredMaxLayoutWidth = KScreenWidth - 30;
        self.topicLabel.numberOfLines=0;
        [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(15);
            make.right.mas_equalTo(self.contentView).mas_offset(-15);
            make.top.mas_equalTo(self.contentView).mas_offset(10);
            
        }];
        self.topicLabel.font = [UIFont systemFontOfSize:14];
        self.topicLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
        
        
        //时间
        UILabel *timeL = [[UILabel alloc]init];
        self.timeL = timeL;
        timeL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:timeL];
        //时间
        timeL.font = [UIFont systemFontOfSize:12];
        timeL.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];

        timeL.preferredMaxLayoutWidth = KScreenWidth - 30;
        [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(15);
            make.right.mas_equalTo(self.contentView).mas_offset(-15);
            make.top.mas_equalTo(self.topicLabel.mas_bottom).mas_offset(10);
        }];
    
    }
    
    
    return self;
}

- (void)setList:(JSMessageListData *)list
{
    _list = list;
    self.topicLabel.text = list.content;
    self.timeL.text = list.add_time;
}

@end
