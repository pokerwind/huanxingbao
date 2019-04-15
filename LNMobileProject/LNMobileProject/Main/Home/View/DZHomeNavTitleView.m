//
//  DZHomeNavTitleView.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZHomeNavTitleView.h"

@implementation DZHomeNavTitleView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = BorderColor.CGColor;
    
    self.searchButton.layer.masksToBounds = YES;
    self.searchButton.layer.cornerRadius = 4;
    self.searchButton.layer.borderColor = HEXCOLOR(0xebebeb).CGColor;
    self.searchButton.layer.borderWidth = 0.5;
    
    self.numLabel.layer.masksToBounds = YES;
    self.numLabel.layer.cornerRadius = 3;
    self.numLabel.hidden = YES;
    //初始化时更新，收到通知也更新一下
    [self updateMessageCount];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReceiveMessage" object:nil] subscribeNext:^(id x) {
        [self updateMessageCount];
    }];

}

- (IBAction)goMap:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

- (void)updateMessageCount {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    int count = 0;
    for (EMConversation *em in conversations) {
        count += [em unreadMessagesCount];
    }
    if (count > 0) {
        self.numLabel.hidden = NO;
//        self.numLabel.text = [NSString stringWithFormat:@"%d",count];
        if (count>99) {
//            self.numLabel.text = @"99+";
        }
    } else {
        self.numLabel.hidden = YES;
    }
}

- (void)setUnReadNum:(NSInteger)unReadNum
{
    _unReadNum = unReadNum;
    if (unReadNum > 0) {
        self.numLabel.hidden = NO;
//        self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)unReadNum];
        if (unReadNum>99) {
//            self.numLabel.text = @"99+";
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
