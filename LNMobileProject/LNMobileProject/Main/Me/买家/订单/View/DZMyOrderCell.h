//
//  DZMyOrderCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/10.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetOrderListModel.h"

@protocol MrOrderCellDelegate <NSObject>

- (void)didChangeOrder:(NSString *)order_sn withOperationCode:(NSInteger)code;

@end

@interface DZMyOrderCell : UITableViewCell

@property (nonatomic, weak) id <MrOrderCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutC;

- (void)fillData:(DZOrderListItemModel *)model;

@end
