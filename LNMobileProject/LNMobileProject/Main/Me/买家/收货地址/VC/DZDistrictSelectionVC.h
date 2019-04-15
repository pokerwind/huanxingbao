//
//  DZDistrictSelectionVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

#import "DZGetRegionListModel.h"

@protocol DZDistrictSelectionVCDelegate <NSObject>

- (void)didSelectionProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;

- (void)didSelectionProvince:(NSString *)province city:(NSString *)city district:(NSString *)district AndIDProvinceID:(NSString *)provinceid cityID:(NSString *)cityID districtID:(NSString *)districtID;

@end

@interface DZDistrictSelectionVC : LNBaseVC

@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *provinceID;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *cityID;
@property (strong, nonatomic) NSString *regionId;

@property (weak, nonatomic) id <DZDistrictSelectionVCDelegate>delegate;

@end
