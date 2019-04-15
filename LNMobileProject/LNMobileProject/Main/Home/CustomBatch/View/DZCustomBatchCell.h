//
//  DZTimeLimitCell.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZCustomBatchCell : UITableViewCell
@property (nonatomic, strong) RACSubject *clickSubject;
- (void)configView:(id)model;
@end
