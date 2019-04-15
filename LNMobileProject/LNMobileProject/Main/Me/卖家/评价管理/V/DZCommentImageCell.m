//
//  DZCommentImageCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/10/24.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCommentImageCell.h"

@interface DZCommentImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end

@implementation DZCommentImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)fillImg:(NSString *)img{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, img]] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
}

@end
