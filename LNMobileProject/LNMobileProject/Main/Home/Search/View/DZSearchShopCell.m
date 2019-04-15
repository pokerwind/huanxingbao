//
//  DZSearchShopCell.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSearchShopCell.h"
#import "DZShopModel.h"

@interface DZSearchShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *suppLabel;


@end

@implementation DZSearchShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 16;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;
    frame.size.height -=5;
    [super setFrame:frame];
}

- (void)configView:(DZShopModel *)model {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.shop_logo)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nameLabel.text = model.shop_name;
    self.addressLabel.text = model.adress;
    if(model.add_time.length > 10) {
        model.add_time = [model.add_time substringToIndex:10];
    }
    self.timeLabel.text = model.add_time;
    self.saleNumLabel.text = model.goods_counts;
    self.updateLabel.text = model.month_goods_count;
    self.suppLabel.text = model.supplement;
    
}

@end
