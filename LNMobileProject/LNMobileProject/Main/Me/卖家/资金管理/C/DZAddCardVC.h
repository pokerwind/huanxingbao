//
//  DZAddCardVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZAddCardVCDelegate <NSObject>

- (void)didAddCard;

@end

@interface DZAddCardVC : LNBaseVC

@property (nonatomic) id <DZAddCardVCDelegate>delegate;

@end
