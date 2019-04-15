//
//  DZCommentCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetClientEvaluateModel.h"

@interface DZCommentCell : UITableViewCell

+ (NSString *)cellIdentifier;

- (void)fillData:(DZClientEvaluateModel *)model;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@end
