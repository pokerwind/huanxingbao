//
//  DZChatroomCell.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/8.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZChatroomCell.h"
#import "DZChatroomModel.h"

@interface DZChatroomCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@end

@implementation DZChatroomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 27;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configView:(DZChatroomModel *)model {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.litpic)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nameLabel.text = model.title;
    self.introLabel.text = model.desc;
    self.timeLabel.text = model.create_time;
    self.numLabel.text = [NSString stringWithFormat:@"%@人",model.max_member];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y +=2;
    frame.size.height -=2;
    [super setFrame:frame];
}

@end
