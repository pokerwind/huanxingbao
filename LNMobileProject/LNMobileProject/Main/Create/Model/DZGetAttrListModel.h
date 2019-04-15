//
//  DZGetAttrListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZAttrListModel : NSObject

@property (strong, nonatomic) NSString *attr_id;
@property (strong, nonatomic) NSString *attr_name;
@property (strong, nonatomic) NSArray *values;

@property (strong, nonatomic) NSString *selectedValue;

@end

@interface DZGetAttrListModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
