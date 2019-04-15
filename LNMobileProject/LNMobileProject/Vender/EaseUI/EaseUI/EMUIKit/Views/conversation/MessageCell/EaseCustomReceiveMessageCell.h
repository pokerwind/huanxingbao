//
//  EaseCustomReceiveMessageCell.h
//  yunyue
//
//  Created by net apa on 2017/3/3.
//  Copyright © 2017年 zhanlijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EaseCustomReceiveMessageCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *headBtn;

@property (nonatomic, weak) IBOutlet UIImageView *headImage;
@property (nonatomic, weak) IBOutlet UIImageView *bgImage;
@property (nonatomic, weak) IBOutlet UIImageView *shareImage;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UILabel *nicknameLabel;

@property (nonatomic, weak) IBOutlet UIButton *selectBtn;
@end
