//
//  DZSubmitOrderInnerCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZCartConfirmModel.h"

@interface DZSubmitOrderInnerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *modifyButton;

- (void)fillData:(DZCartConfirmGoodModel *)model;

@end
