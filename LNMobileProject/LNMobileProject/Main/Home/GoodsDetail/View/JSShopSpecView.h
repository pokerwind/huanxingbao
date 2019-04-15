//
//  JSShopSpecView.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/30.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^JSShopSpecBlock)(void);
@interface JSShopSpecView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameL;

/*
 * JSShopSpecBlock
 */
@property (nonatomic,copy)JSShopSpecBlock block;

@end

NS_ASSUME_NONNULL_END
