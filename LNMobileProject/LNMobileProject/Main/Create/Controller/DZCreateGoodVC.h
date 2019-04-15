//
//  DZCreateGoodVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/28.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZCreateGoodVCDelegate <NSObject>

- (void)didAddGood;
- (void)didModifyGood;

@end

@interface DZCreateGoodVC : LNBaseVC

@property (nonatomic) BOOL isEditMode;//是否为编辑模式
@property (strong, nonatomic) NSString *goodId;
@property (nonatomic) id <DZCreateGoodVCDelegate>delegate;

@end
