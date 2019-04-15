//
//  DZMyAddressCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZMyAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

- (void)fillName:(NSString *)name mobile:(NSString *)mobile address:(NSString *)address isDefault:(BOOL)isDefault;

@end
