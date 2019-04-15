//
//  DZSubmitOrderCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZCartConfirmModel.h"

@protocol DZSubmitOrderCellDelegate <NSObject>

- (void)modifyFrameWithGroup:(NSInteger)group goodIndex:(NSInteger)goodIndex;

@end

@interface DZSubmitOrderCell : UITableViewCell

- (void)fillData:(DZCartConfirmShopModel *)model;

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (nonatomic) id <DZSubmitOrderCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutC;

@end
