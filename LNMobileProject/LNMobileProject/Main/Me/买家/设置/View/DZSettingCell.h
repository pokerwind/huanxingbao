//
//  DZSettingCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/10.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZSettingCell : UITableViewCell

+ (NSString *)cellIdentifier;

- (void)fillTitle:(NSString *)title detailTitle:(NSString *)detailTitle;

@end
