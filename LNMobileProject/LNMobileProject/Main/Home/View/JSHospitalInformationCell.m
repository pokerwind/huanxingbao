//
//  JSHospitalInformationCell.m
//  iOSMedical
//
//  Created by 高盛通 on 2018/12/3.
//  Copyright © 2018年 ZJXxiaoqiang. All rights reserved.
//

#import "JSHospitalInformationCell.h"

@implementation JSHospitalInformationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellName=@"JSHospitalInformationCell";
    JSHospitalInformationCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell=[[JSHospitalInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
//        self.nameL = [[UILabel alloc]init];
//        [self.contentView addSubview:self.nameL];
//        self.nameL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//        self.nameL.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];;
//        self.nameL.text = @"著名主持人李咏，癌症该如何预防？";
        
        self.imageV = [[UIImageView alloc]init];
        self.imageV.layer.cornerRadius = 5;
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        self.imageV.layer.masksToBounds = YES;
        self.imageV.image = [UIImage imageNamed:@"jifenduihuanTop"];
        [self.contentView addSubview:self.imageV];
        
        self.contentL = [[UILabel alloc]init];
        self.contentL.numberOfLines = 2;
        [self.contentL sizeToFit];
        self.contentL.text = @"癌症并不可怕，摆正心态，早预防、早诊断、早治疗才是对抗癌症最好对办法";
        [self.contentView addSubview:self.contentL];
        _contentL.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
        _contentL.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
        
        self.seeDetailL = [[UILabel alloc]init];
        self.seeDetailL.text = @"爸爸妈妈小心宝宝中招！";
        self.seeDetailL.numberOfLines = 2;
        [self.contentView addSubview:self.seeDetailL];
        self.seeDetailL.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        self.seeDetailL.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        
//        self.arrowImageV = [[UIImageView alloc]init];
//        self.arrowImageV.image = [UIImage imageNamed:@"gooddetail_icon_more"];
//        [self.contentView addSubview:self.arrowImageV];
        
        
    }
    return self;
}

- (void)clickSingle:(UISwitch *)swi
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

//    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView).mas_offset(13);
//        make.top.mas_equalTo(self.contentView).mas_offset(17);
//        make.right.mas_equalTo(self.contentView).mas_offset(-13);
//    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo((KScreenWidth - 26 - 30) *0.52);
    }];
    
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(13);
        make.top.mas_equalTo(self.imageV.mas_bottom).mas_offset(15);
        make.right.mas_equalTo(self.contentView).mas_offset(-13);
    }];
    
    [self.seeDetailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(13);
        make.top.mas_equalTo(self.contentL.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(self.contentView).mas_offset(-13);
    }];
    
    
}

- (void)setModel:(JSCircleListData *)model
{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.thumb_img)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    
    self.contentL.text = model.title;
    self.seeDetailL.text = model.introduce;
}

//- (void)setList:(JSHospitalInfomationNewslist *)list
//{
//    _list = list;
//    self.nameL.text = list.title;
//    [self.imageV sd_setImageWithURL:[NSURL URLWithString:list.filesDO.filePath] placeholderImage:KImageNamed(@"dt") options:0];
//    self.contentL.text = list.summarize;
//}

@end
