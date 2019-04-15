//
//  DZShopCommentCell.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZShopCommentCell : UITableViewCell
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) RACSubject *imageSubject;
- (void)configView:(id)model;

@end
