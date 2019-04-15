//
//  DZWithdrawVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZWithdrawVCDelegate <NSObject>

- (void)didWithdrawSuccess;

@end

@interface DZWithdrawVC : LNBaseVC

@property (nonatomic) id <DZWithdrawVCDelegate>delegate;

@end
