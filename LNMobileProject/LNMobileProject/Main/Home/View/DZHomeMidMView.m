//
//  DZHomeMidMView.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/18.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZHomeMidMView.h"

@implementation DZHomeMidMView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnClick:(UIButton *)sender {
    if (self.block) {
        self.block(self.bannerModel);
    }
}

- (void)setBannerModel:(DZBannerModel *)bannerModel
{
    _bannerModel = bannerModel;
    [self.adImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,bannerModel.content]] placeholderImage:[UIImage imageNamed:@"avatar_grey"] options:0];
}
@end
