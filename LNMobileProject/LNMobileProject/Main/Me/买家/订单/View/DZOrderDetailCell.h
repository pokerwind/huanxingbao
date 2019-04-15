//
//  DZOrderDetailCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetOrderDetailModel.h"

@protocol  DZOrderDetailCellDelegate <NSObject>

- (void)refundWithIndex:(NSInteger)index;
- (void)didClickGood:(NSString *)goodId;

@end

@interface DZOrderDetailCell : UITableViewCell

@property (nonatomic) BOOL canRefund;//是否能退货退款
@property (weak, nonatomic) id <DZOrderDetailCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

- (void)fillData:(DZGetOrderDetailModel *)model;

@end
