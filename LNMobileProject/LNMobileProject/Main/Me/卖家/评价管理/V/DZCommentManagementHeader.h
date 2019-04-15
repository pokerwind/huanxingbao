//
//  DZCommentManagementHeader.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/25.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZCommentManagementHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *allButton;

- (void)setQualityStarCount:(CGFloat)count;
- (void)setServiceStarCount:(CGFloat)count;
- (void)setExpressStarCount:(CGFloat)count;

@end
