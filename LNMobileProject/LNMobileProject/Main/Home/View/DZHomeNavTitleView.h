//
//  DZHomeNavTitleView.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^JSGoShopBlock)(void);
@interface DZHomeNavTitleView : UIView
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *goMap;

/*
 * 注释
 */
@property (nonatomic,assign)NSInteger unReadNum;

/*
 * JSGoShopBlock
 */
@property (nonatomic,copy)JSGoShopBlock block;
@end
