//
//  DZShopCollectionCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopCollectionCell.h"

@interface DZShopCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation DZShopCollectionCell

- (void)fillData:(NSDictionary *)dict{
    if ([dict isKindOfClass:[NSDictionary class]] && dict.allKeys.count) {
        if ([dict.allKeys containsObject:@"shop_logo"]) {
            NSString *shopLogo = [NSString stringWithFormat:@"shop_logo"];
            if (shopLogo.length) {
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, dict[@"shop_logo"]]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
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

@end
