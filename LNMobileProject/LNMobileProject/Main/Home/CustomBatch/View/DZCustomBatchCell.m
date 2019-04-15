//
//  DZTimeLimitCell.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCustomBatchCell.h"
#import "DZGoodsModel.h"
@interface DZCustomBatchCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *batchLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (nonatomic, strong) DZGoodsModel *model;
@end

@implementation DZCustomBatchCell

- (void)configView:(DZGoodsModel *)model {
    _model = model;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.goods_img)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    
    self.nameLabel.text = model.goods_name;
    self.batchLabel.text = [NSString stringWithFormat:@"%@件起批",model.basic_amount];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.pack_price];
    self.buyButton.layer.masksToBounds = YES;
    self.buyButton.layer.cornerRadius = 2;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.goodsImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buyAction:(id)sender {
    if(self.model) {
        [self.clickSubject sendNext:self.model.goods_id];
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -=4;
    [super setFrame:frame];
}

@end
