//
//  DZSearchResultFilterView.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZSearchResultFilterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *entityButton;
@property (weak, nonatomic) IBOutlet UIButton *factoryButton;
@property (weak, nonatomic) IBOutlet UIButton *webButton;

@property (weak, nonatomic) IBOutlet UIButton *sizeButton1;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton2;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton3;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton4;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton5;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton6;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton7;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton8;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton9;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton10;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton11;

@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (weak, nonatomic) IBOutlet UITextField *startPriceTextFileld;
@property (weak, nonatomic) IBOutlet UITextField *endPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *batchNumTextField;


@property (nonatomic, assign) NSInteger shop_type;
@property (nonatomic, strong) NSString *goods_size;

@property (nonatomic, strong) RACSubject *clearSubject;
@end
