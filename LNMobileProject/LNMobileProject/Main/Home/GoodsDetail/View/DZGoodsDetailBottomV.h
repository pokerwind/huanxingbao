//
//  DZGoodsDetailBottomV.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/2/14.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^JSBtnClickBlock)(void);
@interface DZGoodsDetailBottomV : UIView
@property (weak, nonatomic) IBOutlet UIButton *btn;
/*
 * JSBtnClickBlock
 */
@property (nonatomic,copy)JSBtnClickBlock block;
@end

NS_ASSUME_NONNULL_END
