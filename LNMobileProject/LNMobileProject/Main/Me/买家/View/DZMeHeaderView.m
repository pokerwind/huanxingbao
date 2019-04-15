//
//  DZMeHeaderView.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMeHeaderView.h"
#import "CALayer+DZXIBConfiguration.h"

@implementation DZMeHeaderView

- (IBAction)infoButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHeaderAtIndex:)]) {
        [self.delegate didClickHeaderAtIndex:0];
    }
}

- (IBAction)orderButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHeaderAtIndex:)]) {
        [self.delegate didClickHeaderAtIndex:1];
    }
}

- (IBAction)unPaidButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHeaderAtIndex:)]) {
        [self.delegate didClickHeaderAtIndex:2];
    }
}

- (IBAction)unSendButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHeaderAtIndex:)]) {
        [self.delegate didClickHeaderAtIndex:3];
    }
}

- (IBAction)unRecButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHeaderAtIndex:)]) {
        [self.delegate didClickHeaderAtIndex:4];
    }
}

- (IBAction)unCommentButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHeaderAtIndex:)]) {
        [self.delegate didClickHeaderAtIndex:5];
    }
}

- (IBAction)unSuccessButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHeaderAtIndex:)]) {
        [self.delegate didClickHeaderAtIndex:6];
    }
}
@end
