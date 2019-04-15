//
//  DZTimeLimitCell.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZTimeLimitCell.h"
#import "DZTimeLimitDetailModel.h"
@interface DZTimeLimitCell()
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *startNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (nonatomic, strong) DZTimeLimitDetailGoodsModel *model;

@end

@implementation DZTimeLimitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.progressView.layer.cornerRadius = 4;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.layer.borderColor = OrangeColor.CGColor;
    self.progressView.layer.borderWidth = 0.5;
    
    self.picImageView.layer.masksToBounds = YES;
    self.buyButton.layer.masksToBounds = YES;
    self.buyButton.layer.cornerRadius = 2;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configView:(DZTimeLimitDetailGoodsModel *)model {
    self.model = model;
    
    self.nameLabel.text = model.goods_name;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.goods_img)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    
    self.startNumLabel.text = [NSString stringWithFormat:@"%@件起批",model.basic_amount];
    //self.shopPriceLabel.text = ;
    NSString *oldPrice = [NSString stringWithFormat:@"￥%@",model.shop_price];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(0, oldPrice.length)];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:self.shopPriceLabel.textColor range:NSMakeRange(0, oldPrice.length)];
    [self.shopPriceLabel setAttributedText:attri];
    
    self.activityPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.activity_price];
    CGFloat ratioSold;
    if (model.goods_stock.floatValue > 0) {
        ratioSold = model.goods_sale.floatValue/model.goods_stock.floatValue;
    } else {
        ratioSold = 0;
    }
    
    //ratioSold = 0.3;
    self.progressLabel.text = [NSString stringWithFormat:@"已售%d%%",(int)(ratioSold*100)];
    
    self.progressWidthConstraint.constant = 104 *(1-ratioSold);
}

- (IBAction)buyAction:(id)sender {
    if(self.model) {
        [self.model.buySubject sendNext:self.model.goods_id];
    }
}
@end
