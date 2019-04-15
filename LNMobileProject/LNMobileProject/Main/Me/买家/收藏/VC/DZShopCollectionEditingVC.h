//
//  DZShopCollectionEditingVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZShopCollectionEditingVCDelegate <NSObject>

- (void)didDeleteShops;

@end

@interface DZShopCollectionEditingVC : LNBaseVC

@property (nonatomic) id <DZShopCollectionEditingVCDelegate>delegate;

@end
