//
//  DZMessageCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/10.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMessageCell.h"

@interface DZMessageCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *line;


@end

@implementation DZMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.line];
    
    [self setSubViewsLayout];
    
    return self;
}

- (void) setSubViewsLayout{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(12);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView).multipliedBy(1.1);
        make.left.mas_equalTo(self.iconImageView.mas_right).with.offset(13);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).with.offset(8);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(-12);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

+ (NSString *)cellIdentifier{
    return NSStringFromClass([self class]);
}

#pragma mark - --- getters 和 setters ----
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.layer.cornerRadius = 21;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.backgroundColor = HEXCOLOR(0xb3b3b3);
    }
    return _iconImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = DefaultTextBlackColor;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.text = @"系统通知";
    }
    return _nameLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = DefaultTextLightBlackColor;
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.text = @"“Lee工厂店”正在直播！邀你来围观";
    }
    return _detailLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.textColor = DefaultTextLightBlackColor;
        _dateLabel.font = [UIFont systemFontOfSize:11];
        _dateLabel.text = @"6月27日 8:47";
    }
    return _dateLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = BannerOtherDotColor;
    }
    return _line;
}

@end
