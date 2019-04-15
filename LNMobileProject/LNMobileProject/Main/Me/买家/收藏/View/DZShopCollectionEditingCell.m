//
//  DZShopCollectionEditingCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopCollectionEditingCell.h"

@interface DZShopCollectionEditingCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation DZShopCollectionEditingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)fillData:(NSDictionary *)dict{
    if ([dict isKindOfClass:[NSDictionary class]] && dict.allKeys.count) {
        if ([dict.allKeys containsObject:@"shop_logo"]) {
            NSString *shopLogo = dict[@"shop_logo"];
            if (shopLogo.length) {
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, dict[@"shop_logo"]]]];
            }
        }
        if ([dict.allKeys containsObject:@"shop_name"]) {
            self.nameLabel.text = dict[@"shop_name"];
        }
        if ([dict.allKeys containsObject:@"province"] && [dict.allKeys containsObject:@"city"] && [dict.allKeys containsObject:@"address"]) {
            self.addressLabel.text = [NSString stringWithFormat:@"%@·%@·%@", dict[@"province"], dict[@"city"], dict[@"address"]];
        }
    }
}

- (void)setEditingState:(NSInteger)state{
    if (state == 1) {
        self.selectionImageView.image = [UIImage imageNamed:@"group_checkbox_s"];
    }else{
        self.selectionImageView.image = [UIImage imageNamed:@"cart_icon_checkbox_n"];
    }
}

@end
