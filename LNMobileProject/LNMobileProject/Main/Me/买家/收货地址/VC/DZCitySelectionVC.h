//
//  DZCitySelectionVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZCitySelectionVCDelegate <NSObject>

- (void)didSelectionProvince:(NSString *)province city:(NSString *)city;
- (void)didSelectionProvince:(NSString *)province city:(NSString *)city area:(NSString *)area;
@end

@interface DZCitySelectionVC : LNBaseVC

@property (strong, nonatomic) id districtDelegateVC;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *regionId;
@property (nonatomic) BOOL isUtilCity;//是否只选择到市

@property (weak, nonatomic) id <DZCitySelectionVCDelegate>delegate;

@end
