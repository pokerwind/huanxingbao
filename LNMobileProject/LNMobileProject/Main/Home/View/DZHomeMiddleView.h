//
//  DZHomeMiddleView.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DKLeftBlock)(NSString *JsonModel);
typedef void (^DKRightBlock)(NSString *JsonModel);


@interface DZHomeMiddleView : UIView

/*
 * DKLeftBlock
 */
@property (nonatomic,copy)DKLeftBlock leftBlock;

/*
 * DKRightBlock
 */
@property (nonatomic,copy)DKRightBlock rightBlock;

@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;

@property (weak, nonatomic) IBOutlet UILabel *leftName;

@property (weak, nonatomic) IBOutlet UILabel *leftOrginalPriceL;

@property (weak, nonatomic) IBOutlet UILabel *leftNowPriceL;

@property (weak, nonatomic) IBOutlet UILabel *leftHourL;

@property (weak, nonatomic) IBOutlet UILabel *leftMinL;

@property (weak, nonatomic) IBOutlet UILabel *leftSecondL;


@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;

@property (weak, nonatomic) IBOutlet UILabel *rightNameL;

@property (weak, nonatomic) IBOutlet UILabel *rightOrginalPriceL;

@property (weak, nonatomic) IBOutlet UILabel *rightNowPriceL;

@property (weak, nonatomic) IBOutlet UILabel *rightHourL;

@property (weak, nonatomic) IBOutlet UILabel *rightMinL;

@property (weak, nonatomic) IBOutlet UILabel *rightSecondL;


//@property (weak, nonatomic) IBOutlet UIButton *timeLimitButton;
//@property (weak, nonatomic) IBOutlet UIButton *customButton;
//
//@property (weak, nonatomic) IBOutlet UIImageView *right1ImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *right2ImageView;
//
//@property (weak, nonatomic) IBOutlet UIImageView *left1ImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *left2ImageView;
//
//@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
//@property (weak, nonatomic) IBOutlet UILabel *minLabel;
//@property (weak, nonatomic) IBOutlet UILabel *secLabel;

@end
