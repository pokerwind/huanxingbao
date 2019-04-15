//
//  DZOrderDetailVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZOrderDetailVC : LNBaseVC

@property (nonatomic, strong) NSString *order_sn;
@property (nonatomic) BOOL isPreviewMode;//是否为预览模式（即退货退款列表进入）
@property (nonatomic) BOOL is_evaluation;//是否已评价

@end
