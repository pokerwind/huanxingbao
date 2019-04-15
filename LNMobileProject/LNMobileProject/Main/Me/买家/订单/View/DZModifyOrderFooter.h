//
//  DZModifyOrderFooter.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZModifyOrderFooter : UIView

@property (weak, nonatomic) IBOutlet UIButton *expressButton;
@property (weak, nonatomic) IBOutlet UITextField *expressTextField;
@property (weak, nonatomic) IBOutlet UILabel *expressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
