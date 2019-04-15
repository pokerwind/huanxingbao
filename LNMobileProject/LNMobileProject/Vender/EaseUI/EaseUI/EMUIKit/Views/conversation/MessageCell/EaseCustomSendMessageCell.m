//
//  EaseCustomSendMessageCell.m
//  yunyue
//
//  Created by net apa on 2017/3/3.
//  Copyright © 2017年 zhanlijun. All rights reserved.
//

#import "EaseCustomSendMessageCell.h"

@implementation EaseCustomSendMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.bgImage setImage:[[UIImage easeImageNamed:@"EaseUIResource.bundle/chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    
    self.headImage.layer.cornerRadius = 20;
    self.headImage.clipsToBounds = YES;
    self.shareImage.layer.masksToBounds = YES;
}


@end
