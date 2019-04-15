//
//  DZAddressSelectionVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"
#import "DZGetAddressListModel.h"

@protocol DZAddressSelectionVCDelegate <NSObject>

- (void)didSelectAddress:(DZMyAddressItemModel *)model;

@end

@interface DZAddressSelectionVC : LNBaseVC

@property (nonatomic) id <DZAddressSelectionVCDelegate>delegate;

@property (strong, nonatomic) NSString *currentAddressId;

@end
