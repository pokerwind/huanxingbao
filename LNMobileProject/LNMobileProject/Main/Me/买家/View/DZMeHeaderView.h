//
//  DZMeHeaderView.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DZMeHeaderDelegate <NSObject>

- (void)didClickHeaderAtIndex:(NSInteger)index;

@end

@interface DZMeHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UILabel *unPaidCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unSendCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unRecCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unCommentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unSuccessCountLabel;

@property (weak, nonatomic) id <DZMeHeaderDelegate>delegate;

@end
