//
//  DZFreightAddressVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZFreightAddressVCDelegate <NSObject>

- (void)didSelectedArea:(NSArray *)area atIndex:(NSInteger)index;

@end

@interface DZFreightAddressVC : LNBaseVC

@property (nonatomic) NSInteger index;
@property (nonatomic) id <DZFreightAddressVCDelegate>delegate;

@property (nonatomic, strong) NSArray *selectedArray;//已选中的地区

@end
