//
//  DZMyHistoryEditingVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/18.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZMyHistoryEditingVCDelegate <NSObject>

- (void)didDeleteHistory;

@end

@interface DZMyHistoryEditingVC : LNBaseVC

@property (nonatomic) id<DZMyHistoryEditingVCDelegate>delegate;

@end
