//
//  DZSettingCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/10.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSettingCell.h"

@interface DZSettingCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *line;

@end

@implementation DZSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.line];
    
    [self setSubViewsLayout];
    
    return self;
    
    return self;
}

- (void) setSubViewsLayout{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-12);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.arrowImageView.mas_left).with.offset(5);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.right.bottom.left.mas_equalTo(0);
    }];
}

+ (NSString *)cellIdentifier{
    return NSStringFromClass([self class]);
}

- (void)fillTitle:(NSString *)title detailTitle:(NSString *)detailTitle{
    self.nameLabel.text = title;
    self.detailLabel.text = detailTitle;
}

#pragma mark - --- getters 和 setters ----
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = DefaultTextBlackColor;
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = DefaultTextLightBlackColor;
        _detailLabel.font = [UIFont systemFontOfSize:13];
    }
    return _detailLabel;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_icon_more"]];
    }
    return _arrowImageView;
}

- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = BannerOtherDotColor;
    }
    return _line;
}

@end
