//
//  DZGetRegionListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZRegionModel : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *region_name;

@property (nonatomic) BOOL isSelected;

@end

@interface DZGetRegionListModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
