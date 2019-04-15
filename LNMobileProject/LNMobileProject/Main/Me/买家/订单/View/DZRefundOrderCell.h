//
//  DZRefundOrderCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetAllRefundListModel.h"

@protocol DZRefundOrderCellDelegate <NSObject>

@required
- (void)didChangeOrder:(NSString *)order_sn withOperationCode:(NSInteger)code;
- (void)didSelectCellOrderSn:(NSString *)orderSn orderGoodId:(NSString *)orderGoodId;

@end

@interface DZRefundOrderCell : UITableViewCell

@property (nonatomic) id <DZRefundOrderCellDelegate>delegate;

- (void)fillData:(DZRefundItemModel *)model isSeller:(BOOL)isSeller;

@end
