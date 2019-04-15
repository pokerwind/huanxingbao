//
//  DZGoodsDetailBottomView.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^JSPopSelectBlock)(void);
@interface DZGoodsDetailBottomView : UIView
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UIButton *catButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UIButton *gouwucheBtn;
/*
 * JSPopSelectBlock
 */
@property (nonatomic,copy)JSPopSelectBlock block;

@end
