//
//  DZCommodityAttributeCell.m
//  LNMobileProject
//
//  Created by liuniukeji on 2017/8/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCommodityAttributeCell.h"
#import "KBXTFocusOnMeStatusPhotosView.h"
@interface DZCommodityAttributeCell ()
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) KBXTFocusOnMeStatusPhotosView *photo;
@end
@implementation DZCommodityAttributeCell
- (void)setModel:(DZCommodityAttributeModel *)model
{
    _model = model;
    self.name.text = model.attr_name;
    self.photo.photos = model.values;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}
- (void)setUI
{
    self.name = [[UILabel alloc] init];
    self.name.backgroundColor = [UIColor grayColor];
    self.photo = [[KBXTFocusOnMeStatusPhotosView alloc] init];
    // 设置代理信号
    self.photo.delegateSignal = [RACSubject subject];
    
    // 订阅代理信号
    [self.photo.delegateSignal subscribeNext:^(id x) {
        UIButton *btn = (UIButton *)x;
        NSLog(@"--%ld点击了通知按钮-%@",(long)btn.tag,btn.titleLabel.text);
    }];

    self.photo.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.photo];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(@0);
        make.width.equalTo(@100);
        make.top.equalTo(@10);
    }];
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(@0);
        make.left.equalTo(@100);
        make.top.equalTo(@10);
    }];
}


@end
