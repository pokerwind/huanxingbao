//
//  DZAddMyAddressVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/18.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"
#import "DZGetAddressListModel.h"

@protocol DZAddMyAddressVCDelegate <NSObject>

- (void)didUpdateAddress;

@end

@interface DZAddMyAddressVC : LNBaseVC

@property (nonatomic, strong) NSString *addressId;
@property (nonatomic) id <DZAddMyAddressVCDelegate>delegate;

@end
