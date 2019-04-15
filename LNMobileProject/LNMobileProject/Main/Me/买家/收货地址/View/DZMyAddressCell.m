//
//  DZMyAddressCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMyAddressCell.h"

@interface DZMyAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation DZMyAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)fillName:(NSString *)name mobile:(NSString *)mobile address:(NSString *)address isDefault:(BOOL)isDefault{
    self.nameLabel.text = name;
    self.mobileLabel.text = mobile;
    self.addressLabel.text = address;
    
    if (isDefault) {
        self.defaultLabel.textColor = HEXCOLOR(0xff7722);
        self.defaultImageView.image = [UIImage imageNamed:@"my_address_icon_s"];
    }else{
        self.defaultLabel.textColor = HEXCOLOR(0x333333);
        self.defaultImageView.image = [UIImage imageNamed:@"my_address_icon_n"];
    }
}

@end
