//
//  DZExpressDetailCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZExpressDetailCell.h"

@interface DZExpressDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topLine;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *dotImageView;

@end

@implementation DZExpressDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZTracesModel *)model type:(NSInteger)type{
    self.infoLabel.text = model.AcceptStation;
    self.dateLabel.text = model.AcceptTime;
    
    if (type == 0) {
        self.topLine.hidden = NO;
        self.bottomLine.hidden = NO;
        self.dotImageView.image = [UIImage imageNamed:@"order_logistics_img_n"];
    }else if (type == -1){
        self.topLine.hidden = NO;
        self.bottomLine.hidden = YES;
        self.dotImageView.image = [UIImage imageNamed:@"order_logistics_img_n"];
    }else if (type == 1){
        self.topLine.hidden = YES;
        self.bottomLine.hidden = NO;
        self.dotImageView.image = [UIImage imageNamed:@"order_logistics_img_s"];
    }
}

@end
