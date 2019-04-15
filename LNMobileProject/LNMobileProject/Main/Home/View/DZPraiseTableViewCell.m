//
//  DZPraiseTableViewCell.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/28.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZPraiseTableViewCell.h"

@implementation DZPraiseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellName=@"DZPraiseTableViewCell";
    DZPraiseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell=[[DZPraiseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        UIImageView *iconImageV = [[UIImageView alloc]init];
        iconImageV.image = [UIImage imageNamed:@"avatar_grey"];
        [self.contentView addSubview:iconImageV];
        iconImageV.userInteractionEnabled = YES;
        self.iconImageV = iconImageV;
        iconImageV.layer.cornerRadius = 30;
        iconImageV.layer.masksToBounds = YES;
        [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(10);
            make.left.mas_equalTo(self.contentView).mas_offset(20);
            make.width.height.mas_equalTo(60);
        }];
        
        //名称
        UILabel *nameL = [[UILabel alloc]init];
        self.nameL = nameL;
        nameL.font = [UIFont systemFontOfSize:14];
        nameL.textColor = [UIColor colorWithRed:250/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        [self.contentView addSubview:nameL];
        nameL.preferredMaxLayoutWidth = KScreenWidth - 105;
        nameL.text = @"张大美";
        [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageV.mas_right).mas_offset(10);
            make.top.mas_equalTo(iconImageV.mas_top).mas_offset(10);
            make.right.mas_equalTo(self.contentView).mas_offset(-15);
        }];
        
        //时间
        UILabel *timeL = [[UILabel alloc]init];
        self.timeL = timeL;
        [self.contentView addSubview:timeL];
        //时间
        timeL.font = [UIFont systemFontOfSize:12];
        timeL.textColor = [UIColor colorWithRed:240/255.0 green:180/255.0 blue:178/255.0 alpha:1];
        
        timeL.text = @"山东-临溪-经济开发区  2018-11-2 17:57:11";
        timeL.preferredMaxLayoutWidth = KScreenWidth - 105;
        [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameL);
            make.bottom.mas_equalTo(iconImageV.mas_bottom).mas_offset(-10);
            make.width.mas_equalTo(nameL);
        }];
        
        //话题
        self.topicLabel =[[UILabel alloc]initWithFrame:CGRectZero];
        self.topicLabel.text = @"孩子感冒发烧可是愁坏了爸妈了，读了这篇文章收益颇深，感谢感谢";
        [self.contentView addSubview:self.topicLabel];
        self.topicLabel.preferredMaxLayoutWidth = KScreenWidth - 105;
        self.topicLabel.numberOfLines=0;
        [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameL);
            make.right.mas_equalTo(nameL);
            make.top.mas_equalTo(iconImageV.mas_bottom).mas_offset(10);
        }];
        self.topicLabel.font = [UIFont systemFontOfSize:14];
        self.topicLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
       
        UIView *bottomLineV = [[UIView alloc]init];
        [self.contentView addSubview:bottomLineV];
        bottomLineV.backgroundColor =[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
        [bottomLineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.topicLabel.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    
    
    return self;
}

- (void)setList:(JSCommentListData *)list
{
    _list = list;
     [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:FULL_URL(list.head_pic)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nameL.text = list.nickname;
    self.timeL.text = [NSString stringWithFormat:@"%@",[list.add_time timeFormatterYMDHMS]];
    self.topicLabel.text = list.content;
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
