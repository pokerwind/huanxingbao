//
//  DZNewsCell.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/15.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kNeedHideNum 50

@interface DZNewsCell : UITableViewCell
@property (nonatomic, strong) RACSubject *clickSubject;
@property (nonatomic, assign) NSInteger row;
- (void)configView:(id)model;
@end
