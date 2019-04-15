//
//  DZCircleNavTitleView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/8.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCircleNavTitleView.h"

@implementation DZCircleNavTitleView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.numLabel.layer.masksToBounds = YES;
    self.numLabel.layer.cornerRadius = 6;
    self.numLabel.hidden = YES;
    //初始化时更新，收到通知也更新一下
    [self updateMessageCount];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReceiveMessage" object:nil] subscribeNext:^(id x) {
        [self updateMessageCount];
    }];
}

- (void)updateMessageCount {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    int count = 0;
    for (EMConversation *em in conversations) {
        count += [em unreadMessagesCount];
    }
    if (count > 0) {
        self.numLabel.hidden = NO;
        self.numLabel.text = [NSString stringWithFormat:@"%d",count];
        if (count>99) {
            self.numLabel.text = @"99+";
        }
    } else {
        self.numLabel.hidden = YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
