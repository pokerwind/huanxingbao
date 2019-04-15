//
//  DZFindItemCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZFindItemCell.h"

@interface DZFindItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageVPic;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end

@implementation DZFindItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)fillData:(DZCategoryListModel *)model{
    if (model.image.length) {
        [self.imageVPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.image]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    }
    self.labelName.text = model.cat_name_mobile;
}

@end
